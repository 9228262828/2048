import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_2048/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App launches and shows 2048 title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('2048'), findsWidgets);
  });

  testWidgets('Game board is rendered with 4x4 grid', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // The grid has 16 cells (4x4)
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('Score and Best labels are visible', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('SCORE'), findsOneWidget);
    expect(find.text('BEST'), findsOneWidget);
  });

  testWidgets('New game button is present in AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('Privacy Policy link is visible', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Privacy Policy'), findsWidgets);
  });
}
