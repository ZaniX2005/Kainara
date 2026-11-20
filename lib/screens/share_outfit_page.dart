import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/asset_img.dart';

class ShareOutfitPage extends StatelessWidget {
  const ShareOutfitPage({super.key});

  static const _text = 'Lihat rekomendasi outfit tapis di aplikasi KAINARA';

  void _share() =>
      SharePlus.instance.share(ShareParams(text: _text));

  Widget _social(FaIconData icon) {
    return GestureDetector(
      onTap: _share,
      child: Container(
        width: 76,
        height: 76,
        color: const Color(0xFFDADADA),
        child: Center(child: FaIcon(icon, size: 38, color: Colors.black)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Column(
        children: [
          Container(
            color: AppColors.maroon,
            padding: EdgeInsets.fromLTRB(12, mq.padding.top + 8, 12, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.canPop() ? context.pop() : context.go('/'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: AppColors.page, shape: BoxShape.circle),
                    child: const Icon(Icons.chevron_left, color: AppColors.maroon),
                  ),
                ),
                const SizedBox(width: 14),
                Text('Bagikan Outfit', style: AppText.serif(20)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(44, 26, 44, 40),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 302 / 360,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(
                            color: Colors.white,
                            child: AssetImg('assets/images/outfit_1.png',
                                alignment: Alignment.topCenter)),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x00000000),
                                Color(0x00000000),
                                Color(0xDD000000)
                              ],
                              stops: [0, 0.6, 1],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text('PUTERI',
                                style: AppText.sans(10,
                                    color: AppColors.dark, weight: FontWeight.w700)),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 120,
                          child: Text('Nama outfit', style: AppText.serif(12)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text('Bagikan outfit',
                          style: AppText.serif(14, color: AppColors.dark, weight: FontWeight.w700)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur unduh gambar segera hadir')),
                        ),
                        child: Text('Unduh gambar',
                            style: AppText.serif(14, color: AppColors.dark, weight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _social(FontAwesomeIcons.whatsapp),
                    _social(FontAwesomeIcons.facebook),
                    _social(FontAwesomeIcons.instagram),
                    _social(FontAwesomeIcons.xTwitter),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}