// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kainara/main.dart';

void main() {
  testWidgets('Home menampilkan motif dan pencarian memfilter kartu', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const KainaraApp());
    await tester.pump();

    expect(find.text('Jung Sarat'), findsOneWidget);
    expect(find.text('Raja Tunggal'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'jung');
    await tester.pump();

    expect(find.text('Jung Sarat'), findsOneWidget);
    expect(find.text('Raja Tunggal'), findsNothing);
  });

  testWidgets('Tab rekomendasi outfit menampilkan kartu outfit', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const KainaraApp());
    await tester.pump();
    await tester.tap(find.text('Rekomendasi Outfit'));
    await tester.pump();

    expect(find.text('Dress'), findsOneWidget);
    expect(find.text('Blazer'), findsNWidgets(2));
  });
}
