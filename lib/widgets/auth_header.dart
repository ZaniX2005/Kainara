import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Header: gambar penuh, lalu panel krem bergelombang,
/// lalu gambar yang sama DIPOTONG hanya di area badak agar badak
/// tampil di depan krem (seperti desain).
class AuthHeader extends StatelessWidget {
  final double s;
  const AuthHeader({super.key, required this.s});

  static const _img = 'assets/images/header_lampung.png';

  Widget _image(double w) => SizedBox(
    width: w,
    height: 415 * s,
    child: Image.asset(
      _img,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      errorBuilder: (_, _, _) => Container(color: const Color(0xFFD6E6F5)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // 1. Gambar penuh
            Positioned(top: 0, left: 0, child: _image(w)),

            // 2. Panel krem bergelombang
            Positioned(
              top: 240 * s,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipPath(
                clipper: _WaveClipper(s),
                child: const ColoredBox(color: AppColors.page),
              ),
            ),

            // 3. Badak di depan krem: gambar yang sama, hanya area badak
            Positioned(
              top: 0,
              left: 0,
              child: ClipPath(clipper: _RhinoClipper(s, w), child: _image(w)),
            ),
          ],
        );
      },
    );
  }
}

/// Gelombang krem: mulai di kiri sekitar y=255, punuk kecil, lalu turun
/// ke kanan sampai y=415 (desain 390 x 844).
class _WaveClipper extends CustomClipper<Path> {
  final double s;
  _WaveClipper(this.s);

  @override
  Path getClip(Size size) {
    final w = size.width;
    // Titik path dihitung relatif terhadap posisi panel (top: 240*s).
    final path = Path()..moveTo(0, size.height);
    path.lineTo(0, 22 * s);
    path.cubicTo(w * 0.10, 2 * s, w * 0.32, 0, w * 0.50, 28 * s);
    path.cubicTo(w * 0.68, 60 * s, w * 0.85, 120 * s, w, 165 * s);
    path.lineTo(w, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _WaveClipper old) => old.s != s;
}

/// Hanya area badak (kanan) yang digambar ulang di depan krem.
/// Tepi kirinya mengikuti kurva krem, jadi tidak ada garis lurus.
class _RhinoClipper extends CustomClipper<Path> {
  final double s, w;
  _RhinoClipper(this.s, this.w);

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(w * 0.60, 140 * s)
      ..lineTo(w, 140 * s)
      ..lineTo(w, 415 * s)
      ..lineTo(w * 0.62, 415 * s)
      ..quadraticBezierTo(w * 0.66, 330 * s, w * 0.60, 140 * s)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _RhinoClipper old) => old.s != s || old.w != w;
}
