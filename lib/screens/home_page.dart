import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/l10n.dart';
import '../widgets/region_filter_dialog.dart';
import '../data/dummy_data.dart';
import '../models/motif.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/item_card.dart';
import '../widgets/slanted_tabs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Banner dipotong dari referensi Home.png (region y=100, height=353 at 1x schala):
  // - Area merah header: y=0..85
  // - Area textur tapis: y=85..453 (368 px)
  // - Teks "Warna yang Pas..." di posisi y≈216*s
  // - Search bar di topInset + 73*s (expand) → +15 (collapse)
  static const _banners = [
    'assets/images/banner.png',
    'assets/images/banner.png',
    'assets/images/banner.png',
  ];

  // Banner dipotong dari referensi Home.png:
  // - Header merah: y=0..120 (47 dp status bar diambil sebagai 73 dp visible)
  // - Gambar banner mulai: y=85, berakhir: y=426
  // - Tab miring: y=428..458 (tinggi 30)
  // - Chip: y=489..517
  // - Kartu mulai: y=541
  // - Teks "Warna yang Pas..." di banner: y≈216*s (di bawah baris header)
  // - Search bar: topInset + 73*s (expand) → +15 (collapse)
  static const _overlayText = false;
  static const _loopStart = 3000;

  // Geometri dari frame Figma 390 px (status bar desain 47 px):
  // header maroon 0..120, gambar banner mulai 85, hero berakhir 426,
  // tab miring 428..458, chip 489..517, kartu mulai 541.
  static const _headerH = 73.0; // 120 - 47
  static const _heroBodyH = 381.0; // 428 - 47
  static const _bannerTop = 38.0; // 85 - 47
  static const _tabsH = 36.0;
  static const _bannerTabsGap = 10.0;

  final _search = TextEditingController();
  late final PageController _pc = PageController(initialPage: _loopStart);
  Timer? _timer;
  final Set<String> _motifSel = {};
  final Set<String> _outfitSel = {};
  final Set<String> _outfitGenderSel = {};
  final Set<String> _outfitStyleSel = {};
  int _tab = 1; // 0 = Rekomendasi Outfit, 1 = Motif Tapis
  int _raw = _loopStart;
  int _page = 0;

  List<String> get _chips => _tab == 1
      ? ['Semua', 'Menggala', 'Way Kanan']
      : ['Semua', 'Outer', 'Blazer'];
  Set<String> get _sel => _tab == 1 ? _motifSel : _outfitSel;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pc.hasClients) return;
      _pc.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _search.dispose();
    _pc.dispose();
    super.dispose();
  }

  void _toggle(String label) {
    setState(() {
      final sel = _sel;
      if (label == 'Semua') {
        sel.clear();
        if (_tab == 0) {
          _outfitGenderSel.clear();
          _outfitStyleSel.clear();
        }
      } else if (!sel.remove(label)) {
        sel.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final s = mq.size.width / 390;
    final topInset = mq.padding.top < 47 ? 47.0 : mq.padding.top;
    final toolbarH = topInset + _headerH; // 120 pada inset 47
    final heroH = topInset + _heroBodyH; // 428: hero tanpa tab
    const tabsH = _tabsH;
    final totalH = heroH + tabsH; // 458: tinggi app bar saat mengembang

    return Scaffold(
      backgroundColor: AppColors.page,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            pinned: true,
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: toolbarH,
            collapsedHeight: toolbarH,
            expandedHeight: totalH,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(tabsH),
              child: SlantedTabs(
                selected: _tab,
                onChanged: (i) => setState(() => _tab = i),
                height: tabsH,
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, c) {
                final t =
                    ((totalH - c.maxHeight) / (totalH - (toolbarH + tabsH)))
                        .clamp(0.0, 1.0);
                return _hero(t, s, topInset, totalH, tabsH);
              },
            ),
          ),
          SliverToBoxAdapter(child: _chipRow()),
          _tab == 1 ? _motifGrid(s) : _outfitGrid(s),
          SliverToBoxAdapter(child: SizedBox(height: 120 + mq.padding.bottom)),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ HERO

  Widget _hero(
    double t,
    double s,
    double topInset,
    double totalH,
    double tabsH,
  ) {
    final fadeOut = (1 - t * 3).clamp(0.0, 1.0);
    final searchTop = (topInset + 73) + ((topInset + 15) - (topInset + 73)) * t;
    final fadeEnd = topInset + 135;
    final fadeStop = ((topInset + _headerH) / fadeEnd).clamp(0.0, 1.0);

    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: totalH - tabsH - _bannerTabsGap,
            child: ColoredBox(
              color: AppColors.page,
              child: ClipRect(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: PageView.builder(
                    controller: _pc,
                    onPageChanged: (i) => setState(() {
                      _raw = i;
                      _page = _raw % _banners.length;
                    }),
                    itemBuilder: (_, i) => OverflowBox(
                      alignment: Alignment.topCenter,
                      minHeight: 0,
                      maxHeight: double.infinity,
                      child: Transform.translate(
                        offset: Offset(0, topInset + _bannerTop),
                        child: Image.asset(
                          _banners[i % _banners.length],
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, _, _) => Container(
                            height: totalH,
                            color: AppColors.brownFallback,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: fadeEnd,
            child: IgnorePointer(
              child: Opacity(
                opacity: 1 - t,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.maroon,
                        AppColors.maroon,
                        AppColors.maroon.withValues(alpha: 0),
                      ],
                      stops: [0, fadeStop, 1],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: (t * 1.5).clamp(0.0, 1.0),
                child: const ColoredBox(color: AppColors.maroon),
              ),
            ),
          ),
          if (_overlayText)
            Positioned(
              left: 27,
              top: 216 * s,
              child: IgnorePointer(
                child: Opacity(
                  opacity: fadeOut,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('Warna yang Pas\nuntuk Gayamu'),
                        style: AppText.serif(
                          28,
                          color: const Color(0xFF1E1E1E),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr('Temukan Tapis yang sesuai\ndengan warna kulit-mu'),
                        style: AppText.sans(
                          12,
                          color: AppColors.maroon,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            left: 22,
            bottom: 61,
            child: Opacity(
              opacity: fadeOut,
              child: Row(
                children: List.generate(
                  _banners.length,
                  (i) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _pc.animateToPage(
                      _raw - (_page - i),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: SizedBox(
                      width: 24,
                      height: 32,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _page
                                ? const Color(0xFF222222)
                                : const Color(0xFF9A9A9A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 16,
            top: topInset,
            child: IgnorePointer(
              ignoring: t > 0.3,
              child: Opacity(
                opacity: fadeOut,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/profil'),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.gold, width: 2.5),
                          color: const Color(0xFF9E9E9E),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tr('Tabik pun!'), style: AppText.serif(24)),
                          Text(
                            tr('Selamat datang di KAINARA'),
                            style: AppText.serif(12, weight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    _bell(38),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 20,
            top: searchTop,
            height: 40,
            child: Row(
              children: [
                Expanded(child: _searchBox()),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      IgnorePointer(
                        ignoring: t > 0.5,
                        child: Opacity(opacity: 1 - t, child: _filterSquare()),
                      ),
                      IgnorePointer(
                        ignoring: t <= 0.5,
                        child: Opacity(opacity: t, child: _bell(40)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _search,
        onChanged: (_) => setState(() {}),
        textInputAction: TextInputAction.search,
        style: AppText.sans(13, color: AppColors.dark),
        decoration: InputDecoration(
          isDense: true,
          hintText: tr('Cari nama motif, asal daerah...'),
          hintStyle: AppText.sans(12, color: Colors.black45),
          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.black45),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 42,
            minHeight: 40,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }

  Widget _filterSquare() {
    return GestureDetector(
      onTap: _openFilterSheet,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.filter_alt_outlined,
          size: 20,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget _bell(double size) {
    return GestureDetector(
      onTap: () => context.push('/notifikasi'),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: size * 0.55,
              color: AppColors.maroon,
            ),
          ),
          Positioned(
            top: 3,
            right: -2,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: AppColors.maroon,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ CHIP ROW

  Widget _chipRow() {
    final sel = _sel;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      child: Row(
        children: [
          for (final label in _chips) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => _toggle(label),
                child: Container(
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        (label == 'Semua' ? sel.isEmpty : sel.contains(label))
                        ? AppColors.maroon
                        : AppColors.chipGrey,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    tr(label),
                    style: AppText.serif(15, weight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: _openFilterSheet,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: AppColors.maroon,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.filter_alt_outlined,
                size: 17,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ GRID

  SliverGridDelegate _delegate(double s) =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 12,
        mainAxisExtent: 258 * s,
      );

  Widget _empty(String text) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text(tr(text), style: AppText.sans(13, color: AppColors.maroon)),
      ),
    ),
  );

  Widget _motifGrid(double s) {
    final list = _filteredMotifs;
    if (list.isEmpty) return _empty('Motif tidak ditemukan');
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: _delegate(s),
        delegate: SliverChildBuilderDelegate((context, i) {
          final m = list[i];
          return ItemCard(
            image: m.image,
            title: m.name,
            description: m.summary.isNotEmpty ? m.summary : m.description,
            favKey: 'motif:${m.id}',
            imageHeight: 190 * s,
            onTap: () => context.push('/motif/${m.id}'),
          );
        }, childCount: list.length),
      ),
    );
  }

  Widget _outfitGrid(double s) {
    final list = _filteredOutfits;
    if (list.isEmpty) return _empty('Outfit tidak ditemukan');
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: _delegate(s),
        delegate: SliverChildBuilderDelegate((context, i) {
          final o = list[i];
          return ItemCard(
            image: o.image,
            title: o.name == 'Nama Outfit' ? o.category : o.name,
            description: o.description,
            favKey: 'outfit:${o.image}',
            imageHeight: 190 * s,
            montserrat: true,
            onTap: () => context.push('/outfit-pick'),
          );
        }, childCount: list.length),
      ),
    );
  }

  // ------------------------------------------------------------ FILTERED MOTIFS

  List<Motif> get _filteredMotifs {
    final q = _search.text.trim().toLowerCase();
    return motifs.where((m) {
      final text = '${m.name} ${m.region} ${m.summary}'.toLowerCase();
      final okQ = q.isEmpty || text.contains(q);
      final okF = _motifSel.isEmpty || _motifSel.contains(m.region);
      return okQ && okF;
    }).toList();
  }

  List<Outfit> get _filteredOutfits {
    final q = _search.text.trim().toLowerCase();
    return outfits.where((o) {
      final text = '${o.name} ${o.category} ${o.description}'.toLowerCase();
      final okQ = q.isEmpty || text.contains(q);
      final okType = _outfitSel.isEmpty || _outfitSel.contains(o.category);
      final okGender =
          _outfitGenderSel.isEmpty || _outfitGenderSel.contains(o.gender);
      final okStyle =
          _outfitStyleSel.isEmpty || _outfitStyleSel.contains(o.style);
      return okQ && okType && okGender && okStyle;
    }).toList();
  }

  // ------------------------------------------------------------ FILTER SHEET

  Future<void> _openFilterSheet() async {
    if (_tab == 1) {
      final result = await showRegionFilterDialog(context, selected: _motifSel);
      if (result == null) return;
      setState(() {
        _motifSel
          ..clear()
          ..addAll(result);
      });
      return;
    }

    final result = await showOutfitFilterDialog(
      context,
      initial: OutfitFilter(
        types: _outfitSel,
        genders: _outfitGenderSel,
        styles: _outfitStyleSel,
      ),
    );
    if (result == null) return;
    setState(() {
      _outfitSel
        ..clear()
        ..addAll(result.types);
      _outfitGenderSel
        ..clear()
        ..addAll(result.genders);
      _outfitStyleSel
        ..clear()
        ..addAll(result.styles);
    });
  }
}
