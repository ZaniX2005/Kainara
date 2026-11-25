import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Header persis desain 390 x 844. Tiga lapisan dengan ukuran sama (390 x 371):
/// latar -> lengkungan krem -> badak. Krem polos mulai y=415.
class AuthHeader extends StatelessWidget {
  final double s; // lebar layar / 390
  const AuthHeader({super.key, required this.s});

  static const _cropTop = 50.0;
  static const _headerHeight = 415.0;

  @override
  Widget build(BuildContext context) {
    final imageHeight = _headerHeight + _cropTop;
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: 414 * s,
          left: 0,
          right: 0,
          bottom: 0,
          child: const ColoredBox(color: AppColors.page),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: _headerHeight * s,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.bottomCenter,
              minHeight: imageHeight * s,
              maxHeight: imageHeight * s,
              child: Image.asset(
                'assets/images/auth_header.png',
                width: 390 * s,
                height: imageHeight * s,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
