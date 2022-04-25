import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tv_entity.dart';
import '../../repositories/movie_repository.dart';

class GetPopularTv {
  final MovieRepository repository;

  GetPopularTv(this.repository);

  Future<Either<Failure, List<TvEntity>>> execute() {
    return repository.getPopularTv();
  }
}
