import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

const kAuthRed = Color(0xFFE0161B);

class AuthField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final String? error;
  final bool errorIcon; // tanda seru merah di kanan
  final bool plainError;
  final Widget? trailing;
  final TextInputType? keyboard;
  final VoidCallback? onChanged;

  const AuthField({
    super.key,
    required this.icon,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.error,
    this.errorIcon = false,
    this.plainError = false,
    this.trailing,
    this.keyboard,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.maroon, width: 1.6),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.maroon),
              const SizedBox(width: 8),
              Text(':', style: AppText.sans(15, color: AppColors.maroon)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboard,
                  onChanged: (_) => onChanged?.call(),
                  cursorColor: AppColors.maroon,
                  style: AppText.sans(
                    14,
                    color: hasError && !obscure ? kAuthRed : AppColors.maroon,
                    weight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hint,
                    hintStyle: AppText.sans(14, color: Colors.black45),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              if (errorIcon)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: kAuthRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.priority_high,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ?trailing,
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!errorIcon && !plainError) ...[
                  const Icon(Icons.error, size: 15, color: kAuthRed),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    error!,
                    style: AppText.sans(12, color: kAuthRed, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AuthButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.maroon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(label, style: AppText.sans(14, weight: FontWeight.w600)),
      ),
    );
  }
}
