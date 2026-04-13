import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Constants', () {
    test('baseImageUrl should be correct', () {
      expect(baseImageUrl, 'https://image.tmdb.org/t/p/w500');
    });

    test('Color constants should have correct values', () {
      expect(richBlack, const Color(0xFF000814));
      expect(oxfordBlue, const Color(0xFF001D3D));
      expect(prussianBlue, const Color(0xFF003566));
      expect(mikadoYellow, const Color(0xFFffc300));
      expect(davysGrey, const Color(0xFF4B5358));
      expect(grey, const Color(0xFF303030));
    });

    test('kColorScheme should have correct brightness and colors', () {
      expect(colorScheme.brightness, Brightness.dark);
      expect(colorScheme.primary, mikadoYellow);
      expect(colorScheme.secondary, prussianBlue);
      expect(colorScheme.surface, richBlack);
    });

    testWidgets('TextStyle and theme constants should be properly defined', (
      WidgetTester tester,
    ) async {
      // Access text styles within a widget context to handle GoogleFonts loading
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark().copyWith(
            colorScheme: colorScheme,
            primaryColor: richBlack,
            scaffoldBackgroundColor: richBlack,
            textTheme: textTheme,
            drawerTheme: drawerTheme,
          ),
          home: Scaffold(
            body: Column(
              children: [
                Text('Heading 5', style: heading5),
                Text('Heading 6', style: heading6),
                Text('Subtitle', style: subtitle),
                Text('Body', style: bodyText),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Heading 5'), findsOneWidget);
      expect(find.text('Heading 6'), findsOneWidget);
      expect(textTheme.headlineMedium, heading5);
      expect(textTheme.headlineSmall, heading6);
      expect(drawerTheme.backgroundColor, Colors.grey.shade700);
    });
  });
}
