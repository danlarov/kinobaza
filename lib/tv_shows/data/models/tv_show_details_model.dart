import 'package:kinobaza/core/domain/entities/media_details.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/movies/data/models/cast_model.dart';
import 'package:kinobaza/movies/data/models/movie_model.dart';
import 'package:kinobaza/movies/data/models/review_model.dart';
import 'package:kinobaza/tv_shows/data/models/tv_show_model.dart';
import 'package:kinobaza/tv_shows/data/models/episode_model.dart';
import 'package:kinobaza/tv_shows/data/models/season_model.dart';

// ignore: must_be_immutable
class TVShowDetailsModel extends MediaDetails {
  TVShowDetailsModel({
    required super.tmdbID,
    required super.title,
    required super.posterUrl,
    required super.backdropUrl,
    required super.releaseDate,
    required super.lastEpisodeToAir,
    required super.genres,
    required super.overview,
    required super.voteAverage,
    required super.voteCount,
    required super.trailerUrl,
    required super.numberOfSeasons,
    required super.seasons,
    required super.similar,
    super.cast,
    super.reviews,
    super.images = const [],
    super.facts = const [],
    super.sequelsAndPrequels = const [],
    super.videos = const [],
    super.director,
    super.country,
    super.webUrl,
  });

  factory TVShowDetailsModel.fromJson(
      Map<String, dynamic> json, {
        List<TVShowModel> similar = const [],
        List<SeasonModel> seasons = const [],
        List<CastModel> cast = const [],
        List<ReviewModel> reviews = const [],
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

    final rating = (json['ratingKinopoisk'] ?? json['ratingImdb'] ?? 0.0);
    final voteAverage = double.parse(rating.toDouble().toStringAsFixed(1));

    final voteCount = json['ratingKinopoiskVoteCount'] ?? 0;

    final countryFromJson = country ??
        (json['countries'] as List<dynamic>?)
            ?.map((c) => c['country']?.toString() ?? '')
            .where((c) => c.isNotEmpty)
            .join(', ');

    final webUrl = json['webUrl']?.toString();

    return TVShowDetailsModel(
      tmdbID: json['kinopoiskId'] ?? json['filmId'] ?? 0,
      title: json['nameRu'] ?? json['nameEn'] ?? json['nameOriginal'] ?? 'Без названия',
      posterUrl: json['posterUrl'] ?? json['posterUrlPreview'] ?? '',
      backdropUrl: json['coverUrl'] ?? json['posterUrl'] ?? '',
      releaseDate: json['year']?.toString() ?? '',
      lastEpisodeToAir: EpisodeModel.empty(),
      genres: genresList,
      numberOfSeasons: seasons.length,
      voteAverage: voteAverage,
      voteCount: voteCount.toString(),
      overview: json['description'] ?? json['shortDescription'] ?? '',
      trailerUrl: trailerUrl,
      seasons: seasons,
      similar: similar,
      cast: cast,
      reviews: reviews,
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