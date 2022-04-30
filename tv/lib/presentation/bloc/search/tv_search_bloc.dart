import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv/domain/usecases/search_tv.dart';
import 'package:tv/presentation/bloc/search/tv_search_event.dart';

// class TvSearchBloc extends Bloc<TvSearchEvent, StateRequest> {
//   final SearchTv _searchTv;
//
//   TvSearchBloc(this._searchTv) : super(Empty()) {
//     on<OnQueryChanged>((event, emit) async {
//       final query = event.query;
//
//       emit(Loading());
//       final result = await _searchTv.execute(query);
//       result.fold(
//             (failure) {
//           emit(Error(failure.message));
//         },
//             (data) {
//           emit(HasData(data));
//         },
//       );
//     }, transformer: debounce(const Duration(microseconds: 500)));
//   }
// }
//
// EventTransformer<T> debounce<T>(Duration duration) {
//   return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
// }
