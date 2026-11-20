import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

void showNotificationSheet(BuildContext context) {
  const items = [
    ('Motif baru ditambahkan', 'Jelajahi motif tapis terbaru di katalog.'),
    ('Rekomendasi outfit', 'Ada outfit baru yang cocok dengan motifmu.'),
  ];
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.maroonDeep,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifikasi', style: AppText.serif(20)),
            const SizedBox(height: 8),
            for (final n in items)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.notifications_none, color: AppColors.gold),
                title: Text(n.$1, style: AppText.sans(13, weight: FontWeight.w600)),
                subtitle: Text(n.$2, style: AppText.sans(11, color: Colors.white70)),
              ),
          ],
        ),
      ),
    ),
  );
}