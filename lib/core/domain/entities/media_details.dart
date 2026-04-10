import 'package:equatable/equatable.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/movies/domain/entities/cast.dart';
import 'package:kinobaza/movies/domain/entities/review.dart';
import 'package:kinobaza/tv_shows/domain/entities/episode.dart';
import 'package:kinobaza/tv_shows/domain/entities/season.dart';

// ignore: must_be_immutable
class MediaDetails extends Equatable {
  int? id;
  final int tmdbID;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String releaseDate;
  final Episode? lastEpisodeToAir;
  final String genres;
  final String? runtime;
  final int? numberOfSeasons;
  final String overview;
  final double voteAverage;
  final String voteCount;
  final String trailerUrl;
  final List<Cast>? cast;
  final List<Review>? reviews;
  final List<Season>? seasons;
  final List<Media> similar;
  bool isBookmarked;

  // Новые поля
  final List<String> images;
  final List<String> facts;
  final List<Media> sequelsAndPrequels;
  final List<Map<String, String>> videos;
  final String? director;
  final String? country;
  final int? budgetAmount;
  final String? budgetCurrency;
  final String? webUrl;

  MediaDetails({
    this.id,
    required this.tmdbID,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.releaseDate,
    this.lastEpisodeToAir,
    required this.genres,
    this.runtime,
    this.numberOfSeasons,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.trailerUrl,
    this.cast,
    this.reviews,
    this.seasons,
    required this.similar,
    this.isBookmarked = false,
    this.images = const [],
    this.facts = const [],
    this.sequelsAndPrequels = const [],
    this.videos = const [],
    this.director,
    this.country,
    this.budgetAmount,
    this.budgetCurrency,
    this.webUrl,
  });

  @override
  List<Object?> get props => [
    id,
    tmdbID,
    title,
    posterUrl,
    backdropUrl,
    releaseDate,
    genres,
    overview,
    voteAverage,
    voteCount,
    trailerUrl,
    similar,
    isBookmarked,
    images,
    facts,
    sequelsAndPrequels,
    videos,
    director,
    country,
    webUrl,
  ];
}