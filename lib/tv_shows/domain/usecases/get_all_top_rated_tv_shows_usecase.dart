import 'package:dartz/dartz.dart';
import 'package:kinobaza/core/error/failure.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/core/domain/usecase/base_use_case.dart';
import 'package:kinobaza/tv_shows/domain/repository/tv_shows_repository.dart';

class GetAllTopRatedTVShowsUseCase extends BaseUseCase<List<Media>, int> {
  final TVShowsRepository _tvShowsRepository;

  GetAllTopRatedTVShowsUseCase(this._tvShowsRepository);

  @override
  Future<Either<Failure, List<Media>>> call(int p) async {
    return await _tvShowsRepository.getAllTopRatedTVShows(p);
  }
}
