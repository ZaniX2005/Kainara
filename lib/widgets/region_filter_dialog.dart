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

/// Mengembalikan set daerah terpilih (kosong = "Semua"),
/// atau null jika dibatalkan.
Future<Set<String>?> showRegionFilterDialog(
  BuildContext context, {
  required Set<String> selected,
}) {
  return showDialog<Set<String>>(
    context: context,
    builder: (_) => _RegionFilterDialog(initial: selected),
  );
}

class _RegionFilterDialog extends StatefulWidget {
  final Set<String> initial;
  const _RegionFilterDialog({required this.initial});

  @override
  State<_RegionFilterDialog> createState() => _RegionFilterDialogState();
}

class _RegionFilterDialogState extends State<_RegionFilterDialog> {
  late final Set<String> _sel = {...widget.initial};

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.maroon : const Color(0xFF7D7878),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: AppText.serif(15, weight: FontWeight.w600)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Daerah Motif Tapis',
                style: AppText.serif(20, color: const Color(0xFF1E1E1E))),
            const SizedBox(height: 14),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _chip('Semua', _sel.isEmpty, () => setState(_sel.clear)),
                    for (final r in kRegions)
                      _chip(r, _sel.contains(r), () {
                        setState(() {
                          if (!_sel.remove(r)) _sel.add(r);
                        });
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(height: 1, color: AppColors.maroon),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Batal',
                      style: AppText.serif(16,
                          color: AppColors.maroon, weight: FontWeight.w700)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, _sel),
                  child: Text('Terapkan',
                      style: AppText.serif(16,
                          color: AppColors.maroon, weight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}