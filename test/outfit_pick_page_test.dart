import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kainara/screens/outfit_pick_page.dart';

void main() {
  testWidgets('outfit utama menampilkan rekomendasi dan favorit dapat diubah', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: OutfitPickPage()));
    await tester.pumpAndSettle();

    expect(find.text('Outfit Utama'), findsOneWidget);
    expect(find.text('Baju Tapis Wanita'), findsOneWidget);
    expect(find.text('Mix & match'), findsOneWidget);
    expect(find.text('Rekomendasi outfit lain'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.ensureVisible(find.text('Share'));
    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();

    expect(find.text('Share ke'), findsOneWidget);
    expect(find.text('Salin Link'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
