import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import '../../../../test/helpers/test_helper.mocks.dart';


void main() {
  late GetTvRecommendations usecase;
  late MockMovieRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockMovieRepository();
    usecase = GetTvRecommendations(mockTvRepository);
  });

  const tId = 1;
  final tTvs = <TvEntity>[];

  test('should get list of Tv recommendations from the repository',
      () async {
    // arrange
    when(mockTvRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTvs));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvs));
  });
}
