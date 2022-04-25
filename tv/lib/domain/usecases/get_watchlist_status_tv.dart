

import 'package:core/domain/repositories/movie_repository.dart';

class GetWatchListStatusTv {
  final MovieRepository repository;

  GetWatchListStatusTv(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistTv(id);
  }
}
