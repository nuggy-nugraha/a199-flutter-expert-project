import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> _waitForNetwork(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

Future<void> _launchApp(WidgetTester tester) async {
  app.main(); 
  await _waitForNetwork(tester);
}

Future<void> _goToTVSeriesHome(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.text('TV Series'));
  await _waitForNetwork(tester);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await di.locator.reset();
  });

  testWidgets(
    '1. App should launch and show Movie Home AppBar with title Ditonton',
    (tester) async {
      await _launchApp(tester);

      expect(find.text('Ditonton'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    },
  );

  testWidgets(
    '2. Movie Home should display Now Playing, Popular, and Top Rated sections',
    (tester) async {
      await _launchApp(tester);

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    },
  );

  testWidgets(
    '3. Movie Home Drawer should list Movies, TV Series, Watchlist, About',
    (tester) async {
      await _launchApp(tester);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TV Series'), findsOneWidget);
      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    },
  );

  testWidgets(
    '4. Popular Movies page should open when Popular See More is tapped',
    (tester) async {
      await _launchApp(tester);

      final popularSeeMore = find.text('See More').first;
      await tester.ensureVisible(popularSeeMore);
      await tester.pumpAndSettle();
      await tester.tap(popularSeeMore);
      await _waitForNetwork(tester);

      expect(find.text('Popular Movies'), findsOneWidget);
    },
  );

  testWidgets(
    '5. Top Rated Movies page should open when Top Rated See More is tapped',
    (tester) async {
      await _launchApp(tester);

      final topRatedSeeMore = find.text('See More').last;
      await tester.ensureVisible(topRatedSeeMore);
      await tester.pumpAndSettle();
      await tester.tap(topRatedSeeMore);
      await _waitForNetwork(tester);

      expect(find.text('Top Rated Movies'), findsOneWidget);
    },
  );

  testWidgets(
    '6. Movie Search page should open and contain a search TextField',
    (tester) async {
      await _launchApp(tester);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.text('Search'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search Result'), findsOneWidget);
    },
  );

  testWidgets(
    '7. Movie Search should display results after submitting a query',
    (tester) async {
      await _launchApp(tester);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'spiderman');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await _waitForNetwork(tester);

      expect(find.byType(TextField), findsOneWidget);
    },
  );

  testWidgets(
    '8. Watchlist Movies page should open from Movie Home drawer',
    (tester) async {
      await _launchApp(tester);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Watchlist'));
      await _waitForNetwork(tester);

      expect(find.text('Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    '9. About page should open from Movie Home drawer and display description',
    (tester) async {
      await _launchApp(tester);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Ditonton merupakan'), findsOneWidget);
    },
  );

  testWidgets(
    '10. TV Series Home page should open via drawer TV Series item',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      expect(find.text('Ditonton TV Series'), findsOneWidget);
    },
  );

  testWidgets(
    '11. TV Series Home should display Now Playing, Popular, Top Rated sections',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    },
  );

  testWidgets(
    '12. TV Series Home Drawer should list Movies, TV Series, Watchlist TV Series, About',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TV Series'), findsOneWidget);
      expect(find.text('Watchlist TV Series'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    },
  );

  testWidgets(
    '13. Now Playing TV Series page should open from See More',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      final nowPlayingSeeMore = find.text('See More').first;
      await tester.ensureVisible(nowPlayingSeeMore);
      await tester.pumpAndSettle();
      await tester.tap(nowPlayingSeeMore);
      await _waitForNetwork(tester);

      expect(find.text('Now Playing TV Series'), findsOneWidget);
    },
  );

  testWidgets(
    '14. Popular TV Series page should open from See More',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      final popularSeeMore = find.text('See More').at(1);
      await tester.ensureVisible(popularSeeMore);
      await tester.pumpAndSettle();
      await tester.tap(popularSeeMore);
      await _waitForNetwork(tester);

      expect(find.text('Popular TV Series'), findsOneWidget);
    },
  );

  testWidgets(
    '15. Top Rated TV Series page should open from See More',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      final topRatedSeeMore = find.text('See More').last;
      await tester.ensureVisible(topRatedSeeMore);
      await tester.pumpAndSettle();
      await tester.tap(topRatedSeeMore);
      await _waitForNetwork(tester);

      expect(find.text('Top Rated TV Series'), findsOneWidget);
    },
  );

  testWidgets(
    '16. TV Series Search page should open and contain a search TextField',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.text('Search TV Series'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search Result'), findsOneWidget);
    },
  );

  testWidgets(
    '17. TV Series Search should display results after submitting a query',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'breaking bad');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await _waitForNetwork(tester);

      expect(find.byType(TextField), findsOneWidget);
    },
  );

  testWidgets(
    '18. Watchlist TV Series page should open from TV Series Home drawer',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Watchlist TV Series'));
      await _waitForNetwork(tester);

      expect(find.text('Watchlist TV Series'), findsOneWidget);
    },
  );

  testWidgets(
    '19. About page should open from TV Series Home drawer and display description',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Ditonton merupakan'), findsOneWidget);
    },
  );

  testWidgets(
    '20. TV Series Home drawer Movies item should navigate back to Movie Home',
    (tester) async {
      await _launchApp(tester);
      await _goToTVSeriesHome(tester);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Movies'));
      await _waitForNetwork(tester);

      expect(find.text('Ditonton'), findsOneWidget);
      expect(find.text('Now Playing'), findsOneWidget);
    },
  );
}