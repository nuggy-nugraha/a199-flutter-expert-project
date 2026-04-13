import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailNotifier])
void main() {
  late MockMovieDetailNotifier mockNotifier;

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    mockNotifier = MockMovieDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when movie is added to wathclist',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

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
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Failed');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

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
    when(mockNotifier.movieState).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when state is error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.movieState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets(
    'Page should display recommendation loading when recommendation is loading',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loading);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    },
  );

  testWidgets(
    'Page should display recommendation error when recommendation state is error',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.error);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.message).thenReturn('Error');

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.text('Error'), findsOneWidget);
    },
  );

  testWidgets(
    'Page should display recommendation list when recommendation state is loaded',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn(testMovieList);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byType(ListView), findsWidgets);
    },
  );

  testWidgets(
    'Page should display empty container when recommendation state is empty',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.empty);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      // Should render without errors
      expect(find.byType(MovieDetailPage), findsOneWidget);
    },
  );
}
