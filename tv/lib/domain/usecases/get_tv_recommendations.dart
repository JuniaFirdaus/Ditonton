import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTvRecommendations {
  final MovieRepository repository;

  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<TvEntity>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
