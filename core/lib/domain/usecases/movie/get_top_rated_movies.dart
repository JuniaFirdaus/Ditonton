import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/movie/movie_entity.dart';
import '../../repositories/movie_repository.dart';

class GetTopRatedMovies {
  final MovieRepository repository;

  GetTopRatedMovies(this.repository);

  Future<Either<Failure, List<MovieEntity>>> execute() {
    return repository.getTopRatedMovies();
  }
}
