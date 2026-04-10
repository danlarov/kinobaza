import 'package:kinobaza/tv_shows/domain/entities/episode.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.number,
    required super.season,
    required super.name,
    required super.runtime,
    required super.stillPath,
    required super.airDate,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      number: json['episodeNumber'] ?? json['number'] ?? 0,
      season: json['seasonNumber'] ?? json['season'] ?? 0,
      name: json['nameRu'] ?? json['nameEn'] ?? 'Эпизод',
      runtime: json['runtime'] != null ? '${json['runtime']} мин' : '',
      stillPath: json['stillUrl'] ?? '',
      airDate: json['releaseDate'] ?? json['date'] ?? '',
    );
  }

  // Пустой эпизод — используется когда данных нет
  factory EpisodeModel.empty() {
    return const EpisodeModel(
      number: 0,
      season: 0,
      name: '',
      runtime: '',
      stillPath: '',
      airDate: '',
    );
  }
}