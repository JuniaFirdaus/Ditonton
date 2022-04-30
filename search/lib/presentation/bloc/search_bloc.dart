import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:search/presentation/bloc/search_event.dart';
import 'package:search/search.dart';

class SearchMoviesBloc extends Bloc<SearchEvent, StateRequest> {
  final SearchMovies _searchMovies;

  SearchMoviesBloc(this._searchMovies) : super(Empty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;
      emit(Loading());
      final result = await _searchMovies.execute(query);
      result.fold(
        (failure) {
          emit(Error(failure.message));
        },
        (data) {
          emit(HasData(data));
        },
      );
    }, transformer: debounce(const Duration(microseconds: 500)));
  }
}

class SearchTvBloc extends Bloc<SearchEvent, StateRequest> {
  final SearchTv _searchTv;

  SearchTvBloc(this._searchTv) : super(Empty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(Loading());
      final result = await _searchTv.execute(query);
      result.fold(
        (failure) {
          emit(Error(failure.message));
        },
        (data) {
          emit(HasData(data));
        },
      );
    }, transformer: debounce(const Duration(microseconds: 500)));
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
