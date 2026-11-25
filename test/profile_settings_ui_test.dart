import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kainara/data/auth_store.dart';
import 'package:kainara/data/profile_store.dart';
import 'package:kainara/data/settings_store.dart';
import 'package:kainara/screens/profil_page.dart';
import 'package:kainara/screens/settings_pages.dart';

void main() {
  setUp(() {
    const email = 'profile-settings-ui@kainara.test';
    if (!AuthStore.instance.emailExists(email)) {
      AuthStore.instance.register(
        'Dewi Indah Permata Sari',
        email,
        'profile-test-password',
      );
    }
    AuthStore.instance.updateName('Dewi Indah Permata Sari');
    ProfileStore.instance.update(
      email: email,
      name: 'Dewi Indah Permata Sari',
      gender: 'Perempuan',
      verified: true,
      clearAvatar: true,
    );
    SettingsStore.instance.setSaveLoginInfo(true);
  });

  testWidgets('edit nama menyimpan perubahan ke profil', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: EditNamaProfilPage()));
    await tester.pumpAndSettle();
    expect(find.text('NAMA'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Dewi Sari');
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    expect(ProfileStore.instance.name, 'Dewi Sari');
    expect(tester.takeException(), isNull);
  });

  testWidgets('profil membuka opsi foto dan dialog ubah gender', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ProfilPage()));
    await tester.pumpAndSettle();

    expect(find.text('Dewi Indah Permata Sari'), findsOneWidget);
    await tester.tap(find.byType(CircleAvatar).first);
    await tester.pumpAndSettle();
    expect(find.text('Edit foto profil'), findsOneWidget);
    expect(find.text('Pilih foto'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Perempuan').first);
    await tester.pumpAndSettle();
    expect(find.text('Simpan Perubahan'), findsOneWidget);
    await tester.tap(find.text('Laki-laki').last);
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(ProfileStore.instance.gender, 'Laki-laki');
    expect(tester.takeException(), isNull);
  });

  testWidgets('pengaturan privasi menampilkan dan mengubah toggle login', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: PrivasiPage()));
    await tester.pumpAndSettle();

    expect(find.text('Privasi & Keamanan'), findsOneWidget);
    expect(find.text('Simpan info login'), findsOneWidget);
    expect(SettingsStore.instance.saveLoginInfo, isTrue);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(SettingsStore.instance.saveLoginInfo, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('layar pengaturan akun dan perangkat tidak overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: PengaturanPage()));
    await tester.pumpAndSettle();
    expect(find.text('Ganti Akun'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const MaterialApp(home: PerangkatPage()));
    await tester.pumpAndSettle();
    expect(find.text('Samsung Galaxy S26 Ultra'), findsOneWidget);
    expect(find.text('Chrome'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pop up ganti akun dan logout ditampilkan', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: PengaturanPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ganti Akun'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih akun yang ingin Anda gunakan.'), findsOneWidget);
    expect(find.text('Yanto Mulyanto'), findsOneWidget);
    expect(find.text('Tambahkan akun lain'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();
    expect(find.text('Logout dari akun'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.text('Ya, logout'), findsOneWidget);
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('layar pengaturan utama tetap muat di ukuran ponsel', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final pages = <Widget>[
      const NotifikasiSettingsPage(),
      const BahasaPage(),
      const KeamananPage(),
      const PasswordEmailPage(),
    ];

    for (final page in pages) {
      await tester.pumpWidget(MaterialApp(home: page));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
