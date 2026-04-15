import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedTVSeriesBloc
    extends MockBloc<TopRatedTVSeriesEvent, TopRatedTVSeriesState>
    implements TopRatedTVSeriesBloc {}

void main() {
  late MockTopRatedTVSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTVSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      const Stream<TopRatedTVSeriesState>.empty(),
      initialState: TopRatedTVSeriesLoading(),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      const Stream<TopRatedTVSeriesState>.empty(),
      initialState: const TopRatedTVSeriesLoaded(<TVSeries>[]),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      const Stream<TopRatedTVSeriesState>.empty(),
      initialState: const TopRatedTVSeriesError('Error message'),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets(
    'Page should display TVSeriesCard when data is loaded with tv series',
    (WidgetTester tester) async {
      whenListen(
        mockBloc,
        const Stream<TopRatedTVSeriesState>.empty(),
        initialState: const TopRatedTVSeriesLoaded([testTVSeries]),
      );

      await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

      expect(find.byType(ListView), findsOneWidget);
    },
  );
}
