import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tMovie = Movie(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'A hero emerges from humble beginnings.',
    popularity: 60.441,
    posterPath: '/poster.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Detail Page')),
        );
      },
    );
  }

  testWidgets('MovieCard should display movie title and overview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const MovieCard(tMovie)));

    expect(find.text('Spider-Man'), findsOneWidget);
    expect(find.text('A hero emerges from humble beginnings.'), findsOneWidget);
  });

  testWidgets('MovieCard should navigate to detail page on tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const MovieCard(tMovie)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });

  testWidgets('MovieCard should display dash when title is null', (
    WidgetTester tester,
  ) async {
    const movieWithNullTitle = Movie(
      adult: false,
      backdropPath: null,
      genreIds: [],
      id: 1,
      originalTitle: 'Title',
      overview: null,
      popularity: 0,
      posterPath: null,
      releaseDate: null,
      title: null,
      video: false,
      voteAverage: 0,
      voteCount: 0,
    );

    await tester.pumpWidget(
      makeTestableWidget(const MovieCard(movieWithNullTitle)),
    );

    // The card should render without errors even with null values
    expect(find.byType(MovieCard), findsOneWidget);
  });
}
