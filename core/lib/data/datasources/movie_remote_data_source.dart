import 'dart:convert';
import 'package:core/data/ssl/shared.dart';
import 'package:core/utils/exception.dart';
import 'package:http/http.dart' as http;

import '../models/movie/movie_detail_model.dart';
import '../models/movie/movie_model.dart';
import '../models/movie/movie_response.dart';
import '../models/tv/tv_detail_model.dart';
import '../models/tv/tv_model.dart';
import '../models/tv/tv_response.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();

  Future<List<MovieModel>> getPopularMovies();

  Future<List<MovieModel>> getTopRatedMovies();

  Future<MovieDetailResponse> getMovieDetail(int id);

  Future<List<MovieModel>> getMovieRecommendations(int id);

  Future<List<MovieModel>> searchMovies(String query);

  Future<List<TvModel>> getPopularTv();

  Future<List<TvModel>> getNowPlayingTv();

  Future<List<TvModel>> getTopRatedTv();

  Future<List<TvModel>> searchTv(String query);

  Future<TvDetailResponse> getTvDetail(int id);

  Future<List<TvModel>> getTvRecommendations(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});


  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final ioClient = await Shared.createLEClient(isTestMode: false);
    final response =
        await ioClient.get(Uri.parse('$baseUrl/movie/now_playing?$apiKey'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response =
        await ioClient.get(Uri.parse('$baseUrl/movie/$id?$apiKey'));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response = await ioClient
        .get(Uri.parse('$baseUrl/movie/$id/recommendations?$apiKey'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response =
        await ioClient.get(Uri.parse('$baseUrl/movie/popular?$apiKey'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response =
        await ioClient.get(Uri.parse('$baseUrl/movie/top_rated?$apiKey'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response = await ioClient
        .get(Uri.parse('$baseUrl/search/movie?$apiKey&query=$query'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTv() async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response =
        await ioClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTv() async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response =
        await ioClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getNowPlayingTv() async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response =
        await ioClient.get(Uri.parse('$baseUrl/tv/airing_today?$apiKey'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTv(String query) async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response = await ioClient
        .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTvDetail(int id) async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response =
        await ioClient.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TvDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id)async {
    final ioClient = await Shared.createLEClient(isTestMode: false);

    final response = await ioClient
        .get(Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }
}
