import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../data/dummy_data.dart';
import '../data/favorites_store.dart';
import '../models/motif.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/asset_img.dart';

class ScanResultPage extends StatefulWidget {
  final String id;
  final int accuracy;
  const ScanResultPage({super.key, required this.id, this.accuracy = 98});

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  bool _useOpen = false;
  bool _careOpen = false;
  bool _outfitOpen = true;

  static const _grey = Color(0xFFDADADA);

  Widget _topBtn(
    Widget icon,
    VoidCallback onTap, {
    Color background = const Color(0xE6EDEDED),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Center(child: icon),
      ),
    );
  }

  Widget _componentPanel(Motif motif) {
    final components = [
      ('assets/images/outfit/outfit_6.png', 'Siger Lampung', motif.region),
      ('assets/images/outfit/outfit_3.png', 'Kebaya', 'Putih'),
      (motif.image, 'Kain Tapis', motif.name),
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.maroon,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KOMPONEN OUTFIT',
            style: AppText.sans(
              11,
              color: Colors.white,
              weight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < components.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            Expanded(
              child: _componentItem(
                image: components[i].$1,
                title: components[i].$2,
                subtitle: components[i].$3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _componentItem({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 42,
              height: double.infinity,
              child: AssetImg(image, alignment: Alignment.topCenter),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.serif(
                    9,
                    color: AppColors.maroon,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(8, color: AppColors.dark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _clothingInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFC7A33E)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppText.sans(10, color: const Color(0xFF6B625A)),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(
                  15,
                  color: const Color(0xFF292522),
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _accordion(
    String title,
    bool open,
    VoidCallback onTap,
    String content,
  ) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppText.serif(
                      17,
                      color: const Color(0xFF1E1E1E),
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    open ? Icons.keyboard_arrow_down : Icons.chevron_right,
                    size: 20,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1.2,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          color: AppColors.dark,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          alignment: Alignment.topCenter,
          child: open
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      content,
                      style: AppText.sans(
                        11,
                        color: const Color(0xFF3A3A3A),
                        height: 1.5,
                      ),
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  Widget _shareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 27),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppText.sans(
                10,
                color: const Color(0xFF272727),
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openShareSheet(Motif motif) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Share ke',
                    style: AppText.serif(
                      20,
                      color: Colors.black,
                      weight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 8,
                runSpacing: 18,
                children: [
                  _shareOption(
                    icon: Icons.chat,
                    label: 'WhatsApp',
                    color: const Color(0xFF25D366),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(
                        text: 'Lihat motif tapis ${motif.name} di KAINARA',
                      ),
                    ),
                  ),
                  _shareOption(
                    icon: Icons.camera_alt,
                    label: 'Story\nInstagram',
                    color: const Color(0xFFE4405F),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(text: 'Motif tapis ${motif.name}'),
                    ),
                  ),
                  _shareOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Feed\nInstagram',
                    color: const Color(0xFF833AB4),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(text: 'Motif tapis ${motif.name}'),
                    ),
                  ),
                  _shareOption(
                    icon: Icons.send,
                    label: 'Telegram',
                    color: const Color(0xFF37AEE2),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(text: 'Motif tapis ${motif.name}'),
                    ),
                  ),
                  _shareOption(
                    icon: Icons.facebook,
                    label: 'Facebook',
                    color: const Color(0xFF1877F2),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(text: 'Motif tapis ${motif.name}'),
                    ),
                  ),
                  _shareOption(
                    icon: Icons.link,
                    label: 'Salin Link',
                    color: const Color(0xFFE7E7E7),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(text: 'Motif tapis ${motif.name}'),
                    ),
                  ),
                  _shareOption(
                    icon: Icons.download,
                    label: 'Simpan Foto',
                    color: const Color(0xFFE7E7E7),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(text: 'Motif tapis ${motif.name}'),
                    ),
                  ),
                  _shareOption(
                    icon: Icons.more_horiz,
                    label: 'Lainnya',
                    color: const Color(0xFFE7E7E7),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(text: 'Motif tapis ${motif.name}'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final s = mq.size.width / 390;
    final motif = motifs.firstWhere(
      (m) => m.id == widget.id,
      orElse: () => motifs.first,
    );
    final favKey = 'motif:${motif.id}';

    return Scaffold(
      backgroundColor: AppColors.page,
      body: ListView(
        padding: EdgeInsets.only(bottom: 120 + mq.padding.bottom),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, mq.padding.top + 8, 20, 12),
            child: Row(
              children: [
                _topBtn(
                  const Icon(Icons.chevron_left, color: Colors.white, size: 26),
                  () => context.canPop() ? context.pop() : context.go('/'),
                  background: AppColors.maroon,
                ),
                const Spacer(),
                _topBtn(
                  const Icon(Icons.share, color: AppColors.dark, size: 18),
                  () => _openShareSheet(motif),
                ),
                const SizedBox(width: 8),
                ListenableBuilder(
                  listenable: FavoritesStore.instance,
                  builder: (_, _) {
                    final liked = FavoritesStore.instance.isFav(favKey);
                    return _topBtn(
                      Icon(
                        liked ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.maroon,
                        size: 22,
                      ),
                      () => FavoritesStore.instance.toggle(favKey),
                      background: Colors.white,
                    );
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 300 * s,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox.expand(
                        child: AssetImg(
                          motif.headerImage,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14 * s),
                  Expanded(flex: 2, child: _componentPanel(motif)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              motif.name,
              style: AppText.serif(
                24,
                color: Colors.black,
                weight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 12),
            child: Text(
              motif.description,
              style: AppText.sans(
                13,
                color: const Color(0xFF36322E),
                height: 1.35,
              ),
            ),
          ),

          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: AppColors.maroon,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 12),
            child: Text(
              'Informasi Pakaian',
              style: AppText.serif(
                18,
                color: Colors.black,
                weight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 18, 18),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _clothingInfoItem(
                        icon: Icons.map,
                        label: 'Daerah',
                        value: 'Lampung',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _clothingInfoItem(
                        icon: Icons.checkroom,
                        label: 'Adat',
                        value: motif.region,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _clothingInfoItem(
                        icon: Icons.card_giftcard,
                        label: 'Jenis',
                        value: 'Busana Adat',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _clothingInfoItem(
                        icon: Icons.auto_awesome,
                        label: 'Ciri khas',
                        value: '${motif.name} & Tapis',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: AppColors.maroon,
          ),

          // Rekomendasi outfit
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _outfitOpen = !_outfitOpen),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rekomendasi Outfit',
                      style: AppText.serif(
                        17,
                        color: const Color(0xFF1E1E1E),
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _outfitOpen
                          ? Icons.keyboard_arrow_down
                          : Icons.chevron_right,
                      size: 20,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1.2,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: AppColors.dark,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            alignment: Alignment.topCenter,
            child: _outfitOpen
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 124 * s,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: outfits.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (_, i) {
                            final o = outfits[i];
                            return GestureDetector(
                              onTap: () => context.push('/outfit-pick'),
                              child: SizedBox(
                                width: 80 * s,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      AssetImg(
                                        o.image,
                                        alignment: Alignment.topCenter,
                                      ),
                                      const DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0x00000000),
                                              Color(0xAA000000),
                                            ],
                                            stops: [0.55, 1],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 6,
                                        right: 6,
                                        bottom: 6,
                                        child: Text(
                                          o.category.isEmpty
                                              ? o.name
                                              : o.category,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppText.sans(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),

          _accordion(
            'Penggunaan',
            _useOpen,
            () => setState(() => _useOpen = !_useOpen),
            motif.usage,
          ),
          _accordion(
            'Perawatan',
            _careOpen,
            () => setState(() => _careOpen = !_careOpen),
            motif.care.join(' '),
          ),
        ],
      ),
    );
  }
}
