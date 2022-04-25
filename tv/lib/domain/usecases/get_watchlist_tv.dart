import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetWatchlistTv {
  final MovieRepository _repository;

  GetWatchlistTv(this._repository);

  Future<Either<Failure, List<TvEntity>>> execute() {
    return _repository.getWatchlistTv();
  }
}
