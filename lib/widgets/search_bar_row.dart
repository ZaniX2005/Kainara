import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class SearchBarRow extends StatelessWidget {
  final bool filterOnMaroon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;

  const SearchBarRow({
    super.key,
    this.filterOnMaroon = true,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    const shadow = [
      BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 3)),
    ];
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: shadow,
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              style: AppText.sans(13, color: AppColors.dark),
              decoration: InputDecoration(
                hintText: 'Cari nama motif, asal daerah...',
                hintStyle: AppText.sans(12, color: Colors.black45),
                prefixIcon: const Icon(Icons.search, size: 20, color: Colors.black45),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: filterOnMaroon ? AppColors.maroon : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: shadow,
            ),
            child: Icon(Icons.filter_alt_outlined,
                size: 20, color: filterOnMaroon ? Colors.white : Colors.black45),
          ),
        ),
      ],
    );
  }
}