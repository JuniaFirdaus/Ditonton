import 'package:core/domain/entities/movie/movie_detail_entity.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistStatus extends WatchlistEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends WatchlistEvent {
  final MovieDetailEntity movieDetailEntity;

  const AddWatchlist(this.movieDetailEntity);

  @override
  List<Object> get props => [MovieDetailEntity];
}

class RemoveFromWatchlist extends WatchlistEvent {
  final MovieDetailEntity movieDetailEntity;

  const RemoveFromWatchlist(this.movieDetailEntity);

  @override
  List<Object> get props => [MovieDetailEntity];
}

class WatchlistMovies extends WatchlistEvent {
  @override
  List<Object> get props => [];
}
