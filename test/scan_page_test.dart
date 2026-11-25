import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kainara/screens/scan_page.dart';

void main() {
  testWidgets('scan layout remains scrollable on a short phone screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ScanPage()));
    await tester.pumpAndSettle();

    expect(find.text('PEMINDAI MOTIF TAPIS'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(320, 580);
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
