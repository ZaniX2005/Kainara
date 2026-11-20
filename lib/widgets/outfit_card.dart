import 'package:flutter/material.dart';
import '../models/motif.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'asset_img.dart';
import 'heart_button.dart';

class OutfitCard extends StatelessWidget {
  final Outfit outfit;
  final bool showText;

  /// Bila diisi, tinggi foto dibuat tetap (dipakai pada grid masonry).
  final double? imageHeight;

  const OutfitCard({
    super.key,
    required this.outfit,
    this.showText = true,
    this.imageHeight,
  });

  Widget _image({double? radius}) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(radius ?? 0)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AssetImg(outfit.image),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000),
                  Color(0x00000000),
                  Color(0x55000000),
                ],
                stops: [0, 0.7, 1],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: HeartButton(
              favKey: 'outfit:${outfit.image}',
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!showText) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AssetImg(outfit.image),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x00000000),
                    Color(0xBB000000),
                  ],
                  stops: [0, 0.55, 1],
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: HeartButton(
                favKey: 'outfit:${outfit.image}',
                size: 26,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      shadowColor: const Color(0x26000000),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: imageHeight == null ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (imageHeight != null)
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: _image(),
            )
          else
            Expanded(child: _image()),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  outfit.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(
                    16,
                    color: AppColors.maroon,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  outfit.motifName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(11, color: const Color(0xFF7A5C57)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
