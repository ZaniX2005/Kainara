import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kainara/widgets/region_filter_dialog.dart';

void main() {
  testWidgets('filter motif dan outfit menampilkan pilihan dan menerapkannya', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Set<String>? selectedRegions;
    OutfitFilter? selectedOutfits;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextButton(
                onPressed: () async {
                  selectedRegions = await showRegionFilterDialog(
                    tester.element(find.byType(Scaffold)),
                    selected: const {},
                  );
                },
                child: const Text('Open region filter'),
              ),
              TextButton(
                onPressed: () async {
                  selectedOutfits = await showOutfitFilterDialog(
                    tester.element(find.byType(Scaffold)),
                    initial: const OutfitFilter(),
                  );
                },
                child: const Text('Open outfit filter'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open region filter'));
    await tester.pumpAndSettle();
    expect(find.text('Filter Daerah Motif Tapis'), findsOneWidget);
    await tester.tap(find.text('Lampung Barat'));
    await tester.tap(find.text('Terapkan'));
    await tester.pumpAndSettle();
    expect(selectedRegions, contains('Lampung Barat'));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Open outfit filter'));
    await tester.pumpAndSettle();
    expect(find.text('Filter Rekomendasi Outfit'), findsOneWidget);
    expect(find.text('Jenis Pakaian'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    expect(find.text('Acara / Style'), findsOneWidget);
    await tester.tap(find.text('Dress'));
    await tester.tap(find.text('Wanita'));
    await tester.tap(find.text('Semi-Formal'));
    await tester.tap(find.text('Terapkan'));
    await tester.pumpAndSettle();
    expect(selectedOutfits?.types, contains('Dress'));
    expect(selectedOutfits?.genders, contains('Wanita'));
    expect(selectedOutfits?.styles, contains('Semi-Formal'));
    expect(tester.takeException(), isNull);
  });
}
