import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/presentation/bloc/detail/recommendation/movies_recommendation_event.dart';

class MovieRecommendationBloc extends Bloc<MovieRecommendationEvent, StateRequest> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationBloc(this._getMovieRecommendations) : super(Empty()) {
    on<GetMovieRecommendationId>((event, emit) async {
      emit(Loading());
      final result = await _getMovieRecommendations.execute(event.id);
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
