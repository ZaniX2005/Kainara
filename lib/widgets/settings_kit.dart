import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/l10n.dart';
import '../data/profile_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

const kBgWarm = Color(0xFFFFFAF3);
const kBgGreen = Color(0xFFF8F9EE);
const kIconBg = Color(0xFFFAF0E4);

/// Kerangka halaman pengaturan dengan header terang dan tombol kembali maroon.
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
            padding: EdgeInsets.fromLTRB(20, mq.padding.top + 10, 20, 10),
            color: background,
            child: Row(
              children: [
                Material(
                  color: AppColors.maroon,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/profil'),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppText.serif(
                      22,
                      color: AppColors.maroon,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
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
  int? maxLength,
}) {
  final c = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: kBgWarm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: AppText.serif(20, color: AppColors.maroon)),
      content: TextField(
        controller: c,
        obscureText: obscure,
        autofocus: true,
        maxLength: maxLength,
        style: AppText.sans(14, color: AppColors.dark),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE9D7BF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE9D7BF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.maroon),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(dialogContext),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.maroon,
            side: const BorderSide(color: AppColors.maroon),
          ),
          child: Text(
            tr('Batal'),
            style: AppText.sans(13, color: AppColors.maroon),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, c.text.trim()),
          style: FilledButton.styleFrom(backgroundColor: AppColors.maroon),
          child: Text(tr('Simpan'), style: AppText.sans(13)),
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
    builder: (dialogContext) => AlertDialog(
      backgroundColor: kBgWarm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: AppText.serif(20, color: AppColors.maroon),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: AppText.sans(13, color: AppColors.dark, height: 1.5),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.maroon,
            side: const BorderSide(color: Color(0xFFBDBDBD)),
            minimumSize: const Size(110, 44),
          ),
          child: Text(
            tr('Batal'),
            style: AppText.sans(12, color: AppColors.maroon),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.maroon,
            minimumSize: const Size(110, 44),
          ),
          child: Text(ok, style: AppText.sans(12)),
        ),
      ],
    ),
  );
  return r ?? false;
}

Future<bool> switchAccountDialog(BuildContext context) async {
  final profile = ProfileStore.instance;
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, _, _) {
      final mq = MediaQuery.of(dialogContext);
      return Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogContext, false),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    10,
                    16,
                    mq.viewPadding.bottom + 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        tr('Ganti Akun'),
                        style: AppText.serif(
                          24,
                          color: AppColors.maroon,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tr('Pilih akun yang ingin Anda gunakan.'),
                        style: AppText.sans(
                          14,
                          color: const Color(0xFF3D3D3D),
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _AccountChoice(
                        name: profile.name,
                        email: profile.email,
                        active: true,
                        onTap: () => Navigator.pop(dialogContext, false),
                      ),
                      const SizedBox(height: 12),
                      _AccountChoice(
                        name: 'Yanto Mulyanto',
                        email: 'Yanto.Mulyanto236@example.com',
                        active: false,
                        onTap: () => Navigator.pop(dialogContext, true),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.maroon,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, size: 20),
                              const SizedBox(width: 8),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    tr('Tambahkan akun lain'),
                                    style: AppText.sans(
                                      16,
                                      color: Colors.white,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          tr('Anda tidak perlu keluar dari akun saat ini.'),
                          textAlign: TextAlign.center,
                          style: AppText.sans(
                            11,
                            color: const Color(0xFF777777),
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final offset = Tween(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);
      return SlideTransition(position: offset, child: child);
    },
  );
  return result ?? false;
}

Future<bool> logoutDialog(BuildContext context) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, _, _) => Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: GestureDetector(
            onTap: () => Navigator.pop(dialogContext, false),
            child: Container(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        Center(
          child: AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 32),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            contentPadding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr('Logout dari akun'),
                  textAlign: TextAlign.center,
                  style: AppText.serif(
                    24,
                    color: AppColors.maroon,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  tr(
                    'Apakah Anda yakin ingin keluar?\nAnda perlu masuk kembali untuk\nmengakses akun Anda.',
                  ),
                  textAlign: TextAlign.center,
                  style: AppText.sans(
                    16,
                    color: const Color(0xFF4A382F),
                    weight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.maroon,
                          side: const BorderSide(color: Color(0xFFBFC1C4)),
                          minimumSize: const Size(0, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          tr('Batal'),
                          style: AppText.serif(
                            14,
                            color: AppColors.maroon,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.maroon,
                          minimumSize: const Size(0, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          tr('Ya, logout'),
                          textAlign: TextAlign.center,
                          style: AppText.serif(
                            14,
                            color: Colors.white,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    transitionBuilder: (context, animation, _, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
  return result ?? false;
}

class _AccountChoice extends StatelessWidget {
  final String name;
  final String email;
  final bool active;
  final VoidCallback? onTap;

  const _AccountChoice({
    required this.name,
    required this.email,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: active ? AppColors.maroon : const Color(0xFFE0E0E0),
              width: active ? 1.5 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14, 14, active ? 66 : 14, 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: AppColors.maroon,
                    child: Text(
                      name.isEmpty ? '?' : name.trim()[0].toUpperCase(),
                      style: AppText.serif(
                        14,
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.serif(
                            14,
                            color: const Color(0xFF2B1A12),
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(
                            12,
                            color: const Color(0xFF4A4A4A),
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!active)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AppColors.maroon,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (active)
          Positioned(
            top: 14,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.maroon,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tr('Aktif'),
                style: AppText.sans(
                  10,
                  color: Colors.white,
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
