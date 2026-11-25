import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/asset_img.dart';
import '../widgets/heart_button.dart';

class OutfitPickPage extends StatefulWidget {
  const OutfitPickPage({super.key});

  @override
  State<OutfitPickPage> createState() => _OutfitPickPageState();
}

class _OutfitPickPageState extends State<OutfitPickPage> {
  static const _pieces = [
    (
      'REKOMENDASI ATASAN',
      'Baju Tapis Wanita',
      'Berbahan katun tenun',
      'assets/images/outfit/outfit_4.png',
    ),
    (
      'REKOMENDASI BAWAHAN',
      'Celana Kulot Wanita',
      'Slim Straight Cream',
      'assets/images/outfit/outfit_3.png',
    ),
  ];
  static const _acc = [
    ('Selendang', Icons.checkroom),
    ('Arloji Gold', Icons.watch_outlined),
    ('Loafers', Icons.directions_walk_outlined),
    ('Clutch Bag', Icons.work_outline),
  ];
  static const _others = [
    (
      'Koko Kerah Mandarin',
      'Celana Chino Cream + Peci',
      'assets/images/outfit/outfit_6.png',
    ),
    (
      'Tunik Modis Tapis Balak',
      'Kulot Putih + Hijab Maroon',
      'assets/images/outfit/outfit_2.png',
    ),
    (
      'Blazer Lapel Sulam Emas',
      'Celana Formal Ankle Hitam',
      'assets/images/outfit/outfit_4.png',
    ),
    (
      'Vest Etnik Jung Sarat',
      'Kaos Putih Polos + Jeans',
      'assets/images/outfit/outfit_3.png',
    ),
  ];

  Widget _shareOption({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
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
              width: 58,
              height: 58,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 27),
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

  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.page,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4D4D4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _shareOption(
                      icon: Icons.chat,
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      iconColor: Colors.white,
                      onTap: () => SharePlus.instance.share(
                        ShareParams(
                          text: 'Lihat rekomendasi outfit tapis di KAINARA',
                        ),
                      ),
                    ),
                    _shareOption(
                      icon: Icons.camera_alt,
                      label: 'Story\nInstagram',
                      color: const Color(0xFFD62976),
                      iconColor: Colors.white,
                      onTap: () => SharePlus.instance.share(
                        ShareParams(
                          text: 'Lihat rekomendasi outfit tapis di KAINARA',
                        ),
                      ),
                    ),
                    _shareOption(
                      icon: Icons.camera_alt_outlined,
                      label: 'Feed\nInstagram',
                      color: const Color(0xFF833AB4),
                      iconColor: Colors.white,
                      onTap: () => SharePlus.instance.share(
                        ShareParams(
                          text: 'Lihat rekomendasi outfit tapis di KAINARA',
                        ),
                      ),
                    ),
                    _shareOption(
                      icon: Icons.send,
                      label: 'Telegram',
                      color: const Color(0xFF37AEE2),
                      iconColor: Colors.white,
                      onTap: () => SharePlus.instance.share(
                        ShareParams(
                          text: 'Lihat rekomendasi outfit tapis di KAINARA',
                        ),
                      ),
                    ),
                    _shareOption(
                      icon: Icons.facebook,
                      label: 'Facebook',
                      color: const Color(0xFF1877F2),
                      iconColor: Colors.white,
                      onTap: () => SharePlus.instance.share(
                        ShareParams(
                          text: 'Lihat rekomendasi outfit tapis di KAINARA',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _shareOption(
                    icon: Icons.link,
                    label: 'Salin Link',
                    color: Colors.white,
                    iconColor: const Color(0xFF444444),
                    onTap: () async {
                      await Clipboard.setData(
                        const ClipboardData(
                          text: 'Lihat rekomendasi outfit tapis di KAINARA',
                        ),
                      );
                      if (!mounted || !sheetContext.mounted) return;
                      Navigator.pop(sheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Teks berhasil disalin')),
                      );
                    },
                  ),
                  _shareOption(
                    icon: Icons.download,
                    label: 'Simpan Foto',
                    color: Colors.white,
                    iconColor: const Color(0xFF444444),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur simpan foto belum tersedia'),
                        ),
                      );
                    },
                  ),
                  _shareOption(
                    icon: Icons.more_horiz,
                    label: 'Lainnya',
                    color: Colors.white,
                    iconColor: const Color(0xFF444444),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(
                        text: 'Lihat rekomendasi outfit tapis di KAINARA',
                      ),
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

  Widget _pieceRow(int i) {
    final p = _pieces[i];
    return Container(
      height: 184,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFEAE8E2)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 148,
              height: 148,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AssetImg(p.$4),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: HeartButton(favKey: 'outfit:${p.$4}', size: 30),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  p.$1,
                  style: AppText.sans(
                    10,
                    color: AppColors.gold,
                    weight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  p.$2,
                  style: AppText.sans(
                    14,
                    color: const Color(0xFF262626),
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
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
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  'Mix & match',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(
                    14,
                    color: AppColors.dark,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE9E9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE9B7B7)),
                  ),
                  child: Text(
                    'Koleksi Aksesori',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                      9,
                      color: AppColors.maroon,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _showShareSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.share_outlined,
                        size: 14,
                        color: AppColors.dark,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Share',
                        style: AppText.sans(
                          11,
                          color: AppColors.dark,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Rekomendasi match outfit pelengkap gaya',
            style: AppText.sans(10, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final a in _acc)
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F5EF),
                            border: Border.all(color: const Color(0xFFE7E3D9)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(a.$2, color: AppColors.gold, size: 30),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        a.$1,
                        style: AppText.sans(
                          10,
                          color: AppColors.dark,
                          weight: FontWeight.w500,
                        ),
                      ),
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AssetImg(o.$3),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              o.$1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(
                12,
                color: AppColors.dark,
                weight: FontWeight.w700,
              ),
            ),
            Text(
              o.$2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(10, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: AppColors.page,
      body: Column(
        children: [
          Container(height: mq.padding.top, color: AppColors.page),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 28 + mq.padding.bottom),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.canPop() ? context.pop() : context.go('/'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.maroon,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Outfit Utama',
                          style: AppText.serif(
                            22,
                            color: AppColors.maroon,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _pieceRow(0),
                _pieceRow(1),
                _mixMatch(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 30, 18, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rekomendasi outfit lain',
                          style: AppText.sans(
                            15,
                            color: const Color(0xFF252525),
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/outfit'),
                        child: Row(
                          children: [
                            Text(
                              'Semua',
                              style: AppText.sans(
                                12,
                                color: AppColors.maroon,
                                weight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: AppColors.maroon,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                  child: Text(
                    'Inspirasi padu padan motif Tapis kontemporer',
                    style: AppText.sans(11, color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _others.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.70,
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
