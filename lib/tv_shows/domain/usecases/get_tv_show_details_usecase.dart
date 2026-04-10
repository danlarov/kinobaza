import 'package:kinobaza/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:kinobaza/core/domain/entities/media_details.dart';
import 'package:kinobaza/core/domain/usecase/base_use_case.dart';
import 'package:kinobaza/tv_shows/domain/repository/tv_shows_repository.dart';

class GetTVShowDetailsUseCase extends BaseUseCase<MediaDetails, int> {
  final TVShowsRepository _tvShowsRepository;

  GetTVShowDetailsUseCase(this._tvShowsRepository);
  @override
  Future<Either<Failure, MediaDetails>> call(int p) async {
    return await _tvShowsRepository.getTVShowDetails(p);
  }
}
