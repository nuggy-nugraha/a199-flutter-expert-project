import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_page_test.mocks.dart';

@GenerateMocks([TopRatedTVSeriesNotifier])
void main() {
  late MockTopRatedTVSeriesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedTVSeriesNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTVSeriesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tvSeries).thenReturn(<TVSeries>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets(
    'Page should display TVSeriesCard when data is loaded with tv series',
    (WidgetTester tester) async {
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeries).thenReturn([testTVSeries]);

      await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

      expect(find.byType(ListView), findsOneWidget);
    },
  );
}
