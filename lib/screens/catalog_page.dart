import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../data/dummy_data.dart';
import '../models/motif.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/motif_card.dart';
import '../widgets/round_icon_button.dart';
import '../widgets/search_bar_row.dart';

class CatalogPage extends StatefulWidget {
  final String initialQuery;
  const CatalogPage({super.key, this.initialQuery = ''});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  static const _filters = ['Semua', 'Pepadun', 'Pesisir', 'Way Kanan'];
  static const _heights = [220.0, 107.0, 220.0, 105.0, 220.0, 107.0, 220.0, 105.0];

  late final TextEditingController _controller =
      TextEditingController(text: widget.initialQuery);
  int _selected = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Motif> get _results {
    final q = _controller.text.trim().toLowerCase();
    final f = _filters[_selected].toLowerCase();
    return motifs.where((m) {
      final text = '${m.name} ${m.subtitle} ${m.region} ${m.origin}'.toLowerCase();
      final okQuery = q.isEmpty || text.contains(q);
      final okFilter = _selected == 0 || text.contains(f);
      return okQuery && okFilter;
    }).toList();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.maroonDeep,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text('Filter motif', style: AppText.serif(20)),
            for (var i = 0; i < _filters.length; i++)
              ListTile(
                title: Text(_filters[i], style: AppText.sans(14)),
                trailing: i == _selected
                    ? const Icon(Icons.check, color: AppColors.gold)
                    : null,
                onTap: () {
                  setState(() => _selected = i);
                  Navigator.pop(sheetContext);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size.width / 390;
    final featured = motifs.first;
    final results = _results;

    return Scaffold(
      backgroundColor: AppColors.maroon,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        RoundIconButton(
                          icon: Icons.chevron_left,
                          onTap: () =>
                              context.canPop() ? context.pop() : context.go('/'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Motif Tapis Populer saat ini',
                              style: AppText.serif(18)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Stack(
                      children: [
                        MotifCard(
                          motif: featured,
                          height: 185 * s,
                          showHeart: false,
                          titleSize: 26,
                          subtitleSize: 13,
                          onTap: () => context.push('/motif/${featured.id}'),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC9A04A),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                      color: AppColors.maroon, shape: BoxShape.circle),
                                  child: const Icon(Icons.local_fire_department,
                                      size: 12, color: AppColors.gold),
                                ),
                                const SizedBox(width: 5),
                                Text('Populer',
                                    style: AppText.sans(10,
                                        color: AppColors.dark,
                                        weight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SearchBarRow(
                      filterOnMaroon: false,
                      controller: _controller,
                      onChanged: (_) => setState(() {}),
                      onFilterTap: _openFilterSheet,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (var i = 0; i < _filters.length; i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selected = i),
                              child: Container(
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: i == _selected ? AppColors.gold : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(_filters[i],
                                    style: AppText.sans(11,
                                        color: AppColors.dark,
                                        weight: FontWeight.w500)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (results.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text('Motif tidak ditemukan',
                        style: AppText.sans(13, color: Colors.white70)),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childCount: results.length,
                  itemBuilder: (context, i) {
                    final m = results[i];
                    final h = _heights[i % _heights.length] * s;
                    return MotifCard(
                      motif: m,
                      height: h,
                      showBadge: h > 200 * s,
                      onTap: () => context.push('/motif/${m.id}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}