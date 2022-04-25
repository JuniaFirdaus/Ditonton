import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tv_entity.dart';
import '../../repositories/movie_repository.dart';

class SearchTv {
  final MovieRepository repository;

  SearchTv(this.repository);

  Future<Either<Failure, List<TvEntity>>> execute(String query) {
    return repository.searchTv(query);
  }
}
