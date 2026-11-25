import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

const kRegions = [
  'Lampung Barat',
  'Lampung Selatan',
  'Pesawaran',
  'Lampung Timur',
  'Pringsewu',
  'Lampung Tengah',
  'Mesuji',
  'Lampung Utara',
  'Pesisir Barat',
  'Tulang Bawang',
  'Tanggamus',
  'Way Kanan',
  'Tulang Bawang Barat',
];

const _outfitTypes = ['Outer', 'Blazer', 'Kemeja', 'Dress'];
const _genderOptions = ['Wanita', 'Pria', 'Unisex'];
const _styleOptions = ['Semi-Formal', 'Kasual'];

class OutfitFilter {
  final Set<String> types;
  final Set<String> genders;
  final Set<String> styles;

  const OutfitFilter({
    this.types = const {},
    this.genders = const {},
    this.styles = const {},
  });
}

Future<Set<String>?> showRegionFilterDialog(
  BuildContext context, {
  required Set<String> selected,
}) {
  return showDialog<Set<String>>(
    context: context,
    builder: (_) => _RegionFilterDialog(initial: selected),
  );
}

Future<OutfitFilter?> showOutfitFilterDialog(
  BuildContext context, {
  required OutfitFilter initial,
}) {
  return showDialog<OutfitFilter>(
    context: context,
    builder: (_) => _OutfitFilterDialog(initial: initial),
  );
}

Widget _filterChip(String label, bool active, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.maroon : const Color(0xFF817C7C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppText.serif(14, color: Colors.white, weight: FontWeight.w600),
      ),
    ),
  );
}

Widget _filterActions(BuildContext context, VoidCallback onApply) {
  return Column(
    children: [
      Container(height: 1, color: AppColors.maroon),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppText.serif(
                15,
                color: AppColors.maroon,
                weight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onApply,
            child: Text(
              'Terapkan',
              style: AppText.serif(
                15,
                color: AppColors.maroon,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

class _RegionFilterDialog extends StatefulWidget {
  final Set<String> initial;
  const _RegionFilterDialog({required this.initial});

  @override
  State<_RegionFilterDialog> createState() => _RegionFilterDialogState();
}

class _RegionFilterDialogState extends State<_RegionFilterDialog> {
  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Daerah Motif Tapis',
              style: AppText.serif(
                20,
                color: const Color(0xFF1E1E1E),
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _filterChip(
                      'Semua',
                      _selected.isEmpty,
                      () => setState(_selected.clear),
                    ),
                    for (final region in kRegions)
                      _filterChip(region, _selected.contains(region), () {
                        setState(() {
                          if (!_selected.remove(region)) {
                            _selected.add(region);
                          }
                        });
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _filterActions(context, () => Navigator.pop(context, _selected)),
          ],
        ),
      ),
    );
  }
}

class _OutfitFilterDialog extends StatefulWidget {
  final OutfitFilter initial;
  const _OutfitFilterDialog({required this.initial});

  @override
  State<_OutfitFilterDialog> createState() => _OutfitFilterDialogState();
}

class _OutfitFilterDialogState extends State<_OutfitFilterDialog> {
  late final Set<String> _types = {...widget.initial.types};
  late final Set<String> _selectedGenders = {...widget.initial.genders};
  late final Set<String> _selectedStyles = {...widget.initial.styles};

  Widget _section(String title, List<String> options, Set<String> selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppText.serif(
            14,
            color: const Color(0xFF1E1E1E),
            weight: FontWeight.w700,
          ).copyWith(decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _filterChip(
              'Semua',
              selected.isEmpty,
              () => setState(selected.clear),
            ),
            for (final option in options)
              _filterChip(option, selected.contains(option), () {
                setState(() {
                  if (!selected.remove(option)) selected.add(option);
                });
              }),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Rekomendasi Outfit',
              style: AppText.serif(
                20,
                color: const Color(0xFF1E1E1E),
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            _section('Jenis Pakaian', _outfitTypes, _types),
            const SizedBox(height: 14),
            _section('Gender', _genderOptions, _selectedGenders),
            const SizedBox(height: 14),
            _section('Acara / Style', _styleOptions, _selectedStyles),
            const SizedBox(height: 16),
            _filterActions(
              context,
              () => Navigator.pop(
                context,
                OutfitFilter(
                  types: {..._types},
                  genders: {..._selectedGenders},
                  styles: {..._selectedStyles},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
