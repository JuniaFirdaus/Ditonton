import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/presentation/bloc/nowplaying/now_playing_event.dart';
import 'package:tv/presentation/bloc/popular/popular_event.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingEvent, StateRequest> {
  final GetNowPlayingTv _getNowPlayingTv;

  NowPlayingTvBloc(this._getNowPlayingTv) : super(Empty()) {
    on<NowPlayingTv>((event, emit) async {
      emit(Loading());
      final result = await _getNowPlayingTv.execute();
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
