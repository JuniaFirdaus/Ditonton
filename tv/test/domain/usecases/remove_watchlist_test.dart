import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';

import '../../../../test/helpers/test_helper.mocks.dart';
import '../../dummy_data/dummy_objects_tv.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockMovieRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockMovieRepository();
    usecase = RemoveWatchlistTv(mockTvRepository);
  });

  test('should remove watchlist Tv from repository', () async {
    // arrange
    when(mockTvRepository.removeTvWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockTvRepository.removeTvWatchlist(testTvDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
