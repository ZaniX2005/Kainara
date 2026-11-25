import 'package:flutter/material.dart';

import '../data/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// selected: 0 = Rekomendasi Outfit, 1 = Motif Tapis.
/// Tab aktif selalu di kanan, tab lainnya di kiri (abu-abu).
class SlantedTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final double height;

  const SlantedTabs({
    super.key,
    required this.selected,
    required this.onChanged,
    this.height = 36,
  });

  // Lebar tab menurut frame Figma (390 px): aktif 133, tidak aktif 172.
  double _factor(bool active) => active ? 0.341 : 0.441;

  @override
  Widget build(BuildContext context) {
    final labels = [tr('Rekomendasi Outfit'), tr('Motif Tapis')];
    final other = selected == 1 ? 0 : 1;

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final rightW = w * _factor(true);
        final rightLeft = w - rightW;
        final leftW = w * _factor(false);
        final leftLeft = rightLeft - leftW;

        Widget tab(int i, Rect rect, bool active) => Positioned.fromRect(
          rect: rect,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(i),
            child: Center(
              child: Padding(
                // Teks di desain digeser: tab abu-abu ke kanan,
                // tab aktif ke kiri dari titik tengah bentuknya.
                padding: EdgeInsets.only(
                  left: active ? 0 : 15,
                  right: active ? 15 : 0,
                ),
                child: Text(
                  labels[i],
                  maxLines: 1,
                  style: AppText.serif(
                    16,
                    color: AppColors.maroon,
                    weight: active ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );

        return SizedBox(
          width: w,
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/home_tabs_overlay.png',
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
              tab(other, Rect.fromLTWH(leftLeft, 0, leftW, height), false),
              tab(selected, Rect.fromLTWH(rightLeft, 0, rightW, height), true),
            ],
          ),
        );
      },
    );
  }
}
