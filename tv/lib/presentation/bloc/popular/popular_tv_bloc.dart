import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/presentation/bloc/popular/popular_event.dart';

class PopularTvBloc extends Bloc<PopularEvent, StateRequest> {
  final GetPopularTv _getPopularTv;

  PopularTvBloc(this._getPopularTv) : super(Empty()) {
    on<PopularTv>((event, emit) async {
      emit(Loading());
      final result = await _getPopularTv.execute();
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
