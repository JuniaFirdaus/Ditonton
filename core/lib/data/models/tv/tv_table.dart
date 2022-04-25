import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv/tv_detail_entity.dart';
import '../../../domain/entities/tv/tv_entity.dart';
import 'tv_model.dart';

class TvTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  TvTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TvTable.fromEntity(TvDetailEntity tv) =>
      TvTable(
        id: tv.id,
        name: tv.name,
        posterPath: tv.posterPath,
        overview: tv.overview,
      );

  factory TvTable.fromMap(Map<String, dynamic> map) =>
      TvTable(
        id: map['id'],
        name: map['name'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  factory TvTable.fromDTO(TvModel tv) => TvTable(
    id: tv.id,
    name: tv.name,
    posterPath: tv.posterPath,
    overview: tv.overview,
  );

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'posterPath': posterPath,
        'overview': overview,
      };

  TvEntity toEntity() =>
      TvEntity.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        name: name,
      );

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}
