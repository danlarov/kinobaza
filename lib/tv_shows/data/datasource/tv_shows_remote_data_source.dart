import 'package:dio/dio.dart';
import 'package:kinobaza/core/error/exceptions.dart';
import 'package:kinobaza/core/network/api_constants.dart';
import 'package:kinobaza/core/network/error_message_model.dart';
import 'package:kinobaza/movies/data/models/cast_model.dart';
import 'package:kinobaza/movies/data/models/movie_model.dart';
import 'package:kinobaza/movies/data/models/review_model.dart';
import 'package:kinobaza/tv_shows/data/models/season_details_model.dart';
import 'package:kinobaza/tv_shows/data/models/tv_show_details_model.dart';
import 'package:kinobaza/tv_shows/data/models/tv_show_model.dart';

abstract class TVShowsRemoteDataSource {
  Future<List<TVShowModel>> getOnAirTVShows();
  Future<List<TVShowModel>> getPopularTVShows();
  Future<List<TVShowModel>> getTopRatedTVShows();
  Future<List<List<TVShowModel>>> getTVShows();
  Future<TVShowDetailsModel> getTVShowDetails(int id);
  Future<SeasonDetailsModel> getSeasonDetails(int id, int seasonNumber);
  Future<List<TVShowModel>> getAllPopularTVShows(int page);
  Future<List<TVShowModel>> getAllTopRatedTVShows(int page);
}

class TVShowsRemoteDataSourceImpl extends TVShowsRemoteDataSource {
  final Dio dio;

  TVShowsRemoteDataSourceImpl(this.dio);

  List<TVShowModel> _parseShows(dynamic data) {
    final list = data['films'] ?? data['items'] ?? [];
    return List<TVShowModel>.from(
      (list as List).map((e) => TVShowModel.fromJson(e)),
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
  Future<List<TVShowModel>> getOnAirTVShows() async {
    final response = await dio.get(
      ApiConstants.onAirTvShowsPath,
      queryParameters: {
        'order': 'NUM_VOTE',
        'type': 'TV_SERIES',
        'ratingFrom': 7,
        'ratingTo': 10,
        'yearFrom': 2020,
        'yearTo': 2025,
        'page': 1,
      },
    );
    if (response.statusCode == 200) {
      return _parseShows(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<TVShowModel>> getPopularTVShows() async {
    final response = await dio.get(
      ApiConstants.popularTvShowsPath,
      queryParameters: {
        'order': 'NUM_VOTE',
        'type': 'TV_SERIES',
        'ratingFrom': 7,
        'ratingTo': 10,
        'page': 1,
      },
    );
    if (response.statusCode == 200) {
      return _parseShows(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<TVShowModel>> getTopRatedTVShows() async {
    final response = await dio.get(
      ApiConstants.topRatedTvShowsPath,
      queryParameters: {
        'order': 'RATING',
        'type': 'TV_SERIES',
        'ratingFrom': 8,
        'ratingTo': 10,
        'page': 1,
      },
    );
    if (response.statusCode == 200) {
      return _parseShows(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<List<TVShowModel>>> getTVShows() async {
    return Future.wait([
      getOnAirTVShows(),
      getPopularTVShows(),
      getTopRatedTVShows(),
    ], eagerError: true);
  }

  @override
  Future<TVShowDetailsModel> getTVShowDetails(int id) async {
    try {
      final detailsResponse = await dio.get(ApiConstants.tvShowDetailsPath(id));

      if (detailsResponse.statusCode != 200) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(detailsResponse.data),
        );
      }

      // 7 параллельных запросов
      final responses = await Future.wait([
        _safeGet(ApiConstants.movieCastPath(id)),
        _safeGet(ApiConstants.movieReviewsPath(id)),
        _safeGet(ApiConstants.similarMoviesPath(id)),
        _safeGet(ApiConstants.imagesPath(id), params: {'type': 'STILL', 'page': 1}),
        _safeGet(ApiConstants.factsPath(id)),
        _safeGet(ApiConstants.sequelsAndPrequelsPath(id)),
        _safeGet(ApiConstants.videosPath(id)),
      ]);

      final castResponse    = responses[0];
      final reviewsResponse = responses[1];
      final similarResponse = responses[2];
      final imagesResponse  = responses[3];
      final factsResponse   = responses[4];
      final sequelsResponse = responses[5];
      final videosResponse  = responses[6];

      // Каст
      final castList = castResponse.statusCode == 200
          ? List<CastModel>.from(
        (castResponse.data as List).map((e) => CastModel.fromJson(e)),
      )
          : <CastModel>[];

      // Отзывы
      final reviewsList = reviewsResponse.statusCode == 200
          ? List<ReviewModel>.from(
        ((reviewsResponse.data['reviews'] ?? reviewsResponse.data['items'] ?? []) as List)
            .map((e) => ReviewModel.fromJson(e)),
      )
          : <ReviewModel>[];

      // Похожие
      final similarList = similarResponse.statusCode == 200
          ? List<TVShowModel>.from(
        ((similarResponse.data['items'] ?? []) as List)
            .map((e) => TVShowModel.fromJson(e)),
      )
          : <TVShowModel>[];

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

      // Режиссёр
      final director = castList
          .where((c) => c.staffRole == 'DIRECTOR')
          .map((c) => c.name)
          .firstOrNull;

      // Страна
      final country = (detailsResponse.data['countries'] as List<dynamic>?)
          ?.map((c) => c['country']?.toString() ?? '')
          .where((c) => c.isNotEmpty)
          .join(', ');

      return TVShowDetailsModel.fromJson(
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
          e.response?.data ?? {'message': 'Сериал не найден'},
        ),
      );
    }
  }

  @override
  Future<SeasonDetailsModel> getSeasonDetails(int id, int seasonNumber) async {
    final response = await dio.get(
      ApiConstants.seasonDetailsPath(id: id, seasonNumber: seasonNumber),
    );
    if (response.statusCode == 200) {
      return SeasonDetailsModel.fromSeasons(
        response.data['items'] ?? [],
        seasonNumber,
      );
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<TVShowModel>> getAllPopularTVShows(int page) async {
    final response = await dio.get(
      ApiConstants.popularTvShowsPath,
      queryParameters: {
        'order': 'NUM_VOTE',
        'type': 'TV_SERIES',
        'ratingFrom': 7,
        'ratingTo': 10,
        'page': page,
      },
    );
    if (response.statusCode == 200) {
      return _parseShows(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<TVShowModel>> getAllTopRatedTVShows(int page) async {
    final response = await dio.get(
      ApiConstants.topRatedTvShowsPath,
      queryParameters: {
        'order': 'RATING',
        'type': 'TV_SERIES',
        'ratingFrom': 8,
        'ratingTo': 10,
        'page': page,
      },
    );
    if (response.statusCode == 200) {
      return _parseShows(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}