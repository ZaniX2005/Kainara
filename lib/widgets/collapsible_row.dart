import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class CollapsibleRow extends StatefulWidget {
  final String title;
  final Widget child;
  const CollapsibleRow({super.key, required this.title, required this.child});

  @override
  State<CollapsibleRow> createState() => _CollapsibleRowState();
}

class _CollapsibleRowState extends State<CollapsibleRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: Text(widget.title,
                        style: AppText.serif(16, color: AppColors.dark))),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _open ? Icons.keyboard_arrow_down : Icons.chevron_right,
                    size: 20,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          alignment: Alignment.topCenter,
          child: _open
              ? Container(
                  width: double.infinity,
                  color: const Color(0xFFF0F0F0),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: widget.child,
                )
              : const SizedBox(width: double.infinity),
        ),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: AppColors.dark,
        ),
      ],
    );
  }
}