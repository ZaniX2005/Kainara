import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

const kBgWarm = Color(0xFFFFFAF3);
const kBgGreen = Color(0xFFF8F9EE);
const kIconBg = Color(0xFFFAF0E4);

/// Kerangka halaman: header maroon melengkung + tombol kembali.
class SettingsScaffold extends StatelessWidget {
  final String title;
  final Color background;
  final Widget? trailing;
  final Widget body;
  final Widget? bottom;

  const SettingsScaffold({
    super.key,
    required this.title,
    required this.body,
    this.background = kBgWarm,
    this.trailing,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(18, mq.padding.top + 12, 18, 16),
            decoration: const BoxDecoration(
              color: AppColors.maroon,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/profil'),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7EEE9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: AppColors.maroon,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: AppText.serif(22))),
                ?trailing,
              ],
            ),
          ),
          Expanded(child: body),
          ?bottom,
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final Color color;
  const SettingsCard({
    super.key,
    required this.children,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: const Color(0xFFF0EDE8),
          ),
        );
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1E4DA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(children: items),
      ),
    );
  }
}

class IconBubble extends StatelessWidget {
  final IconData icon;
  final bool danger;
  final double size;
  final Color? bg;
  final Color? fg;
  const IconBubble(
    this.icon, {
    super.key,
    this.danger = false,
    this.size = 38,
    this.bg,
    this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg ?? (danger ? const Color(0xFFFDE4E6) : kIconBg),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: fg ?? (danger ? const Color(0xFFC0182B) : AppColors.goldDeep),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;
  final bool chevron;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
    this.chevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: danger ? const Color(0xFFFFF3F3) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              IconBubble(icon, danger: danger),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.sans(
                        14,
                        color: danger
                            ? const Color(0xFFC0182B)
                            : const Color(0xFF1E1E1E),
                        weight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppText.sans(
                          11,
                          color: Colors.black45,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (chevron)
                Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: danger ? const Color(0xFFC0182B) : Colors.black38,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class KSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const KSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? AppColors.maroon
            : const Color(0xFFBDBDBD),
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? AppColors.page
            : AppColors.maroon,
      ),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const SectionLabel(
    this.text, {
    super.key,
    this.color = const Color(0xFF7A736B),
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
    child: Text(
      text.toUpperCase(),
      style: AppText.sans(
        11,
        color: color,
        weight: FontWeight.w700,
        letterSpacing: 0.4,
      ),
    ),
  );
}

/// Dialog isian teks. Mengembalikan teks, atau null jika dibatalkan.
Future<String?> promptText(
  BuildContext context, {
  required String title,
  String initial = '',
  String hint = '',
  bool obscure = false,
}) {
  final c = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title, style: AppText.serif(20, color: AppColors.maroon)),
      content: TextField(
        controller: c,
        obscureText: obscure,
        autofocus: true,
        style: AppText.sans(14, color: AppColors.dark),
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Batal',
            style: AppText.serif(16, color: AppColors.maroon),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, c.text.trim()),
          child: Text(
            'Simpan',
            style: AppText.serif(
              16,
              color: AppColors.maroon,
              weight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String ok = 'Ya',
}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title, style: AppText.serif(20, color: AppColors.maroon)),
      content: Text(
        message,
        style: AppText.sans(13, color: AppColors.dark, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Batal',
            style: AppText.serif(16, color: AppColors.maroon),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            ok,
            style: AppText.serif(
              16,
              color: AppColors.maroon,
              weight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
  return r ?? false;
}
