import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/asset_img.dart';

enum NotifType { motif, outfit, scan }

enum NotifGroup { today, yesterday, earlier }

class NotifItem {
  const NotifItem({
    required this.id,
    required this.type,
    required this.group,
    required this.time,
    required this.title,
    required this.body,
    required this.action,
    this.unread = false,
    this.thumbAsset,
  });

  final String id;
  final NotifType type;
  final NotifGroup group;
  final String time;
  final String title;
  final String body;
  final String action;
  final bool unread;
  final String? thumbAsset;

  NotifItem copyWith({bool? unread}) => NotifItem(
    id: id,
    type: type,
    group: group,
    time: time,
    title: title,
    body: body,
    action: action,
    unread: unread ?? this.unread,
    thumbAsset: thumbAsset,
  );
}

extension on NotifType {
  String get label => switch (this) {
    NotifType.motif => 'Motif',
    NotifType.outfit => 'Outfit',
    NotifType.scan => 'AI Wastra Lens',
  };

  Color get chipBg => switch (this) {
    NotifType.motif => const Color(0xFFEDE0DC),
    NotifType.outfit => const Color(0xFFFFF4CC),
    NotifType.scan => const Color(0xFFEFEBE7),
  };

  Color get chipFg => switch (this) {
    NotifType.motif => const Color(0xFF4A2A2A),
    NotifType.outfit => const Color(0xFF5C4400),
    NotifType.scan => const Color(0xFF55504A),
  };

  Color thumbColor(bool unread) => !unread
      ? const Color(0xFFF0EBE5)
      : this == NotifType.motif
      ? const Color(0xFF6B0F0F)
      : const Color(0xFFF5E2B9);
}

extension on NotifGroup {
  String get label => switch (this) {
    NotifGroup.today => 'HARI INI',
    NotifGroup.yesterday => 'KEMARIN',
    NotifGroup.earlier => 'SEBELUMNYA',
  };
}

const _demoItems = <NotifItem>[
  NotifItem(
    id: '1',
    type: NotifType.motif,
    group: NotifGroup.today,
    time: '10 menit lalu',
    title: 'Motif Baru: Tapis Raja Tunggal',
    body: 'Arsip tenun benang emas kuno asal Pepadun Abung telah ditambahkan ke ensiklopedia.',
    action: 'Buka detail',
    unread: true,
  ),
  NotifItem(
    id: '2',
    type: NotifType.outfit,
    group: NotifGroup.today,
    time: '1 jam lalu',
    title: 'Inspirasi Gaya: Blazer Velvet & Selendang Cucuk Andak',
    body: 'Paduan semi-formal elegan untuk agenda resepsi & pesta malam.',
    action: 'Lihat outfit',
    unread: true,
  ),
  NotifItem(
    id: '3',
    type: NotifType.scan,
    group: NotifGroup.today,
    time: '3 jam lalu',
    title: 'Hasil Scan Tersimpan: Tapis Jung Sarat Cucuk Mas',
    body: 'Deteksi sulaman emas selesai. Analisis ragam hias & nilai adat sudah siap ditinjau.',
    action: 'Buka detail',
  ),
  NotifItem(
    id: '4',
    type: NotifType.outfit,
    group: NotifGroup.yesterday,
    time: 'Kemarin, 14:20',
    title: 'Padanan Populer: Kebaya Modern & Tapis Balak Saibatin',
    body: 'Banyak disukai untuk acara sakral adat Saibatin. Cek kombinasi warna velvet marun dan emas pada kebaya ini.',
    action: 'Buka detail',
  ),
  NotifItem(
    id: '5',
    type: NotifType.motif,
    group: NotifGroup.earlier,
    time: 'Minggu lalu',
    title: 'Motif Baru: Sasab Emas',
    body: 'Arsip motif Sasab Emas dari Lampung Barat telah ditambahkan ke ensiklopedia.',
    action: 'Buka detail',
  ),
];

