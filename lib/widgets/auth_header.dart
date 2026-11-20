import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Header persis desain 390 x 844. Tiga lapisan dengan ukuran sama (390 x 371):
/// latar -> lengkungan krem -> badak. Krem polos mulai y=415.
class AuthHeader extends StatelessWidget {
  final double s; // lebar layar / 390
  const AuthHeader({super.key, required this.s});

  Widget _layer(String name) => Positioned(
        top: 44 * s,
        left: 0,
        right: 0,
        height: 371 * s,
        child: Image.asset(
          'assets/images/$name.png',
          fit: BoxFit.fill, // rasio sama dengan ekspor, jadi tidak melar
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        // Krem polos di bawah header (menyambung dengan lengkungan)
        Positioned(
          top: 414 * s,
          left: 0,
          right: 0,
          bottom: 0,
          child: const ColoredBox(color: AppColors.page),
        ),
        _layer('header_bg'),
        _layer('header_curve'),
        _layer('header_rhino'),
      ],
    );
  }
}