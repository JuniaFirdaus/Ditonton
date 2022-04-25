import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tv_detail_entity.dart';
import '../../repositories/movie_repository.dart';

class RemoveWatchlistTv {
  final MovieRepository repository;

  RemoveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetailEntity tv) {
    return repository.removeTvWatchlist(tv);
  }
}
