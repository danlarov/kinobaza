import 'package:dartz/dartz.dart';
import 'package:kinobaza/core/error/failure.dart';
import 'package:kinobaza/core/domain/entities/media.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<Media>>> getWatchListItems();
  Future<Either<Failure, int>> addWatchListItem(Media media);
  Future<Either<Failure, Unit>> removeWatchListItem(int index);
  Future<Either<Failure, int>> isBookmarked(int tmdbId);
}
