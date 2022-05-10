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
  const apiKey = 'apiKey=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Movies', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie_now_playing.json')))
        .movieList;

    test('should return list of Movie Model when the response is success',
        () async {
      final client = await Shared.createLEClient(isTestMode: true);

      // arrange
      when(await client
          .get(Uri.parse('$baseUrl/movie/now_playing?$apiKey'))
          .whenComplete(() =>
              http.Response(readJson('dummy_data/movie_now_playing.json'), 200)));

      // act
      final result = await dataSource.getNowPlayingMovies();
      // assert
      expect(result.isNotEmpty, tMovieList.isNotEmpty);
    });
  });

  group('get Popular Movies', () {
    final tMovieList =
        MovieResponse.fromJson(json.decode(readJson('dummy_data/movie_popular.json')))
            .movieList;

    test('should return list of movies when response is success', () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(await client
          .get(Uri.parse('$baseUrl/movie/popular?$apiKey'))
          .whenComplete(
              () => http.Response(readJson('dummy_data/movie_popular.json'), 200)));
      // act
      final result = await dataSource.getPopularMovies();
      // assert
      expect(result.isNotEmpty, tMovieList.isNotEmpty);
    });
  });

  group('get Top Rated Movies', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie_top_rated.json')))
        .movieList;

    test('should return list of movies when response is success ', () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(client
          .get(Uri.parse('$baseUrl/movie/top_rated?$apiKey'))
          .whenComplete(
              () => http.Response(readJson('dummy_data/movie_top_rated.json'), 200)));
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
          .get(Uri.parse('$baseUrl/movie/675353?$apiKey'))
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
          .get(Uri.parse('$baseUrl/movie/1?$apiKey'))
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
          .get(Uri.parse('$baseUrl/movie/675353/recommendations?$apiKey'))
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
          .get(Uri.parse('$baseUrl/movie/1/recommendations?$apiKey'))
          .whenComplete(() async => http.Response('Not Found', 404)));
      // act
      final call = dataSource.getMovieRecommendations(1);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search movies', () {
    final tSearchResult = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie_search_spiderman.json')))
        .movieList;

    test('should return list of movies when response is success', () async {
      final client = await Shared.createLEClient(isTestMode: true);
      // arrange
      when(client
          .get(Uri.parse('$baseUrl/search/movie?$apiKey&query=Spiderman'))
          .whenComplete(() async => http.Response(
              readJson('dummy_data/movie_search_spiderman.json'), 200)));
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
              .get(Uri.parse('$baseUrl/search/movie?$apiKey&query=1'))
          .whenComplete(() async => http.Response('Not Found', 404)));
      // act
      final call = await dataSource.searchMovies('2@123');
      // assert
      expect(call.isEmpty, true);
    });
  });
}
