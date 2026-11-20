import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/outfit_card.dart';
import '../widgets/round_icon_button.dart';

class OutfitPage extends StatelessWidget {
  const OutfitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.maroon,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  RoundIconButton(
                    icon: Icons.chevron_left,
                    onTap: () => context.canPop() ? context.pop() : context.go('/'),
                  ),
                  const SizedBox(width: 12),
                  Text('Rekomendasi Outfit', style: AppText.serif(18)),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: outfits.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (_, i) => OutfitCard(outfit: outfits[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}