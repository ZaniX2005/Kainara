import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/asset_img.dart';
import '../widgets/collapsible_row.dart';
import '../widgets/outfit_card.dart';

class MotifDetailPage extends StatelessWidget {
  final String id;
  const MotifDetailPage({super.key, required this.id});

  Widget _roundBtn(
    IconData icon,
    VoidCallback onTap, {
    double size = 44,
    double radius = 22,
    Color color = AppColors.maroon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: size * 0.5, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final s = mq.size.width / 390;
    final motif = motifs.firstWhere(
      (m) => m.id == id,
      orElse: () => motifs.first,
    );
    final body = AppText.sans(
      12,
      color: const Color(0xFF3A3A3A),
      weight: FontWeight.w600,
      height: 1.55,
    );

    return Scaffold(
      backgroundColor: AppColors.page,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 110 + mq.padding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 255 * s,
                  width: double.infinity,
                  child: AssetImg(motif.headerImage),
                ),
                Positioned(
                  top: mq.padding.top + 8,
                  left: 14,
                  child: _roundBtn(
                    Icons.chevron_left,
                    () => context.canPop() ? context.pop() : context.go('/'),
                  ),
                ),
              ],
            ),

            // Nama + share
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      motif.name,
                      style: AppText.serif(24, color: AppColors.maroon),
                    ),
                  ),
                  Column(
                    children: [
                      _roundBtn(
                        Icons.share,
                        () => SharePlus.instance.share(
                          ShareParams(
                            text: 'Lihat motif tapis ${motif.name} di KAINARA',
                          ),
                        ),
                        size: 42,
                        radius: 12,
                        color: AppColors.dark,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Share motif',
                        style: AppText.sans(10, color: Colors.black45),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Asal + deskripsi
            Container(
              width: double.infinity,
              color: const Color(0xFFEFEFEF),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asal Motif Tapis: ${motif.origin}',
                    style: AppText.serif(15, color: AppColors.dark),
                  ),
                  const SizedBox(height: 6),
                  Container(height: 1, color: AppColors.dark),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deskripsi Singkat:',
                        style: AppText.serif(15, color: AppColors.dark),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          motif.description,
                          style: AppText.serif(15, color: AppColors.dark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Rekomendasi outfit
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rekomendasi Outfit',
                      style: AppText.serif(16, color: AppColors.dark),
                    ),
                  ),
                  _roundBtn(
                    Icons.chevron_right,
                    () => context.push('/outfit-pick'),
                    size: 28,
                    radius: 8,
                    color: AppColors.dark,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 112 * s,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: outfits.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => context.push('/outfit-pick'),
                  child: SizedBox(
                    width: 80 * s,
                    child: OutfitCard(outfit: outfits[i], showText: false),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            CollapsibleRow(
              title: 'Penggunaan',
              child: Text(motif.usage, style: body),
            ),
            CollapsibleRow(
              title: 'Perawatan',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perawatan tapis ${motif.name.toLowerCase()} bisa diringkas seperti ini:',
                    style: body,
                  ),
                  const SizedBox(height: 4),
                  for (final c in motif.care)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('•  ', style: body),
                          Expanded(child: Text(c, style: body)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'Dengan cara ini, tapis tetap awet dan indah.',
                    style: body,
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
