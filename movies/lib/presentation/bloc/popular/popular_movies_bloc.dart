import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/presentation/bloc/popular/popular_event.dart';

class PopularMoviesBloc extends Bloc<PopularEvent, StateRequest> {
  final GetPopularMovies _getPopularMovies;

  PopularMoviesBloc(this._getPopularMovies) : super(Empty()) {
    on<PopularMovies>((event, emit) async {
      emit(Loading());
      final result = await _getPopularMovies.execute();
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
