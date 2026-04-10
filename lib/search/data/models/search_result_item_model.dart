import 'package:kinobaza/search/domain/entities/search_result_item.dart';

class SearchResultItemModel extends SearchResultItem {
  const SearchResultItemModel({
    required super.tmdbID,
    required super.posterUrl,
    required super.title,
    required super.isMovie,
  });

  factory SearchResultItemModel.fromJson(Map<String, dynamic> json) {
    return SearchResultItemModel(
      tmdbID: json['kinopoiskId'] ?? json['filmId'] ?? 0,
      posterUrl: json['posterUrl'] ?? json['posterUrlPreview'] ?? '',
      title: json['nameRu'] ?? json['nameEn'] ?? json['nameOriginal'] ?? 'Без названия',
      isMovie: json['type'] == 'FILM' || json['type'] == 'VIDEO',
    );
  }
}