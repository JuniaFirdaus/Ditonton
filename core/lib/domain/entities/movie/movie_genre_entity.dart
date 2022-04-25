import 'package:equatable/equatable.dart';

class MovieGenreEntity extends Equatable {
  MovieGenreEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
