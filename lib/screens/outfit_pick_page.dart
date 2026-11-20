import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/asset_img.dart';

class OutfitPickPage extends StatefulWidget {
  const OutfitPickPage({super.key});

  @override
  State<OutfitPickPage> createState() => _OutfitPickPageState();
}

class _OutfitPickPageState extends State<OutfitPickPage> {
  bool _list = true; // true = satu kolom, false = dua kolom

  static const _pieces = [
    ('REKOMENDASI ATASAN', 'Baju Tapis Kemeja', 'Katun Tenun Jung Sarat Gold',
        'assets/images/atasan.png'),
    ('REKOMENDASI BAWAHAN', 'Celana Jeans Biru', 'Slim Straight Denim Indigo',
        'assets/images/bawahan.png'),
  ];
  static const _acc = [
    ('Selendang', 'assets/images/acc_selendang.png'),
    ('Arloji Gold', 'assets/images/acc_arloji.png'),
    ('Loafers', 'assets/images/acc_loafers.png'),
    ('Clutch Bag', 'assets/images/acc_clutch.png'),
  ];
  static const _others = [
    ('Formal', 'Koko Kerah Mandarin', 'Celana Chino Cream + Peci', 'assets/images/lain_1.png', Color(0xFF555555)),
    ('Wanita', 'Tunik Modis Tapis Balak', 'Kulot Putih + Hijab Maroon', 'assets/images/lain_2.png', AppColors.maroon),
    ('Executive', 'Blazer Lapel Sulam Emas', 'Celana Formal Ankle Hitam', 'assets/images/lain_3.png', Color(0xFFB5500F)),
    ('Casual', 'Vest Etnik Jung Sarat', 'Kaos Putih Polos + Jeans', 'assets/images/lain_4.png', Color(0xFF333333)),
  ];

  Widget _layoutToggle() {
    Widget b(IconData icon, bool active, VoidCallback t) => GestureDetector(
          onTap: t,
          child: Container(
            width: 32,
            height: 28,
            decoration: BoxDecoration(
              color: active ? AppColors.maroon : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: active ? Colors.white : Colors.black54),
          ),
        );
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 3, 3, 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDDDDD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Layout', style: AppText.sans(11, color: Colors.black54)),
          const SizedBox(width: 8),
          b(Icons.view_column_outlined, !_list, () => setState(() => _list = false)),
          b(Icons.view_agenda_outlined, _list, () => setState(() => _list = true)),
        ],
      ),
    );
  }

  Widget _pairBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xFF2B2B2B), borderRadius: BorderRadius.circular(6)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.layers_outlined, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text('Pasangan', style: AppText.sans(10, weight: FontWeight.w600)),
        ]),
      );

  Widget _heart() => Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: const Icon(Icons.favorite_border, size: 14, color: Colors.black87),
      );

  Widget _pieceRow(int i) {
    final p = _pieces[i];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 148,
              height: 148,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                      color: const Color(0xFFD9D9D9), child: AssetImg(p.$4)),
                  Positioned(top: 8, left: 8, child: _pairBadge()),
                  Positioned(top: 8, right: 8, child: _heart()),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.$1,
                    style: AppText.sans(10,
                        color: AppColors.gold, weight: FontWeight.w700, letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Text(p.$2,
                    style: AppText.sans(15, color: AppColors.dark, weight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(p.$3, style: AppText.sans(11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mixMatch() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Mix & match',
                  style: AppText.sans(14, color: AppColors.dark, weight: FontWeight.w600)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE9E9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE9B7B7)),
                ),
                child: Text('Koleksi Aksesori',
                    style: AppText.sans(9, color: AppColors.maroon, weight: FontWeight.w600)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push('/share-outfit'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.share_outlined, size: 14, color: AppColors.dark),
                    const SizedBox(width: 6),
                    Text('Share',
                        style: AppText.sans(11, color: AppColors.dark, weight: FontWeight.w600)),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Rekomendasi match outfit pelengkap gaya',
              style: AppText.sans(10, color: Colors.black54)),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final a in _acc)
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                            width: 70, height: 70, child: AssetImg(a.$2)),
                      ),
                      const SizedBox(height: 6),
                      Text(a.$1,
                          style: AppText.sans(10, color: AppColors.dark, weight: FontWeight.w500)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _otherCard(int i) {
    final o = _others[i];
    return GestureDetector(
      onTap: () => context.push('/share-outfit'),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AssetImg(o.$4),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: o.$5, borderRadius: BorderRadius.circular(6)),
                        child: Text(o.$1,
                            style: AppText.sans(9, weight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(o.$2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(12, color: AppColors.dark, weight: FontWeight.w700)),
            Text(o.$3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(10, color: Colors.black45)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(height: mq.padding.top, color: AppColors.maroon),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 110 + mq.padding.bottom),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.canPop() ? context.pop() : context.go('/'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2)),
                            ],
                          ),
                          child: const Icon(Icons.chevron_left, color: AppColors.maroon),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text('Tentukan Outfitmu hari ini',
                            style: AppText.sans(17, color: Colors.black, weight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 24, 8),
                  child: Align(alignment: Alignment.centerRight, child: _layoutToggle()),
                ),
                if (_list) ...[
                  _pieceRow(0),
                  const SizedBox(height: 24),
                  _pieceRow(1),
                ] else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        for (var i = 0; i < 2; i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: SizedBox(
                                    height: 160,
                                    width: double.infinity,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ColoredBox(
                                            color: const Color(0xFFD9D9D9),
                                            child: AssetImg(_pieces[i].$4)),
                                        Positioned(top: 8, left: 8, child: _pairBadge()),
                                        Positioned(top: 8, right: 8, child: _heart()),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(_pieces[i].$1,
                                    style: AppText.sans(9,
                                        color: AppColors.gold, weight: FontWeight.w700)),
                                Text(_pieces[i].$2,
                                    style: AppText.sans(13,
                                        color: AppColors.dark, weight: FontWeight.w700)),
                                Text(_pieces[i].$3,
                                    style: AppText.sans(10, color: Colors.black54)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                _mixMatch(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 4),
                  child: Text('Rekomendasi outfit lain',
                      style: AppText.sans(16, color: Colors.black, weight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text('Inspirasi padu padan motif Tapis kontemporer',
                      style: AppText.sans(11, color: Colors.black87)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _others.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (_, i) => _otherCard(i),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}