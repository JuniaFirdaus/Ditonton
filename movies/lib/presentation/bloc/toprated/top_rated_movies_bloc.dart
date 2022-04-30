import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/presentation/bloc/toprated/top_rated_event.dart';

class TopRatedMoviesBloc extends Bloc<TopRatedEvent, StateRequest> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesBloc(this._getTopRatedMovies) : super(Empty()) {
    on<TopRatedMovies>((event, emit) async {
      emit(Loading());
      final result = await _getTopRatedMovies.execute();
      result.fold(
        (failure) {
          emit(Error(failure.message));
        },
        (data) {
          emit(HasData(data));
        },
      );
    });
  }
}
