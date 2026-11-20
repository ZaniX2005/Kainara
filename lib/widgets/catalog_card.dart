import 'package:flutter/material.dart';
import '../models/motif.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'asset_img.dart';
import 'heart_button.dart';

class CatalogCard extends StatelessWidget {
  final Motif motif;
  final double imageHeight;
  final VoidCallback? onTap;

  const CatalogCard({
    super.key,
    required this.motif,
    this.imageHeight = 190,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 3,
        shadowColor: const Color(0x26000000),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: imageHeight,
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
                          Color(0x55000000),
                        ],
                        stops: [0, 0.7, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: HeartButton(favKey: 'motif:${motif.id}', size: 30),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    motif.name,
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
                    motif.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(11, color: const Color(0xFF7A5C57)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}