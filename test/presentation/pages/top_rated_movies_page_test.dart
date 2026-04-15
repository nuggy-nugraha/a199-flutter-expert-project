import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<TopRatedMoviesState>.empty(),
      initialState: TopRatedMoviesLoading(),
    );

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<TopRatedMoviesState>.empty(),
      initialState: TopRatedMoviesLoaded(<Movie>[]),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<TopRatedMoviesState>.empty(),
      initialState: const TopRatedMoviesError('Error message'),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display MovieCard when data is loaded with movies', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<TopRatedMoviesState>.empty(),
      initialState: TopRatedMoviesLoaded([testMovie]),
    );

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });
}
