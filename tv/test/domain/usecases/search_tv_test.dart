import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../test/helpers/test_helper.mocks.dart';

// void main() {
//   late SearchTv usecase;
//   late MockMovieRepository mockTvRepository;
//
//   setUp(() {
//     mockTvRepository = MockMovieRepository();
//     usecase = SearchTv(mockTvRepository);
//   });
//
//   final tTv = <TvEntity>[];
//   final tQuery = 'Spiderman';
//
//   test('should get list of Tv from the repository', () async {
//     // arrange
//     when(mockTvRepository.searchTv(tQuery))
//         .thenAnswer((_) async => Right(tTv));
//     // act
//     final result = await usecase.execute(tQuery);
//     // assert
//     expect(result, Right(tTv));
//   });
// }
