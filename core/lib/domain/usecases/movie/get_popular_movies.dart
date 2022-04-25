import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/movie/movie_entity.dart';
import '../../repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<MovieEntity>>> execute() {
    return repository.getPopularMovies();
  }
}
