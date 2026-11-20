import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Palet warna yang diambil langsung dari file desain (390 x 844).
class AuthColors {
  static const cream = Color(0xFFFFFBF6); // #FFFBF6
  static const maroon = Color(0xFF6D0F0F); // #6D0F0F
  static const error = Color(0xFFDE1D1D); // #DE1D1D
  static const hint = Color(0xFF7A7575); // #7A7575
  static const linkGray = Color(0xFF585756); // #585756
  static const smallGray = Color(0xFF848483); // #848483
  static const divider = Color(0xFFBEBEBE); // #BEBEBE
  static const greeting = Color(0xFF292929); // #292929
  static const otpDot = Color(0xFFC8A19E); // #C8A19E
}

const double kAuthW = 390;
const double kAuthH = 844;

TextStyle authText(
  double size, {
  Color color = AuthColors.maroon,
  FontWeight weight = FontWeight.w400,
  double? height,
  double? letterSpacing,
}) => TextStyle(
  fontFamily: 'Poppins',
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: height,
  letterSpacing: letterSpacing,
);

TextStyle authSerif(
  double size, {
  Color color = AuthColors.greeting,
  FontWeight weight = FontWeight.w600,
  double? height,
  double? letterSpacing,
}) => TextStyle(
  fontFamily: 'EBGaramond',
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: height,
  letterSpacing: letterSpacing,
);

/// Kanvas auth 390 x 844 yang diskalakan ke lebar layar.
/// Header, lengkungan, dan ornamen bawah memakai potongan persis dari desain.
class AuthScaffold extends StatelessWidget {
  final List<Widget> Function(double s) overlays;

  const AuthScaffold({super.key, required this.overlays});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final s = w / kAuthW;
    final h = math.max(size.height, kAuthH * s);

