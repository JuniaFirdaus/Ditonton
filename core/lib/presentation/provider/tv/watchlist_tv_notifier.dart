import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/tv/tv_entity.dart';
import '../../../domain/usecases/tv/get_watchlist_tv.dart';

class WatchlistTvNotifier extends ChangeNotifier {
  var _watchlistTv = <TvEntity>[];
  List<TvEntity> get watchlistTv => _watchlistTv;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTvNotifier({required this.getWatchlistTv});

  final GetWatchlistTv getWatchlistTv;

  Future<void> fetchWatchlistTv() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTv.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTv = moviesData;
        notifyListeners();
      },
    );
  }
}
