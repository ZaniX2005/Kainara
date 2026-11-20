import 'package:flutter/material.dart';
import '../models/motif.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'asset_img.dart';
import 'heart_button.dart';

class MotifCard extends StatelessWidget {
  final Motif motif;
  final double height;
  final bool showBadge;
  final bool showHeart;
  final double titleSize;
  final double subtitleSize;
  final VoidCallback? onTap;

  const MotifCard({
    super.key,
    required this.motif,
    this.height = 190,
    this.showBadge = false,
    this.showHeart = true,
    this.titleSize = 17,
    this.subtitleSize = 11,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AssetImg(motif.image),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0xCC000000),
                    ],
                    stops: [0, 0.5, 1],
                  ),
                ),
              ),
              if (showHeart)
  Positioned(
      top: 10,
      right: 10,
      child: HeartButton(favKey: 'motif:${motif.id}')),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showBadge)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.goldBadge,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          motif.region.toUpperCase(),
                          style: AppText.sans(9,
                              weight: FontWeight.w700, letterSpacing: 0.5),
                        ),
                      ),
                    Text(motif.name, style: AppText.serif(titleSize)),
                    Text(motif.subtitle, style: AppText.sans(subtitleSize)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}