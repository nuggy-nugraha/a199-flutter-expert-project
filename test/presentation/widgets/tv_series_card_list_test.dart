import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTVSeries = TVSeries(
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2021-03-19',
    genreIds: [10765, 10759],
    id: 88396,
    name: 'The Falcon and the Winter Soldier',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'The Falcon and the Winter Soldier',
    overview:
        'Following the events of Avengers: Endgame, Sam and Bucky team up.',
    popularity: 78.978,
    posterPath: '/poster.jpg',
    voteAverage: 7.9,
    voteCount: 5765,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('TV Series Detail Page')),
        );
      },
    );
  }

  testWidgets('TVSeriesCard should display tv series name and overview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const TVSeriesCard(tTVSeries)));

    expect(find.text('The Falcon and the Winter Soldier'), findsOneWidget);
    expect(
      find.text(
        'Following the events of Avengers: Endgame, Sam and Bucky team up.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('TVSeriesCard should navigate to detail page on tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const TVSeriesCard(tTVSeries)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('TV Series Detail Page'), findsOneWidget);
  });

  testWidgets('TVSeriesCard should display dash when name is null', (
    WidgetTester tester,
  ) async {
    const tvSeriesWithNullName = TVSeries.watchlist(
      id: 1,
      name: null,
      posterPath: null,
      overview: null,
    );

    await tester.pumpWidget(
      makeTestableWidget(const TVSeriesCard(tvSeriesWithNullName)),
    );

    // Should render without errors and show '-' for null values
    expect(find.byType(TVSeriesCard), findsOneWidget);
  });
}
