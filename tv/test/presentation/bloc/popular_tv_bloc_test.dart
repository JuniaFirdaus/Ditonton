
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:core/utils/state_request.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/presentation/bloc/popular/popular_event.dart';
import 'package:tv/presentation/bloc/popular/popular_tv_bloc.dart';

import '../bloc/popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late PopularTvBloc popularTvBloc;
  late MockGetPopularTv mockGetPopularTv;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
  });

  final tTv = TvEntity(
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvList = <TvEntity>[tTv];

  blocTest<PopularTvBloc, StateRequest>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(PopularTv()),
    expect: () => [
      Loading(),
      HasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
    },
  );

  blocTest<PopularTvBloc, StateRequest>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(PopularTv()),
    expect: () => [
      Loading(),
      const Error('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
    },
  );
}
