import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv/tv_detail_entity.dart';
import 'tv_genre_model.dart';

class TvDetailResponse extends Equatable {
  TvDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.name,
    required this.numberOfEpisodes,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
  });

  bool adult;
  String backdropPath;
  List<TvGenreModel> genres;
  int id;
  String name;
  int numberOfEpisodes;
  String overview;
  double popularity;
  String posterPath;
  String status;
  String tagline;
  String type;
  double voteAverage;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genres: List<TvGenreModel>.from(json["genres"].map((x) => TvGenreModel.fromJson(x))),
        id: json["id"],
        name: json["name"],
        numberOfEpisodes: json["number_of_episodes"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        status: json["status"],
        tagline: json["tagline"],
        type: json["type"],
        voteAverage: json["vote_average"].toDouble(),
      );

  TvDetailEntity toEntity() {
    return TvDetailEntity(
      adult: this.adult,
      backdropPath: this.backdropPath,
      id: this.id,
      name: this.name,
      numberOfEpisodes: this.numberOfEpisodes,
      overview: this.overview,
      popularity: this.popularity,
      posterPath: this.posterPath,
      status: this.status,
      tagline: this.tagline,
      type: this.type,
      voteAverage: this.voteAverage,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
    );
  }

  @override
  List<Object> get props => [
        adult,
        backdropPath,
        genres,
        id,
        name,
        numberOfEpisodes,
        overview,
        popularity,
        posterPath,
        status,
        tagline,
        type,
        voteAverage,
      ];
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
