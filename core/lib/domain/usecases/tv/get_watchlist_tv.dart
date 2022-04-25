import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tv_entity.dart';
import '../../repositories/movie_repository.dart';

class GetWatchlistTv {
  final MovieRepository _repository;

  GetWatchlistTv(this._repository);

  Future<Either<Failure, List<TvEntity>>> execute() {
    return _repository.getWatchlistTv();
  }
}
