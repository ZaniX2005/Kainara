import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AssetImg extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;

  const AssetImg(this.path,
      {super.key,
      this.fit = BoxFit.cover,
      this.width,
      this.height,
      this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      errorBuilder: (_, _, _) => Container(
        width: width,
        height: height,
        color: AppColors.brownFallback,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: Colors.white54),
      ),
    );
  }
}