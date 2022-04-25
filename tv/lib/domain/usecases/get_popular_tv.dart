import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetPopularTv {
  final MovieRepository repository;

  GetPopularTv(this.repository);

  Future<Either<Failure, List<TvEntity>>> execute() {
    return repository.getPopularTv();
  }
}
