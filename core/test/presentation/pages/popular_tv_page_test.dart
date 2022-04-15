import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/popular/bloc/popular_bloc.dart';
import 'package:core/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularBloc extends MockBloc<PopularEvent, PopularState>
    implements PopularBloc {}

class PopularEventFake extends Fake implements PopularEvent {}

class PopularStateFake extends Fake implements PopularState {}

void main() {
  late MockPopularBloc mockPopularBloc;

  setUpAll(() {
    registerFallbackValue(PopularEventFake());
    registerFallbackValue(PopularStateFake());
  });
  setUp(() {
    mockPopularBloc = MockPopularBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularBloc>.value(
      value: mockPopularBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularBloc.state).thenReturn(PopularLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularBloc.state).thenReturn(TvPopularHasData(tTvList));
    // when(mockNotifier.movies).thenReturn(<Movie>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockPopularBloc.state)
        .thenReturn(const PopularError('Error message'));
    // when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    expect(textFinder, findsOneWidget);
  });
}
