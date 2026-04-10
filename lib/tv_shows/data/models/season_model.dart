import 'package:kinobaza/tv_shows/domain/entities/season.dart';

class SeasonModel extends Season {
  const SeasonModel({
    required super.tmdbID,
    required super.name,
    required super.episodeCount,
    required super.airDate,
    required super.overview,
    required super.posterUrl,
    required super.seasonNumber,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      tmdbID: json['kinopoiskId'] ?? 0,
      name: 'Сезон ${json['number'] ?? ''}',
      episodeCount: (json['episodes'] as List?)?.length ?? 0,
      airDate: '',
      overview: '',
      posterUrl: '',
      seasonNumber: json['number'] ?? 0,
    );
  }
}