import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/presentation/bloc/toprated/top_rated_event.dart';

class TopRatedTvBloc extends Bloc<TopRatedEvent, StateRequest> {
  final GetTopRatedTv _getTopRatedTv;

  TopRatedTvBloc(this._getTopRatedTv) : super(Empty()) {
    on<TopRatedTv>((event, emit) async {
      emit(Loading());
      final result = await _getTopRatedTv.execute();
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
