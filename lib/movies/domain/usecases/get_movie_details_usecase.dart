import 'package:kinobaza/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:kinobaza/core/domain/entities/media_details.dart';
import 'package:kinobaza/core/domain/usecase/base_use_case.dart';
import 'package:kinobaza/movies/domain/repository/movies_repository.dart';

class GetMoviesDetailsUseCase extends BaseUseCase<MediaDetails, int> {
  final MoviesRespository _moviesRespository;

  GetMoviesDetailsUseCase(this._moviesRespository);

  @override
  Future<Either<Failure, MediaDetails>> call(int p) async {
    return await _moviesRespository.getMovieDetails(p);
  }
}