    return Scaffold(
      backgroundColor: AuthColors.cream,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SizedBox(
          width: w,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: h,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: AuthColors.cream),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 420 * s,
                    child: Image.asset(
                      'assets/images/auth_header.png',
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 99 * s,
                    child: Image.asset(
                      'assets/images/auth_ornament.png',
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  ...overlays(s),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Judul + garis tebal maroon.
List<Widget> authTitle(
  double s, {
  required String text,
  bool big = false,
  double left = 29,
  double underlineLeft = 29,
  double underlineTop = 388,
}) {
  final size = big ? 24.0 : 18.0;
  return [
    Positioned(
      left: left * s,
      top: (big ? 353.4 : 352.6) * s,
      width: 330 * s,
      child: Text(
        text,
        maxLines: 1,
        softWrap: false,
        style: authText(
          size,
          color: AuthColors.maroon,
          weight: FontWeight.w600,
          height: 1,
          letterSpacing: big ? 0 : -0.3,
        ),
      ),
    ),
    Positioned(
      left: underlineLeft * s,
      top: underlineTop * s,
      width: 70 * s,
      height: 4 * s,
      child: const ColoredBox(color: AuthColors.maroon),
    ),
  ];
}

/// Label kecil berwarna putih (terlihat samar pada desain).
Widget authLabel(double s, String text, double top, {double left = 32}) {
  return Positioned(
    left: left * s,
    top: top * s,
    child: Text(
      text,
      style: authText(
        14,
        color: Colors.white,
        weight: FontWeight.w500,
        height: 1,
      ),
    ),
  );
}

/// Teks deskripsi maroon 11 px, tinggi baris 18 px.
Widget authDesc(
  double s,
  String text,
  double top, {
  double left = 29,
  double width = 247,
}) {
  return Positioned(
    left: left * s,
    top: top * s,
    width: width * s,
    child: Text(
      text,
      style: authText(11, color: AuthColors.maroon, height: 18 / 11),
    ),
  );
}

/// Teks error merah, tinggi baris 18 px.
Widget authError(
  double s,
  String text,
  double top, {
  double left = 29,
  double width = 286,
  Color color = AuthColors.error,
}) {
  return Positioned(
    left: left * s,
    top: top * s,
    width: width * s,
    child: Text(
      text,
      style: authText(11, color: color, height: 18 / 11),
    ),
  );
}

/// Satu baris input dengan garis bawah maroon.
class AuthInput extends StatefulWidget {
  final double s;
  final double lineTop;
  final TextEditingController controller;
  final String hint;
  final String? icon;
  final double iconTop;
  final double iconWidth;
  final double iconHeight;
  final bool obscure;
  final bool hintError;
  final String? hintOverride;
  final bool filledError;
  final Widget? eye;
  final TextInputType? keyboard;
  final VoidCallback? onChanged;
  final double inputWidth;

  const AuthInput({
    super.key,
    required this.s,
    required this.lineTop,
    required this.controller,
    required this.hint,
    this.icon,
    this.iconTop = 0,
    this.iconWidth = 20,
    this.iconHeight = 20,
    this.obscure = false,
    this.hintError = false,
    this.hintOverride,
    this.filledError = false,
    this.eye,
    this.keyboard,
    this.onChanged,
    this.inputWidth = 262,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  final _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final red = widget.hintError || widget.filledError;
    final style = authText(
      12.3,
      color: red ? AuthColors.error : AuthColors.maroon,
      weight: FontWeight.w400,
      height: 1,
    );

    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 29 * s,
            top: (widget.lineTop - 0.75) * s,
            width: 316 * s,
            height: 1.5 * s,
            child: const ColoredBox(color: AuthColors.maroon),
          ),
          if (widget.icon != null)
            Positioned(
              left: 29 * s,
              top: widget.iconTop * s,
              width: widget.iconWidth * s,
              height: widget.iconHeight * s,
              child: Image.asset(
                widget.icon!,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),
            ),
          Positioned(
            left: 50 * s,
            top: (widget.lineTop - 25.5) * s,
            child: Text(
              ':',
              style: authText(13, color: AuthColors.hint, height: 1),
            ),
          ),
          Positioned(
            left: 66 * s,
            top: (widget.lineTop - 34) * s,
            width: widget.inputWidth * s,
            height: 30 * s,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _focus.requestFocus(),
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                obscureText: widget.obscure,
                obscuringCharacter: '•',
                keyboardType: widget.keyboard,
                onChanged: (_) {
                  setState(() {});
                  widget.onChanged?.call();
                },
                cursorColor: AuthColors.maroon,
                cursorWidth: 1.2,
                cursorHeight: 15,
                style: style,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: widget.hintOverride ?? widget.hint,
                  hintStyle: authText(
                    12.3,
                    color: widget.hintError
                        ? AuthColors.error
                        : AuthColors.hint,
                    height: 1,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          if (widget.eye != null) widget.eye!,
        ],
      ),
    );
  }
}

/// Ikon mata (tutup / buka) sesuai desain.
Widget authEye(
  double s, {
  required bool closed,
  required double lineTop,
  required VoidCallback onTap,
}) {
  return Positioned(
    left: 320 * s,
    top: (lineTop + (closed ? -31.5 : -38.5)) * s,
    width: 28 * s,
    height: (closed ? 21 : 28) * s,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Image.asset(
        closed
            ? 'assets/images/icon_eye_closed.png'
            : 'assets/images/icon_eye_open.png',
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    ),
  );
}

/// Bagian bawah: tombol, link, pembatas, dan ikon sosial.
class AuthFooter extends StatelessWidget {
  final double s;
  final bool loginLink;
  final VoidCallback onButton;
  final VoidCallback onSwitch;
  final VoidCallback onGoogle;
  final VoidCallback onFacebook;
  final double shift;

  const AuthFooter({
    super.key,
    required this.s,
    required this.loginLink,
    required this.onButton,
    required this.onSwitch,
    required this.onGoogle,
    required this.onFacebook,
    this.shift = 0,
  });

  @override
  Widget build(BuildContext context) {
    final y = shift;
    final base = authText(10.5, color: AuthColors.linkGray, height: 1);
    final link = authText(
      10.5,
      color: AuthColors.maroon,
      weight: FontWeight.w600,
      height: 1,
    );

    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 46 * s,
            top: (669 + y) * s,
            width: 282 * s,
            height: 45 * s,
            child: GestureDetector(
              onTap: onButton,
              child: Container(
                decoration: BoxDecoration(
                  color: AuthColors.maroon,
                  borderRadius: BorderRadius.circular(13 * s),
                ),
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, 1 * s),
                  child: Text(
                    'Masuk Akun',
                    style: authText(
                      13,
                      color: Colors.white,
                      weight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 54 * s,
            top: (718.5 + y) * s,
            width: 282 * s,
            child: Text.rich(
              TextSpan(
                style: base,
                children: loginLink
                    ? [
                        const TextSpan(text: 'Apakah anda belum punya akun? '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: onSwitch,
                            child: Text(
                              'Sign up',
                              style: link.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AuthColors.maroon,
                              ),
                            ),
                          ),
                        ),
                      ]
                    : [
                        const TextSpan(text: 'Sudah buat akun? '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: onSwitch,
                            child: Text(
                              'Sign In',
                              style: link.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AuthColors.maroon,
                              ),
                            ),
                          ),
                        ),
                      ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            left: 45 * s,
            top: (742 + y) * s,
            width: 100 * s,
            height: 1 * s,
            child: const ColoredBox(color: AuthColors.divider),
          ),
          Positioned(
            left: 220 * s,
            top: (742 + y) * s,
            width: 100 * s,
            height: 1 * s,
            child: const ColoredBox(color: AuthColors.divider),
          ),
          Positioned(
            left: 141 * s,
            top: (757 + y) * s,
            width: 38 * s,
            height: 42 * s,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onGoogle,
              child: Image.asset(
                'assets/images/icon_google.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          Positioned(
            left: 178 * s,
            top: (757 + y) * s,
            width: 38 * s,
            height: 42 * s,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onFacebook,
              child: Image.asset(
                'assets/images/icon_facebook.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sapaan serif dua baris pada halaman daftar.
Widget authGreeting(double s, String text) {
  return Positioned(
    left: 26 * s,
    top: 57.7 * s,
    width: 300 * s,
    child: Text(text, style: authSerif(24.8, height: 1.25, letterSpacing: 0)),
  );
}

/// Link "Lupa password ?" pada halaman login.
Widget authForgotLink(
  double s, {
  required double top,
  required double right,
  required VoidCallback onTap,
}) {
  return Positioned(
    right: right * s,
    top: top * s,
    child: GestureDetector(
      onTap: onTap,
      child: Text(
        'Lupa password ?',
        style: authText(
          11.5,
          color: AuthColors.maroon,
          weight: FontWeight.w600,
          height: 1,
        ),
      ),
    ),
  );
}

/// Pilihan OTP 5 digit.
class AuthOtpField extends StatelessWidget {
  final double s;
  final TextEditingController controller;
  final FocusNode focus;
  final bool wrong;
  final VoidCallback onChanged;

  const AuthOtpField({
    super.key,
    required this.s,
    required this.controller,
    required this.focus,
    required this.wrong,
    required this.onChanged,
  });

  static const _centers = [73.0, 132.0, 191.0, 250.0, 309.0];

  @override
  Widget build(BuildContext context) {
    final text = controller.text;
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 58 * s,
            top: 515.75 * s,
            width: 271 * s,
            height: 1.5 * s,
            child: const ColoredBox(color: AuthColors.maroon),
          ),
          for (var i = 0; i < _centers.length; i++)
            if (i < text.length)
              Positioned(
                left: (_centers[i] - 25) * s,
                top: 483 * s,
                width: 50 * s,
                child: Text(
                  text[i],
                  textAlign: TextAlign.center,
                  style: authText(
                    20,
                    color: wrong ? AuthColors.error : const Color(0xFF262626),
                    weight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              )
            else
              Positioned(
                left: (_centers[i] - 7.5) * s,
                top: 482.5 * s,
                width: 15 * s,
                height: 15 * s,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AuthColors.otpDot,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          Positioned(
            left: 58 * s,
            top: 468 * s,
            width: 271 * s,
            height: 62 * s,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: focus.requestFocus,
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: controller,
                  focusNode: focus,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  showCursor: false,
                  enableInteractiveSelection: false,
                  onChanged: (_) => onChanged(),
                  decoration: const InputDecoration(counterText: ''),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void authSocialMessage(BuildContext context, String name) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Masuk dengan $name segera hadir')));
}

void authGoLogin(BuildContext context) => context.go('/login');
