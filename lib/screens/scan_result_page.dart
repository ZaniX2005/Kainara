import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../data/dummy_data.dart';
import '../data/favorites_store.dart';
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

  static const _grey = Color(0xFFDADADA);

  Widget _topBtn(Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xE6EDEDED),
          shape: BoxShape.circle,
        ),
        child: Center(child: icon),
      ),
    );
  }

  Widget _row(String label, String value, {double minH = 0}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              label,
              style: AppText.serif(15, color: const Color(0xFF1E1E1E)),
            ),
          ),
        ),
        Expanded(
          child: Container(
            constraints: BoxConstraints(minHeight: minH),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: AppText.sans(
                12,
                color: const Color(0xFF2B2B2B),
                height: 1.6,
              ),
            ),
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
          // Foto + tombol atas
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(color: AppColors.maroon, height: mq.padding.top),
              Padding(
                padding: EdgeInsets.only(top: mq.padding.top),
                child: SizedBox(
                  height: 320 * s,
                  width: double.infinity,
                  child: AssetImg(motif.headerImage),
                ),
              ),
              Positioned(
                top: mq.padding.top + 12,
                left: 12,
                child: _topBtn(
                  const Icon(
                    Icons.chevron_left,
                    color: AppColors.maroon,
                    size: 26,
                  ),
                  () => context.canPop() ? context.pop() : context.go('/'),
                ),
              ),
              Positioned(
                top: mq.padding.top + 12,
                right: 12,
                child: ListenableBuilder(
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
                    );
                  },
                ),
              ),
              // Panel krem melengkung
              Positioned(
                left: 0,
                right: 0,
                bottom: -1,
                child: Container(
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.page,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Share + lihat motif lain
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 18, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => SharePlus.instance.share(
                        ShareParams(
                          text: 'Lihat motif tapis ${motif.name} di KAINARA',
                        ),
                      ),
                      child: Container(
                        width: 44,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.share,
                          size: 18,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Share motif',
                      style: AppText.sans(10, color: Colors.black54),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push('/catalog'),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Text(
                          'lihat motif lain',
                          style: AppText.sans(
                            12,
                            color: Colors.black,
                            weight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Nama + akurasi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    motif.name,
                    style: AppText.serif(
                      26,
                      color: Colors.black,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E9E5A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'akurasi ${widget.accuracy}%',
                  style: AppText.sans(
                    14,
                    color: Colors.black,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            color: const Color(0xFFE2E2DA),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _row('Asal Motif Tapis', motif.origin),
                const SizedBox(height: 14),
                _row('Deskripsi Singkat', motif.description, minH: 150),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Rekomendasi outfit
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                GestureDetector(
                  onTap: () => context.push('/outfit-pick'),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.dark,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                          AssetImg(o.image, alignment: Alignment.topCenter),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0x00000000), Color(0xAA000000)],
                                stops: [0.55, 1],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 6,
                            right: 6,
                            bottom: 6,
                            child: Text(
                              o.category.isEmpty ? o.name : o.category,
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
