import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/detail/recommendation/tv_recommendation_bloc.dart';
import 'package:tv/presentation/bloc/detail/recommendation/tv_recommendation_event.dart';
import 'package:tv/presentation/bloc/detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/watchlist/watchlist_event.dart';
import 'package:tv/presentation/bloc/watchlist/watchlist_tv_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

import '../../dummy_data/dummy_objects_tv.dart';

//Detail
class FakeDetailTvEvent extends Fake implements TvDetailEvent {}

class FakeDetailTvState extends Fake implements TvDetailEvent {}

class FakeDetailTvBloc extends MockBloc<TvDetailEvent, StateRequest>
    implements TvDetailBloc {}

//Watchlist
class FakeWatchlistTvEvent extends Fake implements WatchlistEvent {}

class FakeWatchlistTvState extends Fake implements WatchlistEvent {}

class FakeWatchlistTvBloc extends MockBloc<WatchlistEvent, StateRequest>
    implements WatchlistTvBloc {}

//Recommendation
class FakeRecommendationTvEvent extends Fake implements TvRecommendationEvent {}

class FakeRecommendationTvState extends Fake implements TvRecommendationEvent {}

class FakeRecommendationTvBloc
    extends MockBloc<TvRecommendationEvent, StateRequest>
    implements TvRecommendationBloc {}

void main() {
  late FakeDetailTvBloc fakeDetailTvBloc;
  late FakeWatchlistTvBloc fakeWatchlistTvBloc;
  late FakeRecommendationTvBloc fakeRecommendationTvBloc;

  setUpAll(() {
    fakeDetailTvBloc = FakeDetailTvBloc();
    registerFallbackValue(FakeDetailTvEvent());
    registerFallbackValue(FakeDetailTvState());

    fakeWatchlistTvBloc = FakeWatchlistTvBloc();
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());

    fakeRecommendationTvBloc = FakeRecommendationTvBloc();
    registerFallbackValue(FakeRecommendationTvEvent());
    registerFallbackValue(FakeRecommendationTvState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TvDetailBloc>(
            create: (_) => fakeDetailTvBloc,
          ),
          BlocProvider<WatchlistTvBloc>(
            create: (_) => fakeWatchlistTvBloc,
          ),
          BlocProvider<TvRecommendationBloc>(
            create: (_) => fakeRecommendationTvBloc,
          ),
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  testWidgets(
      'Watchlist button should display add icon when Tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeDetailTvBloc.state).thenReturn(HasData(testTvDetail));

    when(() => fakeWatchlistTvBloc.state).thenReturn(const HasStatus(false));

    when(() => fakeRecommendationTvBloc.state).thenReturn(HasData(testTvList));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => fakeDetailTvBloc.state).thenReturn(HasData(testTvDetail));
    when(() => fakeWatchlistTvBloc.state).thenReturn(const HasStatus(true));
    when(() => fakeRecommendationTvBloc.state).thenReturn(HasData(testTvList));
    final checkIconFinder = find.byIcon(Icons.check);
    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();
    expect(checkIconFinder, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeDetailTvBloc.state).thenReturn(HasData(testTvDetail));

    when(() => fakeRecommendationTvBloc.state).thenReturn(HasData(testTvList));

    when(() => fakeWatchlistTvBloc.state).thenReturn(const HasStatus(false));
    when(() => fakeWatchlistTvBloc.state)
        .thenReturn(const HasMessage('Added to Watchlist'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

}
