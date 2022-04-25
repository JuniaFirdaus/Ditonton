import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';


class TvListNotifier extends ChangeNotifier {
  var _nowPlayingTv = <TvEntity>[];
  List<TvEntity> get nowPlayingTv => _nowPlayingTv;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popularTv = <TvEntity>[];
  List<TvEntity> get popularTv => _popularTv;

  RequestState _popularTvState = RequestState.Empty;
  RequestState get popularTvState => _popularTvState;

  var _topRatedTv = <TvEntity>[];
  List<TvEntity> get topRatedTv => _topRatedTv;

  RequestState _topRatedTvState = RequestState.Empty;
  RequestState get topRatedTvState => _topRatedTvState;

  String _message = '';
  String get message => _message;

  TvListNotifier({
    required this.getNowPlayingTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  });

  final GetNowPlayingTv getNowPlayingTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  Future<void> fetchPopularTv() async {
    _popularTvState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTv.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _popularTvState = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _popularTv = tvData;
        _popularTvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchNowPlayingTv() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTv.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _nowPlayingState = RequestState.Error;
        notifyListeners();
      },
          (tvData) {
        _nowPlayingTv = tvData;
        _nowPlayingState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTv() async {
    _topRatedTvState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _topRatedTvState = RequestState.Error;
        notifyListeners();
      },
          (tvData) {
        _topRatedTv = tvData;
        _topRatedTvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

}
