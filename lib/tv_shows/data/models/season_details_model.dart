import 'package:kinobaza/tv_shows/data/models/episode_model.dart';
import 'package:kinobaza/tv_shows/domain/entities/season_details.dart';

class SeasonDetailsModel extends SeasonDetails {
  const SeasonDetailsModel({
    required super.episodes,
  });

  factory SeasonDetailsModel.fromJson(Map<String, dynamic> json) {
    // У Кинопоиска эпизоды внутри каждого сезона в поле 'episodes'
    // Ответ приходит как список сезонов, берём нужный
    final episodes = json['episodes'] as List? ?? [];
    return SeasonDetailsModel(
      episodes: List<EpisodeModel>.from(
        episodes.map((e) => EpisodeModel.fromJson(e)),
      ),
    );
  }

  // Парсим из списка сезонов по номеру сезона
  factory SeasonDetailsModel.fromSeasons(
      List<dynamic> seasons,
      int seasonNumber,
      ) {
    final season = seasons.firstWhere(
          (s) => s['number'] == seasonNumber,
      orElse: () => {'episodes': []},
    );
    final episodes = season['episodes'] as List? ?? [];
    return SeasonDetailsModel(
      episodes: List<EpisodeModel>.from(
        episodes.map((e) => EpisodeModel.fromJson(e)),
      ),
    );
  }
}