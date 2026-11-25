import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kainara/screens/scan_result_page.dart';

void main() {
  testWidgets('hasil scan menampilkan informasi pakaian dan komponen outfit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ScanResultPage(id: 'm1')));
    await tester.pumpAndSettle();

    expect(find.text('KOMPONEN OUTFIT'), findsOneWidget);
    expect(find.text('Informasi Pakaian'), findsOneWidget);
    expect(find.text('Daerah'), findsOneWidget);
    expect(find.text('Adat'), findsAtLeastNWidgets(1));
    expect(find.text('Jenis'), findsOneWidget);
    expect(find.text('Ciri khas'), findsOneWidget);
    expect(find.text('Rekomendasi Outfit'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
