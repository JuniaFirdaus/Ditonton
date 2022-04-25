import 'package:equatable/equatable.dart';

class TvGenreEntity extends Equatable {
  TvGenreEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
