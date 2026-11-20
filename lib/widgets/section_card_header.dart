import 'package:flutter/material.dart';
import '../theme/app_text.dart';

class SectionCardHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback? onAction;
  final Color color;

  const SectionCardHeader({
    super.key,
    required this.title,
    required this.color,
    this.actionLabel = 'Selengkapnya',
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppText.serif(17))),
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(actionLabel,
                    style: AppText.sans(12, weight: FontWeight.w600)),
                const Icon(Icons.chevron_right, size: 16, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}