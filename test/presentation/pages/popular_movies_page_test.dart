import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

void main() {
  late MockPopularMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: PopularMoviesLoading(),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: PopularMoviesLoaded(<Movie>[]),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: const PopularMoviesError('Error message'),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display MovieCard when data is loaded with movies', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: PopularMoviesLoaded([testMovie]),
    );

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });
}
