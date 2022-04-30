import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/presentation/bloc/detail/movies_detail_event.dart';


class MovieDetailBloc extends Bloc<MovieDetailEvent, StateRequest> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(Empty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(Loading());
      final detailResult = await getMovieDetail.execute(event.id);

      detailResult.fold(
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
