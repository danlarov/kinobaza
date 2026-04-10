import 'package:kinobaza/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/core/domain/usecase/base_use_case.dart';
import 'package:kinobaza/movies/domain/repository/movies_repository.dart';

class GetMoviesUseCase extends BaseUseCase<List<List<Media>>, NoParameters> {
  final MoviesRespository _moviesRespository;

  GetMoviesUseCase(this._moviesRespository);

  @override
  Future<Either<Failure, List<List<Media>>>> call(NoParameters p) async {
    return await _moviesRespository.getMovies();
  }
}
