import 'dart:io';

import 'package:core/core.dart';
import 'package:core/data/models/movie/movie_detail_model.dart';
import 'package:core/data/models/movie/movie_genre_model.dart';
import 'package:core/data/models/movie/movie_model.dart';
import 'package:core/data/models/tv/tv_detail_model.dart';
import 'package:core/data/models/tv/tv_genre_model.dart';
import 'package:core/data/models/tv/tv_model.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/domain/entities/movie/movie_entity.dart';
import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_movies.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <MovieEntity>[tMovie];

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <TvEntity>[tTv];

  // MOVIE
  group('Now Playing Movies', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenAnswer((_) async => []);
      // act
      await repository.getNowPlayingMovies();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getNowPlayingMovies())
            .thenAnswer((_) async => tMovieModelList);
        // act
        await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingMovies())
            .thenAnswer((_) async => tMovieModelList);
        // act
        await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        verify(mockLocalDataSource.cacheNowPlayingMovies([testMovieCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingMovies())
            .thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingMovies())
            .thenAnswer((_) async => [testMovieCache]);
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingMovies());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testMovieFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingMovies())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingMovies());
        expect(result, Left(CacheFailure('No Cache')));
      });

    });
  });

  group('Popular Movies', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getPopularMovies())
          .thenAnswer((_) async => []);
      // act
      await repository.getPopularMovies();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
              () async {
            // arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
            when(mockRemoteDataSource.getPopularMovies())
                .thenAnswer((_) async => tMovieModelList);
            // act
            await repository.getPopularMovies();
            // assert
            verify(mockRemoteDataSource.getPopularMovies());
            /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          });

      test(
          'should cache data locally when the call to remote data source is successful',
              () async {
            // arrange
            when(mockRemoteDataSource.getPopularMovies())
                .thenAnswer((_) async => tMovieModelList);
            // act
            await repository.getPopularMovies();
            // assert
            verify(mockRemoteDataSource.getPopularMovies());
            verify(mockLocalDataSource.cachePopularMovies([testMovieCache]));
          });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            // arrange
            when(mockRemoteDataSource.getPopularMovies())
                .thenThrow(ServerException());
            // act
            final result = await repository.getPopularMovies();
            // assert
            verify(mockRemoteDataSource.getPopularMovies());
            expect(result, equals(Left(ServerFailure(''))));
          });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedPopularMovies())
            .thenAnswer((_) async => [testMovieCache]);
        // act
        final result = await repository.getPopularMovies();
        // assert
        verify(mockLocalDataSource.getCachedPopularMovies());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testMovieFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedPopularMovies())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getPopularMovies();
        // assert
        verify(mockLocalDataSource.getCachedPopularMovies());
        expect(result, Left(CacheFailure('No Cache')));
      });

    });
  });

  group('Top Rated Movies', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenAnswer((_) async => []);
      // act
      await repository.getTopRatedMovies();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
              () async {
            // arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
            when(mockRemoteDataSource.getTopRatedMovies())
                .thenAnswer((_) async => tMovieModelList);
            // act
            await repository.getTopRatedMovies();
            // assert
            verify(mockRemoteDataSource.getTopRatedMovies());
            /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          });

      test(
          'should cache data locally when the call to remote data source is successful',
              () async {
            // arrange
            when(mockRemoteDataSource.getTopRatedMovies())
                .thenAnswer((_) async => tMovieModelList);
            // act
            await repository.getTopRatedMovies();
            // assert
            verify(mockRemoteDataSource.getTopRatedMovies());
            verify(mockLocalDataSource.cacheTopRatedMovies([testMovieCache]));
          });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            // arrange
            when(mockRemoteDataSource.getTopRatedMovies())
                .thenThrow(ServerException());
            // act
            final result = await repository.getTopRatedMovies();
            // assert
            verify(mockRemoteDataSource.getTopRatedMovies());
            expect(result, equals(Left(ServerFailure(''))));
          });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedTopRatedMovies())
            .thenAnswer((_) async => [testMovieCache]);
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        verify(mockLocalDataSource.getCachedTopRatedMovies());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testMovieFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedTopRatedMovies())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        verify(mockLocalDataSource.getCachedTopRatedMovies());
        expect(result, Left(CacheFailure('No Cache')));
      });

    });
  });

  group('Get Movie Detail', () {
    final tId = 1;
    final tMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [MovieGenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenAnswer((_) async => tMovieResponse);
      // act
      final result = await repository.getMovieDetail(tId);
      // assert
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(Right(testMovieDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getMovieDetail(tId);
      // assert
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getMovieDetail(tId);
      // assert
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    final tId = 1;

    test('should return data (movie list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenAnswer((_) async => tMovieList);
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Movies', () {
    final tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertMovieWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveMovieWatchlist(testMovieDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertMovieWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveMovieWatchlist(testMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeMovieWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeMovieWatchlist(testMovieDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeMovieWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeMovieWatchlist(testMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getMovieById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistMovies(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieTable]);
      // act
      final result = await repository.getWatchlistMovies();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistMovie]);
    });
  });


  // TV
  group('Now Playing Tv', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getNowPlayingTv())
          .thenAnswer((_) async => []);
      // act
      await repository.getNowPlayingTv();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
              () async {
            // arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
            when(mockRemoteDataSource.getNowPlayingTv())
                .thenAnswer((_) async => tTvModelList);
            // act
            await repository.getNowPlayingTv();
            // assert
            verify(mockRemoteDataSource.getNowPlayingTv());
            /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          });

      test(
          'should cache data locally when the call to remote data source is successful',
              () async {
            // arrange
            when(mockRemoteDataSource.getNowPlayingTv())
                .thenAnswer((_) async => tTvModelList);
            // act
            await repository.getNowPlayingTv();
            // assert
            verify(mockRemoteDataSource.getNowPlayingTv());
            verify(mockLocalDataSource.cacheNowPlayingTv([testTvCache]));
          });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            // arrange
            when(mockRemoteDataSource.getNowPlayingTv())
                .thenThrow(ServerException());
            // act
            final result = await repository.getNowPlayingTv();
            // assert
            verify(mockRemoteDataSource.getNowPlayingTv());
            expect(result, equals(Left(ServerFailure(''))));
          });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingTv())
            .thenAnswer((_) async => [testTvCache]);
        // act
        final result = await repository.getNowPlayingTv();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingTv());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingTv())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getNowPlayingTv();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingTv());
        expect(result, Left(CacheFailure('No Cache')));
      });

    });
  });

  group('Popular Tv', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getPopularTv())
          .thenAnswer((_) async => []);
      // act
      await repository.getPopularTv();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
              () async {
            // arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
            when(mockRemoteDataSource.getPopularTv())
                .thenAnswer((_) async => tTvModelList);
            // act
            await repository.getPopularTv();
            // assert
            verify(mockRemoteDataSource.getPopularTv());
            /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          });

      test(
          'should cache data locally when the call to remote data source is successful',
              () async {
            // arrange
            when(mockRemoteDataSource.getPopularTv())
                .thenAnswer((_) async => tTvModelList);
            // act
            await repository.getPopularTv();
            // assert
            verify(mockRemoteDataSource.getPopularTv());
            verify(mockLocalDataSource.cachePopularTv([testTvCache]));
          });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            // arrange
            when(mockRemoteDataSource.getPopularTv())
                .thenThrow(ServerException());
            // act
            final result = await repository.getPopularTv();
            // assert
            verify(mockRemoteDataSource.getPopularTv());
            expect(result, equals(Left(ServerFailure(''))));
          });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedPopularTv())
            .thenAnswer((_) async => [testTvCache]);
        // act
        final result = await repository.getPopularTv();
        // assert
        verify(mockLocalDataSource.getCachedPopularTv());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedPopularTv())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getPopularTv();
        // assert
        verify(mockLocalDataSource.getCachedPopularTv());
        expect(result, Left(CacheFailure('No Cache')));
      });

    });
  });

  group('Top Rated Tv', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getTopRatedTv())
          .thenAnswer((_) async => []);
      // act
      await repository.getTopRatedTv();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
              () async {
            // arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
            when(mockRemoteDataSource.getTopRatedTv())
                .thenAnswer((_) async => tTvModelList);
            // act
            await repository.getTopRatedTv();
            // assert
            verify(mockRemoteDataSource.getTopRatedTv());
            /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          });

      test(
          'should cache data locally when the call to remote data source is successful',
              () async {
            // arrange
            when(mockRemoteDataSource.getTopRatedTv())
                .thenAnswer((_) async => tTvModelList);
            // act
            await repository.getTopRatedTv();
            // assert
            verify(mockRemoteDataSource.getTopRatedTv());
            verify(mockLocalDataSource.cacheTopRatedTv([testTvCache]));
          });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            // arrange
            when(mockRemoteDataSource.getTopRatedTv())
                .thenThrow(ServerException());
            // act
            final result = await repository.getTopRatedTv();
            // assert
            verify(mockRemoteDataSource.getTopRatedTv());
            expect(result, equals(Left(ServerFailure(''))));
          });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedTopRatedTv())
            .thenAnswer((_) async => [testTvCache]);
        // act
        final result = await repository.getTopRatedTv();
        // assert
        verify(mockLocalDataSource.getCachedTopRatedTv());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedTopRatedTv())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getTopRatedTv();
        // assert
        verify(mockLocalDataSource.getCachedTopRatedTv());
        expect(result, Left(CacheFailure('No Cache')));
      });

    });
  });

  group('Get TV Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [TvGenreModel(id: 1, name: 'Action')],
      id: 1,
      name: 'name',
      numberOfEpisodes: 1,
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      status: 'status',
      tagline: 'tagline',
      type: 'type',
      voteAverage: 1,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvDetail(tId))
              .thenAnswer((_) async => tTvResponse);
          // act
          await repository.getTvDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvDetail(tId));
        });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvDetail(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvDetail(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvDetail(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvDetail(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get TV Recommendations', () {
    final tTvList = <TvModel>[];
    final tId = 52814;

    test('should return data (tv list) when the call is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvRecommendations(tId))
              .thenAnswer((_) async => tTvList);
          // act
          final result = await repository.getTvRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTvRecommendations(tId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tTvList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvRecommendations(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvRecommendations(tId);
          // assertbuild runner
          verify(mockRemoteDataSource.getTvRecommendations(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvRecommendations(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTvRecommendations(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Search Tv', () {
    final tQuery = 'hallo';

    test('should return movie list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTv(tQuery))
              .thenAnswer((_) async => tTvModelList);
          // act
          final result = await repository.searchTv(tQuery);
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTv(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchTv(tQuery);
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTv(tQuery))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchTv(tQuery);
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveTvWatchlist(testTvDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveTvWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeTvWatchlist(testTvDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeTvWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 52814;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistTv(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist Tv', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });

}
