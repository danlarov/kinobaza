import 'package:dio/dio.dart';
import 'package:kinobaza/core/error/exceptions.dart';
import 'package:kinobaza/movies/data/models/movie_details_model.dart';
import 'package:kinobaza/core/network/api_constants.dart';
import 'package:kinobaza/core/network/error_message_model.dart';
import 'package:kinobaza/movies/data/models/cast_model.dart';
import 'package:kinobaza/movies/data/models/review_model.dart';
import 'package:kinobaza/movies/data/models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<List<MovieModel>> getPremieres();
  Future<List<List<MovieModel>>> getMovies();
  Future<MovieDetailsModel> getMovieDetails(int movieId);
  Future<List<MovieModel>> getAllPopularMovies(int page);
  Future<List<MovieModel>> getAllTopRatedMovies(int page);
}

class MoviesRemoteDataSourceImpl extends MoviesRemoteDataSource {
  final Dio dio;

  MoviesRemoteDataSourceImpl(this.dio);

  List<MovieModel> _parseFilms(dynamic data) {
    final list = data['films'] ?? data['items'] ?? [];
    return List<MovieModel>.from(
      (list as List).map((e) => MovieModel.fromJson(e)),
    );
  }

  Future<Response> _safeGet(String path, {Map<String, dynamic>? params}) async {
    try {
      return await dio.get(path, queryParameters: params);
    } catch (_) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 404,
        data: {},
      );
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      final response = await dio.get(
        ApiConstants.nowPlayingMoviesPath,
        queryParameters: {
          'order': 'NUM_VOTE',
          'type': 'FILM',
          'ratingFrom': 6,
          'ratingTo': 10,
          'yearFrom': 2024,
          'yearTo': 2025,
          'page': 1,
        },
      );
      if (response.statusCode == 200) {
        return _parseFilms(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          e.response?.data ?? {'message': 'Ошибка загрузки'},
        ),
      );
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await dio.get(
      ApiConstants.popularMoviesPath,
      queryParameters: {'type': 'TOP_100_POPULAR_FILMS', 'page': 1},
    );
    if (response.statusCode == 200) {
      return _parseFilms(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await dio.get(
      ApiConstants.topRatedMoviesPath,
      queryParameters: {'type': 'TOP_250_BEST_FILMS', 'page': 1},
    );
    if (response.statusCode == 200) {
      return _parseFilms(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<List<MovieModel>>> getMovies() async {
    return Future.wait([
      getNowPlayingMovies(),
      getPopularMovies(),
      getTopRatedMovies(),
      getPremieres(),
    ]);
  }

  @override
  Future<List<MovieModel>> getPremieres() async {
    try {
      final response = await dio.get(
        ApiConstants.premieresPath,
        queryParameters: {
          'year': 2026,
          'month': 'APRIL',
        },
      );
      if (response.statusCode == 200) {
        return List<MovieModel>.from(
          ((response.data['items'] ?? []) as List)
              .map((e) => MovieModel.fromJson(e)),
        );
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    try {
      final detailsResponse = await dio.get(
        ApiConstants.movieDetailsPath(movieId),
      );

      if (detailsResponse.statusCode != 200) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            detailsResponse.data ?? {'message': 'Not found'},
          ),
        );
      }

      // 6 параллельных запросов (без видео)
      final responses = await Future.wait([
        _safeGet(ApiConstants.movieCastPath(movieId)),
        _safeGet(ApiConstants.movieReviewsPath(movieId)),
        _safeGet(ApiConstants.similarMoviesPath(movieId)),
        _safeGet(ApiConstants.imagesPath(movieId),
            params: {'type': 'STILL', 'page': 1}),
        _safeGet(ApiConstants.factsPath(movieId)),
        _safeGet(ApiConstants.sequelsAndPrequelsPath(movieId)),
        _safeGet(ApiConstants.videosPath(movieId)),
      ]);

      final castResponse     = responses[0];
      final reviewsResponse  = responses[1];
      final similarResponse  = responses[2];
      final imagesResponse   = responses[3];
      final factsResponse    = responses[4];
      final sequelsResponse  = responses[5];
      final videosResponse   = responses[6];


      // Каст
      final castList = castResponse.statusCode == 200
          ? List<CastModel>.from(
        (castResponse.data as List).map((e) => CastModel.fromJson(e)),
      )
          : <CastModel>[];

      // Отзывы
      final reviewsList = reviewsResponse.statusCode == 200
          ? List<ReviewModel>.from(
        ((reviewsResponse.data['reviews'] ?? []) as List)
            .map((e) => ReviewModel.fromJson(e)),
      )
          : <ReviewModel>[];


      // Похожие фильмы
      final similarList = similarResponse.statusCode == 200
          ? List<MovieModel>.from(
        ((similarResponse.data['items'] ?? []) as List)
            .map((e) => MovieModel.fromJson(e)),
      )
          : <MovieModel>[];

      // Изображения
      final imagesList = imagesResponse.statusCode == 200
          ? List<String>.from(
        ((imagesResponse.data['items'] ?? []) as List)
            .map((e) => e['imageUrl']?.toString() ?? '')
            .where((url) => url.isNotEmpty),
      )
          : <String>[];

      // Факты
      final factsList = factsResponse.statusCode == 200
          ? List<String>.from(
        ((factsResponse.data['items'] ?? []) as List)
            .map((e) => e['text']?.toString() ?? '')
            .where((t) => t.isNotEmpty),
      )
          : <String>[];

      // Сиквелы и приквелы
      final sequelsList = sequelsResponse.statusCode == 200
          ? List<MovieModel>.from(
        ((sequelsResponse.data as List? ?? []))
            .map((e) => MovieModel.fromJson(e)),
      )
          : <MovieModel>[];

      // Режиссёр из каста
      final director = castList
          .where((c) => c.staffRole == 'DIRECTOR')
          .map((c) => c.name)
          .firstOrNull;

      // Страна из деталей
      final country = (detailsResponse.data['countries'] as List<dynamic>?)
          ?.map((c) => c['country']?.toString() ?? '')
          .where((c) => c.isNotEmpty)
          .join(', ');

      return MovieDetailsModel.fromJson(
        detailsResponse.data,
        cast: castList,
        reviews: reviewsList,
        similar: similarList,
        images: imagesList,
        facts: factsList,
        sequelsAndPrequels: sequelsList,
        videos: videosResponse.statusCode == 200
            ? List<Map<String, String>>.from(
          ((videosResponse.data['items'] ?? []) as List)
              .where((e) => e['site'] == 'KINOPOISK_WIDGET')
              .map((e) => {
            'name': e['name']?.toString() ?? '',
            'url': e['url']?.toString() ?? '',
          }),
        )
            : <Map<String, String>>[],
        director: director,
        country: country,
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          e.response?.data ?? {'message': 'Фильм не найден'},
        ),
      );
    }
  }

  @override
  Future<List<MovieModel>> getAllPopularMovies(int page) async {
    final response = await dio.get(
      ApiConstants.popularMoviesPath,
      queryParameters: {'type': 'TOP_100_POPULAR_FILMS', 'page': page},
    );
    if (response.statusCode == 200) {
      return _parseFilms(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getAllTopRatedMovies(int page) async {
    final response = await dio.get(
      ApiConstants.topRatedMoviesPath,
      queryParameters: {'type': 'TOP_250_BEST_FILMS', 'page': page},
    );
    if (response.statusCode == 200) {
      return _parseFilms(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}