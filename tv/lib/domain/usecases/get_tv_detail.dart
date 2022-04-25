import 'package:core/domain/entities/tv/tv_detail_entity.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTvDetail {
  final MovieRepository repository;

  GetTvDetail(this.repository);

  Future<Either<Failure, TvDetailEntity>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
