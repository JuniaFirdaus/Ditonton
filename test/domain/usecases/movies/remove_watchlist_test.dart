import 'package:core/domain/usecases/movie/remove_watchlist_movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects_movies.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistMovie usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlistMovie(mockMovieRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(mockMovieRepository.removeMovieWatchlist(testMovieDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testMovieDetail);
    // assert
    verify(mockMovieRepository.removeMovieWatchlist(testMovieDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
