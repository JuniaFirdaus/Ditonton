import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tv_entity.dart';
import '../../repositories/movie_repository.dart';

class GetTvRecommendations {
  final MovieRepository repository;

  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<TvEntity>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
