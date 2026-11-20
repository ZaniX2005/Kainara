import 'package:flutter/material.dart';
import '../data/favorites_store.dart';
import '../theme/app_colors.dart';

class HeartButton extends StatelessWidget {
  final String favKey;
  final double size;
  const HeartButton({super.key, required this.favKey, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoritesStore.instance,
      builder: (_, _) {
        final liked = FavoritesStore.instance.isFav(favKey);
        return GestureDetector(
          onTap: () => FavoritesStore.instance.toggle(favKey),
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
                color: Color(0xE6F2F2F2), shape: BoxShape.circle),
            child: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              size: size * 0.52,
              color: liked ? AppColors.maroon : const Color(0xFF4A4A4A),
            ),
          ),
        );
      },
    );
  }
}