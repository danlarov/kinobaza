import 'package:kinobaza/core/domain/entities/media.dart';

class TVShowModel extends Media {
  const TVShowModel({
    required super.tmdbID,
    required super.title,
    required super.posterUrl,
    required super.backdropUrl,
    required super.voteAverage,
    required super.releaseDate,
    required super.overview,
    required super.isMovie,
  });

  factory TVShowModel.fromJson(Map<String, dynamic> json) {
    return TVShowModel(
      tmdbID: json['kinopoiskId'] ?? json['filmId'] ?? 0,
      title: json['nameRu'] ?? json['nameEn'] ?? json['nameOriginal'] ?? 'Без названия',
      posterUrl: json['posterUrl'] ?? json['posterUrlPreview'] ?? '',
      backdropUrl: json['coverUrl'] ?? json['posterUrl'] ?? '',
      voteAverage: (json['ratingKinopoisk'] ?? json['ratingImdb'] ?? 0.0).toDouble(),
      releaseDate: json['year']?.toString() ?? '',
      overview: json['description'] ?? json['shortDescription'] ?? '',
      isMovie: false,
    );
  }
}