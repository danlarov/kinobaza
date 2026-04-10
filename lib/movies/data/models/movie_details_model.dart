import 'package:kinobaza/core/domain/entities/media_details.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/movies/data/models/movie_model.dart';
import 'package:kinobaza/movies/data/models/review_model.dart';
import 'package:kinobaza/movies/data/models/cast_model.dart';

// ignore: must_be_immutable
class MovieDetailsModel extends MediaDetails {
  MovieDetailsModel({
    required super.tmdbID,
    required super.title,
    required super.posterUrl,
    required super.backdropUrl,
    required super.releaseDate,
    required super.genres,
    required super.runtime,
    required super.overview,
    required super.voteAverage,
    required super.voteCount,
    required super.trailerUrl,
    required super.cast,
    required super.reviews,
    required super.similar,
    super.images = const [],
    super.facts = const [],
    super.sequelsAndPrequels = const [],
    super.videos = const [],
    super.director,
    super.country,
    super.webUrl,
  });

  factory MovieDetailsModel.fromJson(
      Map<String, dynamic> json, {
        List<CastModel> cast = const [],
        List<ReviewModel> reviews = const [],
        List<MovieModel> similar = const [],
        List<String> images = const [],
        List<String> facts = const [],
        List<MovieModel> sequelsAndPrequels = const [],
        List<Map<String, String>> videos = const [],
        String? director,
        String? country,
        String trailerUrl = '',
      }) {
    final genresList = (json['genres'] as List<dynamic>? ?? [])
        .map((g) => g['genre']?.toString() ?? '')
        .where((g) => g.isNotEmpty)
        .join(', ');

    final runtime = json['filmLength'] != null
        ? '${json['filmLength']} мин'
        : '';

    final rating = (json['ratingKinopoisk'] ?? json['ratingImdb'] ?? 0.0);
    final voteAverage = double.parse(rating.toDouble().toStringAsFixed(1));

    final voteCount = json['ratingKinopoiskVoteCount'] ?? 0;

    final countryFromJson = country ??
        (json['countries'] as List<dynamic>?)
            ?.map((c) => c['country']?.toString() ?? '')
            .where((c) => c.isNotEmpty)
            .join(', ');

    final webUrl = json['webUrl']?.toString();

    return MovieDetailsModel(
      tmdbID: json['kinopoiskId'] ?? json['filmId'] ?? 0,
      title: json['nameRu'] ?? json['nameEn'] ?? json['nameOriginal'] ?? 'Без названия',
      posterUrl: json['posterUrl'] ?? json['posterUrlPreview'] ?? '',
      backdropUrl: json['coverUrl'] ?? json['posterUrl'] ?? '',
      releaseDate: json['year']?.toString() ?? '',
      genres: genresList,
      runtime: runtime,
      overview: json['description'] ?? json['shortDescription'] ?? '',
      voteAverage: voteAverage,
      voteCount: voteCount.toString(),
      trailerUrl: trailerUrl,
      cast: cast,
      reviews: reviews,
      similar: similar,
      images: images,
      facts: facts,
      sequelsAndPrequels: sequelsAndPrequels,
      videos: videos,
      director: director,
      country: countryFromJson,
      webUrl: webUrl,
    );
  }
}