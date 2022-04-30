import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies/presentation/bloc/detail/movies_detail_bloc.dart';
import 'package:movies/presentation/bloc/detail/movies_detail_event.dart';
import 'package:movies/presentation/bloc/detail/recommendation/movies_recommendation_bloc.dart';
import 'package:movies/presentation/bloc/detail/recommendation/movies_recommendation_event.dart';
import 'package:movies/presentation/bloc/watchlist/watchlist_event.dart';
import 'package:movies/presentation/bloc/watchlist/watchlist_movies_bloc.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects_movies.dart';

//Detail
class FakeDetailMoviesEvent extends Fake implements MovieDetailEvent {}

class FakeDetailMoviesState extends Fake implements MovieDetailEvent {}

class FakeDetailMoviesBloc extends MockBloc<MovieDetailEvent, StateRequest>
    implements MovieDetailBloc {}

//Watchlist
class FakeWatchlistMoviesEvent extends Fake implements WatchlistEvent {}

class FakeWatchlistMoviesState extends Fake implements WatchlistEvent {}

class FakeWatchlistMoviesBloc extends MockBloc<WatchlistEvent, StateRequest>
    implements WatchlistMoviesBloc {}

//Recommendation
class FakeRecommendationMoviesEvent extends Fake
    implements MovieRecommendationEvent {}

class FakeRecommendationMoviesState extends Fake
    implements MovieRecommendationEvent {}

class FakeRecommendationMoviesBloc
    extends MockBloc<MovieRecommendationEvent, StateRequest>
    implements MovieRecommendationBloc {}

void main() {
  late FakeDetailMoviesBloc fakeDetailMoviesBloc;
  late FakeWatchlistMoviesBloc fakeWatchlistMoviesBloc;
  late FakeRecommendationMoviesBloc fakeRecommendationMoviesBloc;

  setUpAll(() {
    fakeDetailMoviesBloc = FakeDetailMoviesBloc();
    registerFallbackValue(FakeDetailMoviesEvent());
    registerFallbackValue(FakeDetailMoviesState());

    fakeWatchlistMoviesBloc = FakeWatchlistMoviesBloc();
    registerFallbackValue(FakeWatchlistMoviesEvent());
    registerFallbackValue(FakeWatchlistMoviesState());

    fakeRecommendationMoviesBloc = FakeRecommendationMoviesBloc();
    registerFallbackValue(FakeRecommendationMoviesEvent());
    registerFallbackValue(FakeRecommendationMoviesState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieDetailBloc>(
            create: (_) => fakeDetailMoviesBloc,
          ),
          BlocProvider<WatchlistMoviesBloc>(
            create: (_) => fakeWatchlistMoviesBloc,
          ),
          BlocProvider<MovieRecommendationBloc>(
            create: (_) => fakeRecommendationMoviesBloc,
          ),
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  testWidgets(
      'Watchlist button should display add icon when Movies not added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeDetailMoviesBloc.state).thenReturn(HasData(testMovieDetail));

    when(() => fakeWatchlistMoviesBloc.state)
        .thenReturn(const HasStatus(false));

    when(() => fakeRecommendationMoviesBloc.state)
        .thenReturn(HasData(testMovieList));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Movies is added to wathclist',
      (WidgetTester tester) async {
    when(() => fakeDetailMoviesBloc.state).thenReturn(HasData(testMovieDetail));
    when(() => fakeWatchlistMoviesBloc.state).thenReturn(const HasStatus(true));
    when(() => fakeRecommendationMoviesBloc.state)
        .thenReturn(HasData(testMovieList));
    final checkIconFinder = find.byIcon(Icons.check);
    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();
    expect(checkIconFinder, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeDetailMoviesBloc.state).thenReturn(HasData(testMovieDetail));

    when(() => fakeRecommendationMoviesBloc.state)
        .thenReturn(HasData(testMovieList));

    when(() => fakeWatchlistMoviesBloc.state)
        .thenReturn(const HasStatus(false));
    when(() => fakeWatchlistMoviesBloc.state)
        .thenReturn(const HasMessage('Added to Watchlist'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
}
