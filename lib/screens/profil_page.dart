import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/l10n.dart';
import '../data/profile_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/settings_kit.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Widget _field(
    IconData icon,
    Widget content,
    Widget trailing, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3DFC4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kIconBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF0DCC0)),
              ),
              child: Icon(icon, size: 19, color: AppColors.maroon),
            ),
            const SizedBox(width: 14),
            Expanded(child: content),
            trailing,
          ],
        ),
      ),
    );
  }

  static const _genders = ['Perempuan', 'Laki-laki', 'Lainnya'];

  static IconData _genderIcon(String g) => switch (g) {
    'Laki-laki' => Icons.male,
    'Lainnya' => Icons.transgender,
    _ => Icons.female,
  };

  static Color _genderColor(String g) => switch (g) {
    'Laki-laki' => const Color(0xFF1E6FD9),
    'Lainnya' => const Color(0xFF7B4FD1),
    _ => const Color(0xFFD81B60),
  };

  static Color _genderBg(String g) => switch (g) {
    'Laki-laki' => const Color(0xFFE3EEFC),
    'Lainnya' => const Color(0xFFEDE5FA),
    _ => const Color(0xFFFCE4EC),
  };

  Future<void> _pickGender(BuildContext context) async {
    final p = ProfileStore.instance;
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              tr('Pilih jenis kelamin'),
              style: AppText.serif(20, color: AppColors.maroon),
            ),
            const SizedBox(height: 8),
            for (final g in _genders)
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _genderBg(g),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_genderIcon(g), size: 20, color: _genderColor(g)),
                ),
                title: Text(
                  tr(g),
                  style: AppText.sans(14, color: AppColors.dark),
                ),
                trailing: p.gender == g
                    ? const Icon(Icons.check, color: AppColors.maroon)
                    : null,
                onTap: () => Navigator.pop(sheet, g),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (result != null) p.update(gender: result);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: kBgWarm,
      body: ListenableBuilder(
        listenable: ProfileStore.instance,
        builder: (context, _) {
          final p = ProfileStore.instance;
          return ListView(
            padding: EdgeInsets.only(bottom: 120 + mq.padding.bottom),
            children: [
              // Header maroon melengkung + avatar
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(0, mq.padding.top + 40, 0, 56),
                decoration: BoxDecoration(
                  color: AppColors.maroon,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(mq.size.width, 40),
                  ),
                ),
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 124,
                        height: 124,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFD9D9D9),
                          border: Border.all(color: AppColors.gold, width: 4),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/avatar.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.person,
                              size: 100,
                              color: Color(0xFFF5F5F5),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -14,
                        child: GestureDetector(
                          onTap: () => _pickGender(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: _genderBg(p.gender),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _genderIcon(p.gender),
                                    size: 14,
                                    color: _genderColor(p.gender),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  tr(p.gender),
                                  style: AppText.sans(
                                    11,
                                    color: AppColors.maroon,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 14,
                                  color: AppColors.maroon,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionLabel(tr('Nama Pengguna'), color: AppColors.maroon),
                    _field(
                      Icons.person_outline,
                      Text(
                        p.name,
                        style: AppText.sans(
                          14,
                          color: AppColors.maroon,
                          weight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        final v = await promptText(
                          context,
                          title: tr('Ubah nama'),
                          initial: p.name,
                        );
                        if (v != null && v.isNotEmpty) p.update(name: v);
                      },
                    ),
                    const SizedBox(height: 16),
                    SectionLabel(tr('Email Pengguna'), color: AppColors.maroon),
                    _field(
                      Icons.mail_outline,
                      Text(
                        p.email,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sans(
                          14,
                          color: AppColors.maroon,
                          weight: FontWeight.w600,
                        ),
                      ),
                      p.verified
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9F8EF),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF9ED9B5),
                                ),
                              ),
                              child: Text(
                                tr('Terverifikasi'),
                                style: AppText.sans(
                                  9,
                                  color: const Color(0xFF1E8E4F),
                                  weight: FontWeight.w600,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 18),
                    _field(
                      Icons.settings_outlined,
                      Text(
                        tr('Pengaturan'),
                        style: AppText.sans(
                          14,
                          color: AppColors.maroon,
                          weight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                      onTap: () => context.push('/pengaturan'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
