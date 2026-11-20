import 'package:flutter/material.dart';

import '../data/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class KainaraBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const KainaraBottomNav({super.key, required this.index, required this.onTap});

  Widget _item(int i, IconData icon, IconData activeIcon, String label) {
    final active = index == i;
    final color = active ? AppColors.maroon : const Color(0xFF8A8A8A);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => onTap(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? activeIcon : icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              tr(label),
              style: AppText.sans(
                10,
                color: color,
                weight: active ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, bottom + 12),
      child: SizedBox(
        height: 74,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 66,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(33),
                  border: Border.all(color: const Color(0xFFE6D9CC)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _item(
                      0,
                      Icons.home_outlined,
                      Icons.home_rounded,
                      'Beranda',
                    ),
                    _item(1, Icons.favorite_border, Icons.favorite, 'Favorit'),
                    const Expanded(child: SizedBox()),
                    _item(3, Icons.history, Icons.history, 'Riwayat'),
                    _item(4, Icons.person_outline, Icons.person, 'Profil'),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => onTap(2),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.maroon,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.center_focus_strong_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 6,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  tr('PINDAI'),
                  style: AppText.sans(
                    10,
                    color: AppColors.maroon,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
