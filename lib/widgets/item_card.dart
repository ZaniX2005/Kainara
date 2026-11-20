import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'asset_img.dart';
import 'heart_button.dart';

class ItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String favKey;
  final double imageHeight;
  final bool montserrat;
  final VoidCallback? onTap;

  /// true = area gambar dikosongkan (slot gambar), tanpa memuat aset.
  final bool placeholder;
  final String placeholderLabel;

  const ItemCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.favKey,
    this.imageHeight = 190,
    this.montserrat = false,
    this.onTap,
    this.placeholder = false,
    this.placeholderLabel = 'Gambar',
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = (montserrat
            ? GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.maroon)
            : GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.maroon))
        .copyWith(height: 1.2);
    final descStyle = montserrat
        ? GoogleFonts.montserrat(
            fontSize: 11, height: 1.35, color: const Color(0xFF5E5651))
        : GoogleFonts.poppins(
            fontSize: 11, height: 1.35, color: const Color(0xFF5E5651));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (placeholder)
                      _ImageSlot(label: placeholderLabel)
                    else ...[
                      AssetImg(image, alignment: Alignment.topCenter),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00000000),
                              Color(0x00000000),
                              Color(0x55000000)
                            ],
                            stops: [0, 0.7, 1],
                          ),
                        ),
                      ),
                    ],
                    Positioned(
                      top: 10,
                      right: 10,
                      child: HeartButton(favKey: favKey, size: 30),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle),
                  const SizedBox(height: 1),
                  Text(description,
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: descStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Slot kosong tempat gambar akan dipasang.
class _ImageSlot extends StatelessWidget {
  final String label;
  const _ImageSlot({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4EADC),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE7D8C2)),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFDCC7A6), width: 1.4),
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 22,
                color: Color(0xFFBFA57F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppText.sans(
                10,
                color: const Color(0xFFA89065),
                weight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}