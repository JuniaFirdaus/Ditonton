import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTv usecase;
  late MockMovieRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockMovieRepository();
    usecase = GetNowPlayingTv(mockTvRepository);
  });

  final tTv = <TvEntity>[];

  test('should get list of Tv from the repository', () async {
    // arrange
    when(mockTvRepository.getNowPlayingTv())
        .thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTv));
  });
}
