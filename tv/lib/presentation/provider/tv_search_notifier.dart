import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:tv/domain/usecases/search_tv.dart';

class TvSearchNotifier extends ChangeNotifier {
  final SearchTv searchTv;

  TvSearchNotifier({required this.searchTv});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvEntity> _searchResult = [];
  List<TvEntity> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTv.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
