import 'package:kinobaza/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/core/domain/usecase/base_use_case.dart';
import 'package:kinobaza/movies/domain/repository/movies_repository.dart';

class GetAllPopularMoviesUseCase extends BaseUseCase<List<Media>, int> {
  final MoviesRespository _moviesRespository;

  GetAllPopularMoviesUseCase(this._moviesRespository);

  @override
  Future<Either<Failure, List<Media>>> call(int p) async {
    return await _moviesRespository.getAllPopularMovies(p);
  }
}
