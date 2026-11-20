import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kainara/data/auth_store.dart';
import 'package:kainara/screens/forgot_page.dart';
import 'package:kainara/screens/login_page.dart';
import 'package:kainara/screens/otp_page.dart';
import 'package:kainara/screens/register_page.dart';
import 'package:kainara/screens/verified_page.dart';
import 'package:kainara/theme/app_theme.dart';

Future<void> _loadFonts() async {
  final poppins = FontLoader('Poppins')
    ..addFont(rootBundle.load('assets/fonts/Poppins-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Poppins-Medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Poppins-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Poppins-Bold.ttf'));
  await poppins.load();
  final serif = FontLoader('EBGaramond')
    ..addFont(rootBundle.load('assets/fonts/EBGaramond-SemiBold.ttf'));
  await serif.load();
}

Future<void> _precache(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final image = (element.widget as Image).image;
      await precacheImage(image, element);
    }
  });
  await tester.pump();
}

Future<void> _setup(
  WidgetTester tester,
  Widget page, {
  Size screenSize = const Size(390, 844),
}) async {
  tester.view.physicalSize = screenSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: page,
    ),
  );
  await _precache(tester);
  await tester.pump(const Duration(milliseconds: 200));
}

Future<void> _capture(
  WidgetTester tester,
  String name, {
  Duration settle = const Duration(milliseconds: 350),
}) async {
  await tester.pump(settle);
  await _precache(tester);
  await tester.pump(const Duration(milliseconds: 80));
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );
}

