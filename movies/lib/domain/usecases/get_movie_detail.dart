import 'package:core/domain/entities/movie/movie_detail_entity.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetailEntity>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
