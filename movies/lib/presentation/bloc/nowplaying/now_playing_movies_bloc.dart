import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/presentation/bloc/nowplaying/now_playing_event.dart';

class NowPlayingMoviesBloc extends Bloc<NowPlayingEvent, StateRequest> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMoviesBloc(this._getNowPlayingMovies) : super(Empty()) {
    on<NowPlayingMovies>((event, emit) async {
      emit(Loading());
      final result = await _getNowPlayingMovies.execute();
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
