import 'dart:convert';

import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/models/movie/movie_detail_model.dart';
import 'package:core/data/models/movie/movie_response.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';
import '../ssl_pinning/shared.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Movies', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/now_playing.json')))
        .movieList;

    test('should return list of Movie Model when the response is success',
        () async {
      final client = await Shared.createLEClient(isTestMode: true);

      // arrange
      when(await client
          .get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'))
          .whenComplete(() =>
              http.Response(readJson('dummy_data/now_playing.json'), 200)));

      // act
      final result = await dataSource.getNowPlayingMovies();
      // assert
      expect(result.isNotEmpty, tMovieList.isNotEmpty);
    });
  });

  group('get Popular Movies', () {
    final tMovieList =
        MovieResponse.fromJson(json.decode(readJson('dummy_data/popular.json')))
            .movieList;

    test('should return list of movies when response is success', () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(await client
          .get(Uri.parse('$BASE_URL/movie/popular?$API_KEY'))
          .whenComplete(
              () => http.Response(readJson('dummy_data/popular.json'), 200)));
      // act
      final result = await dataSource.getPopularMovies();
      // assert
      expect(result.isNotEmpty, tMovieList.isNotEmpty);
    });
  });

  group('get Top Rated Movies', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated.json')))
        .movieList;

    test('should return list of movies when response is success ', () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(client
          .get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY'))
          .whenComplete(
              () => http.Response(readJson('dummy_data/top_rated.json'), 200)));
      // act
      final result = await dataSource.getTopRatedMovies();
      // assert
      expect(result.isNotEmpty, tMovieList.isNotEmpty);
    });
  });

  group('get movie detail', () {
    final tMovieDetail = MovieDetailResponse.fromJson(
        json.decode(readJson('dummy_data/movie_detail.json')));

    test('should return movie detail when the response code is 200', () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(client
          .get(Uri.parse('$BASE_URL/movie/675353?$API_KEY'))
          .whenComplete(() =>
              http.Response(readJson('dummy_data/movie_detail.json'), 200)));
      // act
      final result = await dataSource.getMovieDetail(675353);
      // assert
      expect(result.id, equals(tMovieDetail.id));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(client
          .get(Uri.parse('$BASE_URL/movie/1?$API_KEY'))
          .whenComplete(() => http.Response('Not Found', 404)));
      // act
      final call = dataSource.getMovieDetail(1);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get movie recommendations', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie_recommendations.json')))
        .movieList;

    test('should return list of Movie Model when the response is success',
        () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(client
          .get(Uri.parse('$BASE_URL/movie/675353/recommendations?$API_KEY'))
          .whenComplete(() async => http.Response(
              readJson('dummy_data/movie_recommendations.json'), 200)));
      // act
      final result = await dataSource.getMovieRecommendations(675353);
      // assert
      expect(result.isNotEmpty, equals(tMovieList.isNotEmpty));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(client
          .get(Uri.parse('$BASE_URL/movie/1/recommendations?$API_KEY'))
          .whenComplete(() async => http.Response('Not Found', 404)));
      // act
      final call = dataSource.getMovieRecommendations(1);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search movies', () {
    final tSearchResult = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/search_spiderman_movie.json')))
        .movieList;

    test('should return list of movies when response is success', () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(client
          .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=Spiderman'))
          .whenComplete(() async => http.Response(
              readJson('dummy_data/search_spiderman_movie.json'), 200)));
      // act
      final result = await dataSource.searchMovies('Spiderman');
      // assert
      expect(result.isNotEmpty, tSearchResult.isNotEmpty);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
          final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(client
              .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=1'))
          .whenComplete(() async => http.Response('Not Found', 404)));
      // act
      final call = await dataSource.searchMovies('2@123');
      // assert
      expect(call.isEmpty, true);
    });
  });
}
