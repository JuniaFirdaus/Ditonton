import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tv_detail_entity.dart';
import '../../repositories/movie_repository.dart';

class GetTvDetail {
  final MovieRepository repository;

  GetTvDetail(this.repository);

  Future<Either<Failure, TvDetailEntity>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
