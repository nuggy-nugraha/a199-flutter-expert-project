import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([TVSeriesDetailNotifier])
void main() {
  late MockTVSeriesDetailNotifier mockNotifier;

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    mockNotifier = MockTVSeriesDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVSeriesDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when tv series not added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeries).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.episodeState).thenReturn(RequestState.empty);
      when(mockNotifier.selectedSeason).thenReturn(1);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv series is added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeries).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.episodeState).thenReturn(RequestState.empty);
      when(mockNotifier.selectedSeason).thenReturn(1);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeries).thenReturn(testTVSeriesDetail);
      when(mockNotifier.episodeState).thenReturn(RequestState.empty);
      when(mockNotifier.selectedSeason).thenReturn(1);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockNotifier.episodeState).thenReturn(RequestState.empty);
      when(mockNotifier.selectedSeason).thenReturn(1);
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeries).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Failed');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );

  testWidgets('Page should display loading indicator when state is loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.loading);

    await tester.pumpWidget(
      makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when state is error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(
      makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
    );

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets(
    'Page should display recommendation loading when recommendation is loading',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeries).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loading);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.episodeState).thenReturn(RequestState.empty);
      when(mockNotifier.selectedSeason).thenReturn(1);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
      );

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    },
  );

  testWidgets(
    'Page should display recommendation error when recommendation state is error',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeries).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.error);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.message).thenReturn('Error');
      when(mockNotifier.episodeState).thenReturn(RequestState.empty);
      when(mockNotifier.selectedSeason).thenReturn(1);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
      );

      expect(find.text('Error'), findsOneWidget);
    },
  );

  testWidgets(
    'Page should display recommendation list when recommendation state is loaded',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeries).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(testTVSeriesList);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.episodeState).thenReturn(RequestState.empty);
      when(mockNotifier.selectedSeason).thenReturn(1);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
      );

      expect(find.byType(ListView), findsWidgets);
    },
  );

  testWidgets(
    'Page should display empty container when recommendation state is empty',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvSeries).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.empty);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.episodeState).thenReturn(RequestState.empty);
      when(mockNotifier.selectedSeason).thenReturn(1);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 88396)),
      );

      // Should render without errors
      expect(find.byType(TVSeriesDetailPage), findsOneWidget);
    },
  );
}
