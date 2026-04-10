import 'package:kinobaza/core/domain/entities/media.dart';

class MovieModel extends Media {
  const MovieModel({
    required super.tmdbID,
    required super.title,
    required super.posterUrl,
    required super.backdropUrl,
    required super.voteAverage,
    required super.releaseDate,
    required super.overview,
    required super.isMovie,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final id = json['kinopoiskId'] ?? json['filmId'] ?? 0;
    final voteAverage = double.tryParse(
        (json['ratingKinopoisk'] ?? json['rating'] ?? json['ratingImdb'] ?? 0).toString()
    ) ?? 0.0;

    return MovieModel(
      tmdbID: id,
      title: json['nameRu'] ?? json['nameEn'] ?? json['nameOriginal'] ?? 'Без названия',
      posterUrl: json['posterUrl'] ?? json['posterUrlPreview'] ?? '',
      backdropUrl: json['coverUrl'] ?? json['posterUrl'] ?? '',
      voteAverage: voteAverage,
      releaseDate: json['year']?.toString() ?? '',
      overview: json['description'] ?? json['shortDescription'] ?? '',
      isMovie: true,
    );
  }
}