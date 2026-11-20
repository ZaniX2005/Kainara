import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/l10n.dart';
import '../data/dummy_data.dart';
import '../data/favorites_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/item_card.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  int _tab = 0; // 0 = Motif, 1 = Outfit
  String _chip = 'Semua';
  bool _select = false;
  final Set<String> _picked = {};

  void _setTab(int i) => setState(() {
    _tab = i;
    _chip = 'Semua';
    _select = false;
    _picked.clear();
  });

  void _toggleSelect() => setState(() {
    _select = !_select;
    _picked.clear();
  });

  void _tapItem(String key, VoidCallback open) {
    if (_select) {
      setState(
        () => _picked.contains(key) ? _picked.remove(key) : _picked.add(key),
      );
    } else {
      open();
    }
  }

  void _deletePicked() {
    for (final k in _picked.toList()) {
      FavoritesStore.instance.toggle(k);
    }
    setState(() {
      _picked.clear();
      _select = false;
    });
  }

  Widget _toggle() {
    Widget seg(int i, String label) {
      final active = _tab == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => _setTab(i),
          child: Container(
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.maroon : Colors.transparent,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Text(
              tr(label),
              style: AppText.serif(
                14,
                color: active ? Colors.white : const Color(0xFF6B625B),
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEAE3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0DCD3)),
      ),
      child: Row(children: [seg(0, 'Motif'), seg(1, 'Outfit')]),
    );
  }

  Widget _chips(List<String> labels) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = labels[i] == _chip || (i == 0 && _chip == 'Semua');
          return GestureDetector(
            onTap: () => setState(() => _chip = i == 0 ? 'Semua' : labels[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.maroon : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? AppColors.maroon : const Color(0xFFDDDDDD),
                ),
              ),
              child: Text(
                tr(labels[i]),
                style: active
                    ? AppText.serif(13, weight: FontWeight.w700)
                    : AppText.sans(11, color: AppColors.dark),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _selectable(String key, Widget card) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(ignoring: _select, child: card),
        ),
        if (_select)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _tapItem(key, () {}),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _picked.contains(key)
                        ? AppColors.maroon
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  color: _picked.contains(key)
                      ? const Color(0x226B0D0D)
                      : Colors.transparent,
                ),
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(10),
                child: Icon(
                  _picked.contains(key)
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: _picked.contains(key)
                      ? AppColors.maroon
                      : Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final s = mq.size.width / 390;

    return Scaffold(
      backgroundColor: AppColors.page,
      body: ListenableBuilder(
        listenable: FavoritesStore.instance,
        builder: (context, _) {
          final fav = FavoritesStore.instance;
          final allMotifs = motifs
              .where((m) => fav.isFav('motif:${m.id}'))
              .toList();
          final allOutfits = outfits
              .where((o) => fav.isFav('outfit:${o.image}'))
              .toList();

          final labels = _tab == 0
              ? [
                  '${tr('Semua')} (${allMotifs.length})',
                  ...{for (final m in allMotifs) m.region},
                ]
              : [
                  tr('Semua Busana'),
                  ...{
                    for (final o in allOutfits)
                      if (o.category.isNotEmpty) o.category,
                  },
                ];

          final motifList = allMotifs
              .where((m) => _chip == 'Semua' || m.region == _chip)
              .toList();
          final outfitList = allOutfits
              .where((o) => _chip == 'Semua' || o.category == _chip)
              .toList();
          final count = _tab == 0 ? motifList.length : outfitList.length;

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.padding.top + 28),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr('Favorit'),
                                style: AppText.serif(
                                  32,
                                  color: const Color(0xFF1E1E1E),
                                  weight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _tab == 0
                                    ? tr('Temukan motif favorit anda')
                                    : tr('Temukan outfit favorit anda'),
                                style: AppText.sans(
                                  13,
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleSelect,
                          child: Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFDDDDDD),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tr(_select ? 'Selesai' : 'Pilih'),
                                  style: AppText.sans(
                                    12,
                                    color: AppColors.dark,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.checklist,
                                  size: 16,
                                  color: AppColors.dark,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _toggle(),
                  const SizedBox(height: 14),
                  _chips(labels),
                  const SizedBox(height: 14),
                  Expanded(
                    child: count == 0
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                tr(
                                  'Belum ada favorit.\nTekan ikon hati pada motif atau outfit.',
                                ),
                                textAlign: TextAlign.center,
                                style: AppText.sans(
                                  13,
                                  color: Colors.black45,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.fromLTRB(
                              16,
                              0,
                              16,
                              130 + mq.padding.bottom,
                            ),
                            itemCount: count,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 14,
                                  mainAxisExtent: _tab == 0
                                      ? 170 * s + 108
                                      : 220 * s + 64,
                                ),
                            itemBuilder: (context, i) {
                              if (_tab == 0) {
                                final m = motifList[i];
                                final key = 'motif:${m.id}';
                                return _selectable(
                                  key,
                                  ItemCard(
                                    image: m.image,
                                    title: m.name,
                                    description: m.summary.isNotEmpty
                                        ? m.summary
                                        : m.description,
                                    favKey: key,
                                    imageHeight: 170 * s,
                                    onTap: () => context.push('/motif/${m.id}'),
                                  ),
                                );
                              }
                              final o = outfitList[i];
                              final key = 'outfit:${o.image}';
                              return _selectable(
                                key,
                                ItemCard(
                                  image: o.image,
                                  title: o.name,
                                  description: '',
                                  favKey: key,
                                  imageHeight: 220 * s,
                                  montserrat: false,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              if (_select && _picked.isNotEmpty)
                Positioned(
                  left: 40,
                  right: 40,
                  bottom: 110 + mq.padding.bottom,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.maroon,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: _deletePicked,
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    label: Text(
                      '${tr('Hapus')} (${_picked.length})',
                      style: AppText.sans(13, weight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