enum _Filter { all, motif, outfit }

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, this.items, this.onOpen});

  final List<NotifItem>? items;
  final void Function(NotifItem item)? onOpen;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<NotifItem> _items = List.of(widget.items ?? _demoItems);
  _Filter _filter = _Filter.all;

  bool _matches(NotifItem item) => switch (_filter) {
    _Filter.all => true,
    _Filter.motif => item.type == NotifType.motif,
    _Filter.outfit => item.type == NotifType.outfit,
  };

  int _count(_Filter filter) => switch (filter) {
    _Filter.all => _items.length,
    _Filter.motif => _items.where((i) => i.type == NotifType.motif).length,
    _Filter.outfit => _items.where((i) => i.type == NotifType.outfit).length,
  };

  bool get _hasUnread => _items.any((item) => item.unread);

  void _markAllRead() {
    setState(
      () => _items = [for (final item in _items) item.copyWith(unread: false)],
    );
  }

  void _open(NotifItem item) {
    setState(() {
      _items = [
        for (final current in _items)
          current.id == item.id ? current.copyWith(unread: false) : current,
      ];
    });
    if (widget.onOpen != null) {
      widget.onOpen!(item);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Membuka: ${item.title}')));
    }
  }

  void _back() => context.canPop() ? context.pop() : context.go('/');

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final group in NotifGroup.values) {
      final items = _items
          .where((item) => item.group == group && _matches(item))
          .toList();
      if (items.isEmpty) continue;
      children.add(
        _SectionHeader(
          group: group,
          count: items.length,
          newCount: items.where((item) => item.unread).length,
        ),
      );
      for (final item in items) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _NotifCard(item: item, onTap: () => _open(item)),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 15, 0),
                  child: Row(
                    children: [
                      _BackButton(onTap: _back),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daftar Notifikasi',
                              style: GoogleFonts.ebGaramond(
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                color: AppColors.maroon,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Update motif tapis, serta gaya & aktivitas',
                              style: AppText.sans(
                                12,
                                color: const Color(0xFF6B6560),
                              ).copyWith(height: 1.3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _hasUnread ? _markAllRead : null,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: _hasUnread ? 1 : 0.5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEDDD6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'Tandai dibaca',
                              style: AppText.sans(
                                11,
                                color: AppColors.maroon,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 32, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _FilterChip(
                        label: 'Semua',
                        count: _count(_Filter.all),
                        selected: _filter == _Filter.all,
                        onTap: () => setState(() => _filter = _Filter.all),
                      ),
                      _FilterChip(
                        label: 'Motif',
                        count: _count(_Filter.motif),
                        selected: _filter == _Filter.motif,
                        onTap: () => setState(() => _filter = _Filter.motif),
                      ),
                      _FilterChip(
                        label: 'Outfit',
                        count: _count(_Filter.outfit),
                        selected: _filter == _Filter.outfit,
                        onTap: () => setState(() => _filter = _Filter.outfit),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: children.isEmpty
                      ? Center(
                          child: Text(
                            'Belum ada notifikasi',
                            style: AppText.sans(
                              13,
                              color: const Color(0xFF8E8E8E),
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          children: children,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE8C766), width: 1.2),
      ),
      child: const Icon(Icons.chevron_left, color: AppColors.maroon, size: 26),
    ),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.maroon : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.maroon : const Color(0xFFDAD3CB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppText.sans(
              13,
              color: selected ? Colors.white : const Color(0xFF222222),
              weight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              constraints: const BoxConstraints(minWidth: 18),
              height: 18,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.25)
                    : const Color(0xFFEFEAE4),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                '$count',
                style: AppText.sans(
                  10.5,
                  color: selected ? Colors.white : const Color(0xFF55504A),
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.group,
    required this.count,
    required this.newCount,
  });

  final NotifGroup group;
  final int count;
  final int newCount;

  @override
  Widget build(BuildContext context) {
    final showNew = group == NotifGroup.today && newCount > 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            group.label,
            style: AppText.sans(
              11,
              color: const Color(0xFF4B4540),
              weight: FontWeight.w700,
            ).copyWith(letterSpacing: 0.8),
          ),
          if (showNew)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFCE5C4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$newCount Baru',
                style: AppText.sans(
                  11,
                  color: const Color(0xFFB45309),
                  weight: FontWeight.w700,
                ),
              ),
            )
          else
            Text(
              '$count notifikasi',
              style: AppText.sans(12, color: const Color(0xFF7A746E)),
            ),
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.item, required this.onTap});
  final NotifItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.unread ? const Color(0xFFFDE3DC) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: item.unread
              ? const Color(0xFFF3C6BC)
              : const Color(0xFFE8E1D8),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: _Thumb(item: item),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: item.type.chipBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.type.label,
                                style: AppText.sans(
                                  11,
                                  color: item.type.chipFg,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                item.time,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.sans(
                                  12,
                                  color: const Color(0xFFA09A94),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.ebGaramond(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(
                            13,
                            color: const Color(0xFF4A4A4A),
                          ).copyWith(height: 1.45),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.action,
                style: AppText.sans(
                  12,
                  color: AppColors.maroon,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.item});
  final NotifItem item;

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: item.type.thumbColor(item.unread),
      borderRadius: BorderRadius.circular(12),
    ),
    clipBehavior: Clip.antiAlias,
    child: item.thumbAsset == null
        ? null
        : AssetImg(item.thumbAsset!, fit: BoxFit.cover),
  );
}
