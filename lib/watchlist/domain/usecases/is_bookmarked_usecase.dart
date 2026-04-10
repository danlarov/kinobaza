import 'package:kinobaza/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:kinobaza/core/domain/usecase/base_use_case.dart';
import 'package:kinobaza/watchlist/domain/repository/watchlist_repository.dart';

class IsBookmarkedUseCase extends BaseUseCase<int, int> {
  final WatchlistRepository _watchlistRepository;

  IsBookmarkedUseCase(this._watchlistRepository);
  @override
  Future<Either<Failure, int>> call(int p) async {
    return await _watchlistRepository.isBookmarked(p);
  }
}
