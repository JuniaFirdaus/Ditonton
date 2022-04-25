import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tv_detail_entity.dart';
import '../../repositories/movie_repository.dart';

class SaveWatchlistTv {
  final MovieRepository repository;

  SaveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetailEntity tv) {
    return repository.saveTvWatchlist(tv);
  }
}
