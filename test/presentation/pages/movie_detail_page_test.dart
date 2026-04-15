import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc
    extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  const baseLoadedState = MovieDetailLoaded(
    movie: testMovieDetail,
    recommendations: [],
    isAddedToWatchlist: false,
    watchlistMessage: '',
  );

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.empty(),
        initialState: baseLoadedState,
      );

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.empty(),
        initialState: baseLoadedState.copyWith(isAddedToWatchlist: true),
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          baseLoadedState.copyWith(watchlistMessage: 'Added to Watchlist'),
        ]),
        initialState: baseLoadedState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          baseLoadedState.copyWith(watchlistMessage: 'Failed'),
        ]),
        initialState: baseLoadedState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );

  testWidgets('Page should display loading indicator when state is loading', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<MovieDetailState>.empty(),
      initialState: MovieDetailLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when state is error', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<MovieDetailState>.empty(),
      initialState: const MovieDetailError('Error message'),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets(
    'Page should display recommendation list when recommendations are available',
    (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.empty(),
        initialState: baseLoadedState.copyWith(
          recommendations: testMovieList,
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byType(ListView), findsWidgets);
    },
  );

  testWidgets(
    'Page should render without errors when recommendations are empty',
    (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.empty(),
        initialState: baseLoadedState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byType(MovieDetailPage), findsOneWidget);
    },
  );
}
