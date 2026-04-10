import 'package:kinobaza/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/core/domain/usecase/base_use_case.dart';
import 'package:kinobaza/watchlist/domain/repository/watchlist_repository.dart';

class GetWatchlistItemsUseCase extends BaseUseCase<List<Media>, NoParameters> {
  final WatchlistRepository _watchlistRepository;

  GetWatchlistItemsUseCase(this._watchlistRepository);

  @override
  Future<Either<Failure, List<Media>>> call(NoParameters p) async {
    return await _watchlistRepository.getWatchListItems();
  }
}
