import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/l10n.dart';
import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/asset_img.dart';

class _MotifScan {
  final String name, date, region, image;
  final int accuracy;
  const _MotifScan(
    this.name,
    this.date,
    this.region,
    this.accuracy,
    this.image,
  );
}

class _SkinScan {
  final String name, date, undertone, note, hex;
  final int accuracy;
  const _SkinScan(
    this.name,
    this.date,
    this.undertone,
    this.note,
    this.hex,
    this.accuracy,
  );
  Color get color => Color(int.parse('FF${hex.substring(1)}', radix: 16));
}

const _motifScans = [
  _MotifScan(
    'raja tunggal',
    '21 februari 2027',
    'Lampung',
    90,
    'assets/images/riwayat_1.png',
  ),
  _MotifScan(
    'raja tunggal',
    '21 februari 2027',
    'Lampung',
    89,
    'assets/images/riwayat_2.png',
  ),
  _MotifScan(
    'raja tunggal',
    '21 februari 2027',
    'Lampung',
    80,
    'assets/images/riwayat_3.png',
  ),
  _MotifScan(
    'raja tunggal',
    '21 februari 2027',
    'Lampung',
    93,
    'assets/images/riwayat_4.png',
  ),
];

const _skinScans = [
  _SkinScan(
    'Sawo Matang',
    '21 Februari 2027',
    'Warm Golden',
    'Cocok dengan Tapis Raja',
    '#9E6038',
    95,
  ),
  _SkinScan(
    'Fair',
    '21 Februari 2027',
    'Cool Rosy',
    'Harmonis dengan Tapis Pucuk',
    '#FFE0CE',
    80,
  ),
  _SkinScan(
    'Kuning langsat',
    '21 Februari 2027',
    'Neutral Olive',
    'Sangat serasi Tapis Jung Sarat',
    '#DCA872',
    89,
  ),
  _SkinScan(
    'Hitam manis',
    '21 Februari 2027',
    'Deep Warm Amber',
    'Rekomendasi Tapis Bintang',
    '#56311C',
    95,
  ),
];

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  int _tab = 0; // 0 = Motif, 1 = Skintone
  bool _searching = false;
  final _q = TextEditingController();

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, {bool dot = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            child: Icon(icon, size: 20, color: AppColors.dark),
          ),
          if (dot)
            Positioned(
              top: 8,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFC0392B),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _toggle() {
    Widget seg(int i, String label) {
      final active = _tab == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _tab = i),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.maroon : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: AppText.serif(
                14,
                color: active ? Colors.white : AppColors.dark,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8D8D8)),
      ),
      child: Row(children: [seg(0, tr('Motif')), seg(1, tr('Skintone'))]),
    );
  }

  Widget _accuracy(int v) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F8EF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF9ED9B5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 12, color: Color(0xFF1E8E4F)),
          const SizedBox(width: 4),
          Text(
            '${tr('akurasi')} $v%',
            style: AppText.sans(
              10,
              color: const Color(0xFF1E8E4F),
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailLink(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr('penjelasan'),
            style: AppText.sans(
              12,
              color: AppColors.maroon,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.maroon),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _motifCard(_MotifScan m) {
    return _card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AssetImg(m.image),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xCC000000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tr('Tenun'),
                        style: AppText.sans(8, color: AppColors.goldText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          m.name,
                          style: AppText.sans(
                            15,
                            color: Colors.black,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        m.date,
                        style: AppText.sans(10, color: Colors.black45),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _accuracy(m.accuracy),
                      const SizedBox(width: 8),
                      Text(
                        m.region,
                        style: AppText.sans(10, color: Colors.black45),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _detailLink(
                      () => context.push(
                        '/scan-result/${motifs.first.id}?acc=${m.accuracy}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skinCard(_SkinScan s) {
    return _card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [s.color.withValues(alpha: 0.85), s.color],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x99000000),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        tr('TONE'),
                        style: AppText.sans(8, weight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: s.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white70),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 6,
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x99000000),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s.hex,
                        style: AppText.sans(9, weight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          s.name,
                          style: AppText.sans(
                            15,
                            color: Colors.black,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        s.date,
                        style: AppText.sans(10, color: Colors.black45),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _accuracy(s.accuracy),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          s.undertone,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(10, color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(s.note, style: AppText.sans(11, color: Colors.black54)),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _detailLink(() {}),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final q = _q.text.trim().toLowerCase();
    final motifList = _motifScans
        .where(
          (m) => q.isEmpty || '${m.name} ${m.region}'.toLowerCase().contains(q),
        )
        .toList();
    final skinList = _skinScans
        .where(
          (s) =>
              q.isEmpty || '${s.name} ${s.undertone}'.toLowerCase().contains(q),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(height: mq.padding.top, color: const Color(0xFFF2F2F2)),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 18, 12),
            child: Row(
              children: [
                Expanded(
                  child: _searching
                      ? TextField(
                          controller: _q,
                          autofocus: true,
                          onChanged: (_) => setState(() {}),
                          style: AppText.sans(13, color: AppColors.dark),
                          decoration: InputDecoration(
                            hintText: tr('Cari riwayat...'),
                            hintStyle: AppText.sans(12, color: Colors.black45),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr('Riwayat Scan'),
                              style: AppText.serif(24, color: AppColors.maroon),
                            ),
                            Text(
                              _tab == 0
                                  ? tr('Arsip Identifikasi tapis')
                                  : tr('Arsip Analisis Warna Kulit & Wastra'),
                              style: AppText.sans(11, color: Colors.black54),
                            ),
                          ],
                        ),
                ),
                _iconBtn(_searching ? Icons.close : Icons.search, () {
                  setState(() {
                    _searching = !_searching;
                    if (!_searching) _q.clear();
                  });
                }),
                const SizedBox(width: 10),
                _iconBtn(
                  Icons.notifications_none,
                  () => context.push('/notifikasi'),
                  dot: true,
                ),
              ],
            ),
          ),
          _toggle(),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 120 + mq.padding.bottom),
              children: [
                if (_tab == 0) ...[
                  for (var i = 0; i < motifList.length; i++) ...[
                    _motifCard(motifList[i]),
                    if (i < motifList.length - 1)
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                        color: const Color(0xFFE0E0E0),
                      ),
                  ],
                  if (motifList.isEmpty) _empty(),
                ] else ...[
                  for (final s in skinList) ...[
                    _skinCard(s),
                    const SizedBox(height: 12),
                  ],
                  if (skinList.isEmpty) _empty(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty() => Padding(
    padding: const EdgeInsets.all(32),
    child: Center(
      child: Text(
        tr('Riwayat tidak ditemukan'),
        style: AppText.sans(13, color: Colors.black45),
      ),
    ),
  );
}
