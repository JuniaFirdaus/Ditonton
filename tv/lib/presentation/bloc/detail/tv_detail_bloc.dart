import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/presentation/bloc/detail/tv_detail_event.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, StateRequest> {
  final GetTvDetail getTvDetail;

  TvDetailBloc(this.getTvDetail) : super(Empty()) {
    on<FetchTvDetail>((event, emit) async {
      emit(Loading());
      final detailResult = await getTvDetail.execute(event.id);
      detailResult.fold(
        (failure) {
          emit(Error(failure.message));
        },
        (tvData) {
          emit(HasData(tvData));
        },
      );
    });
  }
}
