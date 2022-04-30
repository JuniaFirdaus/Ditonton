import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/toprated/top_rated_event.dart';
import 'package:tv/presentation/bloc/toprated/top_rated_tv_bloc.dart';
import 'package:tv/presentation/pages/top_rated_tv_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/dummy_objects_tv.dart';

class FakeTopRatedTvEvent extends Fake implements TopRatedEvent {}

class FakeTopRatedTvState extends Fake implements TopRatedEvent {}

class FakeTopRatedTvBloc extends MockBloc<TopRatedEvent, StateRequest>
    implements TopRatedTvBloc {}
    
void main() {
  late FakeTopRatedTvBloc topRatedTvBloc;

  setUpAll(() {
    topRatedTvBloc = FakeTopRatedTvBloc();
    registerFallbackValue(FakeTopRatedTvEvent());
    registerFallbackValue(FakeTopRatedTvState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>(
      create: (_) => topRatedTvBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => topRatedTvBloc.state).thenReturn(Loading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => topRatedTvBloc.state).thenReturn(HasData(testTvList));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
    await tester.pump();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
        const errorMessage = 'error message';
        when(() => topRatedTvBloc.state).thenReturn(const Error(errorMessage));

        final textFinder = find.byKey(const Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
        await tester.pump();

        expect(textFinder, findsOneWidget);
  });
}
