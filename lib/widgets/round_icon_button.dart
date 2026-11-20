import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Bulat jika [radius] null, persegi membulat jika diisi.
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double? radius;
  final Color background;
  final Color iconColor;

  const RoundIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 40,
    this.radius,
    this.background = Colors.white,
    this.iconColor = AppColors.maroon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: radius == null ? null : BorderRadius.circular(radius!),
        ),
        child: Icon(icon, size: size * 0.58, color: iconColor),
      ),
    );
  }
}