import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/detail/bloc/detail_bloc.dart';
import 'package:core/presentation/bloc/recommendation/bloc/recommendation_bloc.dart';
import 'package:core/presentation/bloc/watchlist/bloc/watchlist_bloc.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockDetailBloc extends MockBloc<DetailEvent, DetailState>
    implements DetailBloc {}

class DetailEventFake extends Fake implements DetailEvent {}

class DetailStateFake extends Fake implements DetailState {}

class MockRecommendationBloc
    extends MockBloc<RecommendationEvent, RecommendationState>
    implements RecommendationBloc {}

class RecommendationEventFake extends Fake implements RecommendationEvent {}

class RecommendationStateFake extends Fake implements RecommendationState {}

class MockWatchlistBloc extends MockBloc<WatchlistEvent, WatchlistState>
    implements WatchlistBloc {}

class WatchlistEventFake extends Fake implements WatchlistEvent {}

class WatchlistStateFake extends Fake implements WatchlistState {}

void main() {
  late MockDetailBloc mockDetailBloc;
  late MockRecommendationBloc mockRecommendationBloc;
  late MockWatchlistBloc mockWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(DetailEventFake());
    registerFallbackValue(DetailStateFake());
    registerFallbackValue(RecommendationEventFake());
    registerFallbackValue(RecommendationStateFake());
    registerFallbackValue(WatchlistEventFake());
    registerFallbackValue(WatchlistStateFake());
  });

  setUp(() {
    mockDetailBloc = MockDetailBloc();
    mockRecommendationBloc = MockRecommendationBloc();
    mockWatchlistBloc = MockWatchlistBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailBloc>(create: (context) => mockDetailBloc),
        BlocProvider<RecommendationBloc>(
            create: (context) => mockRecommendationBloc),
        BlocProvider<WatchlistBloc>(create: (context) => mockWatchlistBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state)
        .thenReturn(const MovieDetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(MovieRecommendationHasData(tMovieList));
    when(() => mockWatchlistBloc.state)
        .thenReturn(const WatchlistHasData(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state)
        .thenReturn(const MovieDetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(MovieRecommendationHasData(tMovieList));
    when(() => mockWatchlistBloc.state)
        .thenReturn(const WatchlistHasData(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
}
