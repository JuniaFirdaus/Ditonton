import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/movie/movie_detail_entity.dart';
import '../../repositories/movie_repository.dart';

class RemoveWatchlistMovie {
  final MovieRepository repository;

  RemoveWatchlistMovie(this.repository);

  Future<Either<Failure, String>> execute(MovieDetailEntity movie) {
    return repository.removeMovieWatchlist(movie);
  }
}
