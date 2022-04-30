import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/popular/popular_event.dart';
import 'package:tv/presentation/bloc/popular/popular_tv_bloc.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:core/utils/state_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/dummy_objects_tv.dart';

class FakePopularTvEvent extends Fake implements PopularEvent {}

class FakePopularTvState extends Fake implements PopularEvent {}

class FakePopularTvBloc extends MockBloc<PopularEvent, StateRequest>
    implements PopularTvBloc {}

void main() {
  late FakePopularTvBloc fakePopularTvBloc;

  setUpAll(() {
    fakePopularTvBloc = FakePopularTvBloc();
    registerFallbackValue(FakePopularTvEvent());
    registerFallbackValue(FakePopularTvState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>(
      create: (_) => fakePopularTvBloc,
      child: MaterialApp(
        home: Scaffold(body: body),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => fakePopularTvBloc.state).thenReturn(Loading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const PopularTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => fakePopularTvBloc.state).thenReturn(HasData(testTvList));

    await tester.pumpWidget(_makeTestableWidget(const PopularTvPage()));
    await tester.pump();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
    expect(find.byType(TvCard), findsOneWidget);
    expect(find.byKey(const Key('popular_tv_content')), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const errorMessage = 'error message';
    when(() => fakePopularTvBloc.state).thenReturn(const Error(errorMessage));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularTvPage()));
    await tester.pump();

    expect(textFinder, findsOneWidget);
  });
}