void main() {
  setUpAll(_loadFonts);

  testWidgets('auth header fills the screen without a mock status bar', (
    tester,
  ) async {
    const screenSize = Size(468, 844);
    await _setup(tester, const LoginPage(), screenSize: screenSize);

    final header = find.byWidgetPredicate((widget) {
      if (widget is! Image || widget.image is! AssetImage) return false;
      return (widget.image as AssetImage).assetName ==
          'assets/images/auth_header.png';
    });
    expect(tester.getSize(header).width, screenSize.width);
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is! Image || widget.image is! AssetImage) return false;
        return (widget.image as AssetImage).assetName ==
            'assets/images/auth_status_bar.png';
      }),
      findsNothing,
    );
  });

  testWidgets('login empty', (tester) async {
    await _setup(tester, const LoginPage());
    await _capture(tester, 'login_07_empty');
  });

  testWidgets('login email filled', (tester) async {
    await _setup(tester, const LoginPage());
    await tester.enterText(find.byType(TextField).first, 'nama@gmail.com');
    await _capture(tester, 'login_08_filled');
  });

  testWidgets('login empty email error', (tester) async {
    await _setup(tester, const LoginPage());
    await tester.tap(find.text('Masuk Akun'));
    await tester.pump();
    await _capture(tester, 'login_09_empty_email');
  });

  testWidgets('login wrong password', (tester) async {
    await _setup(tester, const LoginPage());
    await tester.enterText(
      find.byType(TextField).at(0),
      'danielle21@gmail.com',
    );
    await tester.enterText(find.byType(TextField).at(1), 'salah123');
    await tester.tap(find.text('Masuk Akun'));
    await tester.pump();
    await _capture(tester, 'login_10_wrong_password');
  });

  testWidgets('login filled password', (tester) async {
    await _setup(tester, const LoginPage());
    await tester.enterText(
      find.byType(TextField).at(0),
      'danielle21@gmail.com',
    );
    await tester.enterText(find.byType(TextField).at(1), 'Kainara123');
    await _capture(tester, 'login_11_filled_pass');
  });

  testWidgets('login invalid email', (tester) async {
    await _setup(tester, const LoginPage());
    await tester.enterText(
      find.byType(TextField).at(0),
      'tidakada21@gmail.com',
    );
    await tester.enterText(find.byType(TextField).at(1), 'Kainara123');
    await tester.tap(find.text('Masuk Akun'));
    await tester.pump();
    await _capture(tester, 'login_12_invalid_email');
  });

  testWidgets('register empty', (tester) async {
    await _setup(tester, const RegisterPage());
    await _capture(tester, 'register_08_empty');
  });

  testWidgets('register name', (tester) async {
    await _setup(tester, const RegisterPage());
    await tester.enterText(find.byType(TextField).at(0), 'Danielle');
    await _capture(tester, 'register_09_name');
  });

  testWidgets('register name email', (tester) async {
    await _setup(tester, const RegisterPage());
    await tester.enterText(find.byType(TextField).at(0), 'Danielle');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Danielle21@gmail.com',
    );
    await _capture(tester, 'register_10_name_email');
  });

  testWidgets('register hidden password', (tester) async {
    await _setup(tester, const RegisterPage());
    await tester.enterText(find.byType(TextField).at(0), 'Danielle');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Danielle21@gmail.com',
    );
    await tester.enterText(find.byType(TextField).at(2), 'Kainara123');
    await _capture(tester, 'register_11_hidden');
  });

  testWidgets('register visible password', (tester) async {
    await _setup(tester, const RegisterPage());
    await tester.enterText(find.byType(TextField).at(0), 'Danielle');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Danielle21@gmail.com',
    );
    await tester.enterText(find.byType(TextField).at(2), 'Kainara123');
    await tester.tapAt(const Offset(334, 624));
    await tester.pump();
    await _capture(tester, 'register_12_visible');
  });

  testWidgets('register short password', (tester) async {
    await _setup(tester, const RegisterPage());
    await tester.enterText(find.byType(TextField).at(0), 'Danielle');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Danielle21@gmail.com',
    );
    await tester.enterText(find.byType(TextField).at(2), '12345');
    await tester.tap(find.text('Masuk Akun'));
    await tester.pump();
    await _capture(tester, 'register_13_short');
  });

  testWidgets('forgot empty', (tester) async {
    await _setup(tester, const ForgotPage());
    await _capture(tester, 'forgot_04_empty');
  });

  testWidgets('forgot error', (tester) async {
    await _setup(tester, const ForgotPage());
    await tester.enterText(find.byType(TextField).first, 'kainara@gmail.com');
    await tester.tap(find.text('Masuk Akun'));
    await tester.pump();
    await _capture(tester, 'forgot_05_error');
  });

  testWidgets('forgot filled', (tester) async {
    await _setup(tester, const ForgotPage());
    await tester.enterText(
      find.byType(TextField).first,
      'danielle21@gmail.com',
    );
    await _capture(tester, 'forgot_06_filled');
  });

  testWidgets('otp empty', (tester) async {
    final flow = OtpFlow(purpose: OtpPurpose.register, email: 'a@b.com');
    await _setup(tester, OtpPage(flow: flow));
    await _capture(tester, 'otp_06_empty');
  });

  testWidgets('otp full', (tester) async {
    final flow = OtpFlow(purpose: OtpPurpose.register, email: 'a@b.com');
    await _setup(tester, OtpPage(flow: flow));
    await tester.enterText(find.byType(TextField), '48292');
    await tester.pump(const Duration(milliseconds: 100));
    await _capture(tester, 'otp_08_full');
  });

  testWidgets('otp wrong', (tester) async {
    final flow = OtpFlow(purpose: OtpPurpose.register, email: 'a@b.com');
    await _setup(tester, OtpPage(flow: flow));
    await tester.enterText(find.byType(TextField), '48291');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Masuk Akun'));
    await tester.pump();
    await _capture(tester, 'otp_09_wrong');
  });

  testWidgets('otp partial', (tester) async {
    final flow = OtpFlow(purpose: OtpPurpose.register, email: 'a@b.com');
    await _setup(tester, OtpPage(flow: flow));
    await tester.enterText(find.byType(TextField), '482');
    await tester.pump(const Duration(milliseconds: 100));
    await _capture(tester, 'otp_11_partial');
  });

  testWidgets('verified', (tester) async {
    final flow = OtpFlow(purpose: OtpPurpose.register, email: 'a@b.com');
    await _setup(tester, VerifiedPage(flow: flow));
    await _capture(
      tester,
      'otp_10_verified',
      settle: const Duration(milliseconds: 700),
    );
  });
}
