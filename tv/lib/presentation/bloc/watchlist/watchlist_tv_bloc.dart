import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watchlist/watchlist_event.dart';

class WatchlistTvBloc extends Bloc<WatchlistEvent, StateRequest> {

  final GetWatchListStatusTv _getWatchListStatusTv;
  final SaveWatchlistTv _saveWatchlistTv;
  final RemoveWatchlistTv _removeWatchlistTv;
  final GetWatchlistTv _getWatchlistTv;

  WatchlistTvBloc(this._getWatchlistTv, this._getWatchListStatusTv,
      this._saveWatchlistTv, this._removeWatchlistTv)
      : super(Empty()) {
    on<LoadWatchlistStatus>((event, emit) async {
      final id = event.id;
      emit(Loading());
      final result = await _getWatchListStatusTv.execute(id);
      emit(HasStatus(result));
    });

    on<AddWatchlist>((event, emit) async {
      final movie = event.tvDetailEntity;

      final result = await _saveWatchlistTv.execute(movie);

      result.fold((failure) {
        emit(Error(failure.message));
      }, (message) {
        emit(HasMessage(message));
      });
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final movie = event.tvDetailEntity;

      final result = await _removeWatchlistTv.execute(movie);

      result.fold((failure) {
        emit(Error(failure.message));
      }, (message) {
        emit(HasMessage(message));
      });
    });

    on<WatchlistTv>((event, emit) async {
      emit(Loading());
      final result = await _getWatchlistTv.execute();
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
