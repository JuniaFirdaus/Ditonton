import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/detail/recommendation/tv_recommendation_event.dart';

class TvRecommendationBloc extends Bloc<TvRecommendationEvent, StateRequest> {
  final GetTvRecommendations _getTvRecommendations;

  TvRecommendationBloc(this._getTvRecommendations) : super(Empty()) {
    on<GetTvRecommendationId>((event, emit) async {
      emit(Loading());
      final result = await _getTvRecommendations.execute(event.id);
      result.fold(
        (failure) {
          emit(Error(failure.message));
        },
        (movieData) {
          emit(HasData(movieData));
        },
      );
    });
  }
}
