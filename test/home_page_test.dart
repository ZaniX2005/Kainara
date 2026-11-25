import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kainara/screens/home_page.dart';
import 'package:kainara/widgets/slanted_tabs.dart';

void main() {
  testWidgets('beranda menampilkan gambar aset pada kartu tapis', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pump();

    final appBar = tester.widget<SliverAppBar>(find.byType(SliverAppBar));
    expect(appBar.expandedHeight, 464);
    final bannerRect = tester.getRect(find.byType(PageView));
    final tabsRect = tester.getRect(find.byType(SlantedTabs));
    expect(tabsRect.top - bannerRect.bottom, 10);

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/home_tabs_overlay.png',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/motif/motif_1.png',
      ),
      findsOneWidget,
    );
    expect(find.text('Jung Sarat'), findsOneWidget);

    await tester.tap(find.text('Rekomendasi Outfit'));
    await tester.pumpAndSettle();
    expect(find.text('Dress'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
