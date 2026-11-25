import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/l10n.dart';
import '../data/profile_store.dart';
import '../data/auth_store.dart';
import '../data/settings_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/settings_kit.dart';

// ============================================================ SETTINGS ACCOUNT

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: tr('Pengaturan Akun'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 36, 20, 40),
        children: [
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.notifications_none,
                title: tr('Notifikasi'),
                onTap: () => context.push('/pengaturan/notifikasi'),
              ),
              SettingsTile(
                icon: Icons.language,
                title: tr('Pengaturan Bahasa'),
                onTap: () => context.push('/pengaturan/bahasa'),
              ),
              SettingsTile(
                icon: Icons.shield_outlined,
                title: tr('Privasi dan Keamanan'),
                onTap: () => context.push('/pengaturan/privasi'),
              ),
              SettingsTile(
                icon: Icons.lock_reset,
                title: tr('Ganti Password/Email'),
                onTap: () => context.push('/pengaturan/akun'),
              ),
              SettingsTile(
                icon: Icons.switch_account_outlined,
                title: tr('Ganti Akun'),
                onTap: () async {
                  final switchAccount = await switchAccountDialog(context);
                  if (switchAccount) AuthStore.instance.logout();
                },
              ),
              SettingsTile(
                icon: Icons.logout,
                title: tr('Log Out'),
                danger: true,
                onTap: () async {
                  final ok = await logoutDialog(context);
                  if (ok) AuthStore.instance.logout();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================ NOTIFIKASI

class NotifikasiSettingsPage extends StatelessWidget {
  const NotifikasiSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: tr('Notifikasi'),
      body: ListenableBuilder(
        listenable: SettingsStore.instance,
        builder: (context, _) {
          final settings = SettingsStore.instance;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 40),
            children: [
              SettingsCard(
                children: [
                  SettingsTile(
                    icon: Icons.notifications_paused_outlined,
                    title: tr('Jeda semua'),
                    subtitle: tr('Jeda semua notifikasi sementara'),
                    trailing: KSwitch(
                      value: settings.pauseNotifications,
                      onChanged: settings.setPauseNotifications,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.auto_awesome_outlined,
                    title: tr('Motif Tapis'),
                    subtitle: tr('Notifikasi motif tapis aktif'),
                    trailing: KSwitch(
                      value: settings.motifNotificationsActive,
                      onChanged: settings.setMotifNotifications,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.checkroom_outlined,
                    title: tr('Rekomendasi Outfit'),
                    subtitle: tr('Notifikasi rekomendasi outfit aktif'),
                    trailing: KSwitch(
                      value: settings.outfitNotificationsActive,
                      onChanged: settings.setOutfitNotifications,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: Text(
                  tr(
                    'Preferensi berlaku selama aplikasi berjalan. Pengiriman notifikasi push belum tersedia tanpa layanan notifikasi.',
                  ),
                  style: AppText.sans(11, color: Colors.black45, height: 1.5),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================ BAHASA

class _Lang {
  final String name, native;
  const _Lang(this.name, this.native);
}

class BahasaPage extends StatefulWidget {
  const BahasaPage({super.key});

  @override
  State<BahasaPage> createState() => _BahasaPageState();
}

class _BahasaPageState extends State<BahasaPage> {
  late final List<_Lang> _langs = L10n.instance.lang == 'English'
      ? [
          const _Lang('English', 'Inggris'),
          const _Lang('Indonesia', 'Bahasa Indonesia'),
        ]
      : [
          const _Lang('Indonesia', 'Bahasa Indonesia'),
          const _Lang('English', 'Inggris'),
        ];
  static const _available = [
    _Lang('Indonesia', 'Bahasa Indonesia'),
    _Lang('English', 'Inggris'),
  ];
  bool _edit = false;

  void _apply() => L10n.instance.setLang(_langs.first.name);

  Widget _primaryBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFF1F1F1),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE0E0E0)),
    ),
    child: Text(
      tr('Bahasa Utama'),
      style: AppText.sans(
        10,
        color: _edit ? AppColors.dark : Colors.black45,
        weight: _edit ? FontWeight.w600 : FontWeight.w400,
      ),
    ),
  );

  Widget _trailingPill() {
    return GestureDetector(
      onTap: () => setState(() => _edit = !_edit),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _edit ? const Color(0xFF1B7F1B) : const Color(0x33FFFFFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _edit ? const Color(0xFF1B7F1B) : Colors.white38,
          ),
        ),
        child: Text(
          tr(_edit ? 'Selesai' : 'Edit'),
          style: AppText.sans(
            11,
            color: _edit ? Colors.white : AppColors.maroon,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _addLanguage() {
    final options = _available
        .where((a) => !_langs.any((l) => l.name == a.name))
        .toList();
    showModalBottomSheet(
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
              tr('Tambahkan Bahasa'),
              style: AppText.serif(20, color: AppColors.maroon),
            ),
            const SizedBox(height: 8),
            if (options.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  tr('Semua bahasa sudah ditambahkan'),
                  style: AppText.sans(13, color: Colors.black54),
                ),
              ),
            for (final o in options)
              ListTile(
                leading: const IconBubble(Icons.language),
                title: Text(
                  tr(o.name),
                  style: AppText.sans(14, color: AppColors.dark),
                ),
                subtitle: Text(
                  tr(o.native),
                  style: AppText.sans(11, color: Colors.black45),
                ),
                onTap: () {
                  setState(() => _langs.add(o));
                  _apply();
                  Navigator.pop(sheet);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _normalList() {
    return SettingsCard(
      children: [
        for (var i = 0; i < _langs.length; i++)
          SettingsTile(
            icon: Icons.language,
            title: tr(_langs[i].name),
            subtitle: tr(_langs[i].native),
            trailing: i == 0 ? _primaryBadge() : null,
            onTap: i == 0
                ? null
                : () {
                    setState(() {
                      final l = _langs.removeAt(i);
                      _langs.insert(0, l);
                    });
                    _apply();
                  },
          ),
      ],
    );
  }

  Widget _editList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        child: ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorderItem: (o, n) {
            setState(() {
              final l = _langs.removeAt(o);
              _langs.insert(n, l);
            });
            _apply();
          },
          children: [
            for (var i = 0; i < _langs.length; i++)
              Container(
                key: ValueKey(_langs[i].name),
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_langs.length > 1) {
                          setState(() => _langs.removeAt(i));
                          _apply();
                        }
                      },
                      child: const IconBubble(
                        Icons.delete_outline,
                        danger: true,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(_langs[i].name),
                            style: AppText.sans(
                              14,
                              color: const Color(0xFF1E1E1E),
                              weight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            tr(_langs[i].native),
                            style: AppText.sans(11, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                    if (i == 0)
                      _primaryBadge()
                    else
                      ReorderableDragStartListener(
                        index: i,
                        child: const Icon(
                          Icons.drag_handle,
                          color: Colors.black38,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SettingsScaffold(
      title: tr('Pengaturan Bahasa'),
      background: _edit ? kBgGreen : kBgWarm,
      trailing: _trailingPill(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          if (_edit) SectionLabel(tr('Daftar bahasa tersimpan')),
          _edit ? _editList() : _normalList(),
          if (_edit)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(
                tr(
                  'Bahasa pertama di daftar akan digunakan sebagai prioritas tampilan antarmuka kain dan busana KAINARA.',
                ),
                textAlign: TextAlign.center,
                style: AppText.sans(10, color: Colors.black38, height: 1.5),
              ),
            ),
        ],
      ),
      bottom: Padding(
        padding: EdgeInsets.fromLTRB(22, 8, 22, mq.padding.bottom + 28),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.maroon,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: _addLanguage,
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            label: Text(
              tr('Tambahkan Bahasa'),
              style: AppText.sans(13, weight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================ PRIVASI & KEAMANAN

class PrivasiPage extends StatelessWidget {
  const PrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: tr('Privasi & Keamanan'),
      background: kBgGreen,
      body: ListenableBuilder(
        listenable: SettingsStore.instance,
        builder: (context, _) {
          final settings = SettingsStore.instance;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 40),
            children: [
              SettingsCard(
                children: [
                  SettingsTile(
                    icon: Icons.verified_user_outlined,
                    title: tr('Pemeriksaan Keamanan'),
                    onTap: () => context.push('/pengaturan/keamanan'),
                  ),
                  SettingsTile(
                    icon: Icons.smartphone,
                    title: tr('Perangkat Anda'),
                    onTap: () => context.push('/pengaturan/perangkat'),
                  ),
                  SettingsTile(
                    icon: Icons.key_outlined,
                    title: tr('Simpan info login'),
                    chevron: false,
                    trailing: KSwitch(
                      value: settings.saveLoginInfo,
                      onChanged: settings.setSaveLoginInfo,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  tr(
                    'Semua info login yang disimpan untuk akun ini akan dihapus jika pengaturan ini dinonaktifkan.',
                  ),
                  style: AppText.sans(11, color: Colors.black54, height: 1.5),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================ PEMERIKSAAN KEAMANAN

class KeamananPage extends StatelessWidget {
  const KeamananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: tr('Pemeriksaan Keamanan'),
      background: kBgGreen,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
        children: [
          Center(
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFFEADDD8),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFDCC9C2)),
              ),
              child: const Icon(
                Icons.verified_user_outlined,
                size: 36,
                color: AppColors.maroon,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              tr('Keamanan'),
              style: AppText.serif(
                22,
                color: const Color(0xFF1E1E1E),
                weight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              tr(
                'Lihat dan kelola pengaturan untuk menjaga keamanan akun Anda',
              ),
              textAlign: TextAlign.center,
              style: AppText.sans(12, color: Colors.black54, height: 1.5),
            ),
          ),
          const SizedBox(height: 20),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.warning_amber_rounded,
                title: tr('Peringatan Keamanan'),
                subtitle: tr('Aktivitas akun selama 7 hari terakhir'),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      tr('Peringatan Keamanan'),
                      style: AppText.serif(20, color: AppColors.maroon),
                    ),
                    content: Text(
                      tr(
                        'Pemeriksaan aktivitas memerlukan layanan akun dan belum tersedia dalam mode demo.',
                      ),
                      style: AppText.sans(
                        13,
                        color: AppColors.dark,
                        height: 1.5,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          tr('Tutup'),
                          style: AppText.serif(16, color: AppColors.maroon),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SettingsTile(
                icon: Icons.smartphone,
                title: tr('Perangkat Anda'),
                subtitle: tr(
                  'Kelola perangkat yang Anda gunakan untuk masuk ke akun',
                ),
                onTap: () => context.push('/pengaturan/perangkat'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================ PASSWORD & EMAIL

class PasswordEmailPage extends StatelessWidget {
  const PasswordEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: tr('Password & Email'),
      background: kBgGreen,
      body: ListenableBuilder(
        listenable: ProfileStore.instance,
        builder: (context, _) {
          final p = ProfileStore.instance;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            children: [
              SettingsCard(
                children: [
                  SettingsTile(
                    icon: Icons.mail_outline,
                    title: tr('Email'),
                    subtitle: p.email.toLowerCase(),
                    onTap: () async {
                      final v = await promptText(
                        context,
                        title: tr('Ubah email'),
                        initial: p.email,
                        hint: tr('nama@email.com'),
                      );
                      if (v == null) return;
                      final result = AuthStore.instance.updateEmail(v);
                      if (!context.mounted) return;
                      final message = switch (result) {
                        AccountUpdateResult.ok => tr('Email diperbarui.'),
                        AccountUpdateResult.invalidEmail => tr(
                          'Masukkan alamat email yang valid.',
                        ),
                        AccountUpdateResult.emailAlreadyExists => tr(
                          'Email sudah digunakan.',
                        ),
                        AccountUpdateResult.accountNotFound => tr(
                          'Akun demo tidak ditemukan.',
                        ),
                        AccountUpdateResult.weakPassword => null,
                      };
                      if (message != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(message)));
                      }
                    },
                  ),
                  SettingsTile(
                    icon: Icons.lock_outline,
                    title: tr('Password'),
                    subtitle: p.maskedPassword,
                    onTap: () async {
                      final v = await promptText(
                        context,
                        title: tr('Password baru'),
                        hint: tr('Minimal 6 karakter'),
                        obscure: true,
                      );
                      if (v == null) return;
                      final result = AuthStore.instance.updatePassword(v);
                      if (!context.mounted) return;
                      final message = switch (result) {
                        AccountUpdateResult.ok => tr('Password diperbarui'),
                        AccountUpdateResult.weakPassword => tr(
                          'Password harus minimal 6 karakter.',
                        ),
                        AccountUpdateResult.accountNotFound => tr(
                          'Akun demo tidak ditemukan.',
                        ),
                        AccountUpdateResult.emailAlreadyExists => tr(
                          'Email sudah terdaftar.',
                        ),
                        AccountUpdateResult.invalidEmail => tr(
                          'Masukkan alamat email yang valid.',
                        ),
                      };
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================ KELOLA PERANGKAT

class PerangkatPage extends StatefulWidget {
  const PerangkatPage({super.key});

  @override
  State<PerangkatPage> createState() => _PerangkatPageState();
}

class _PerangkatPageState extends State<PerangkatPage> {
  bool _otherDeviceActive = true;

  @override
  Widget build(BuildContext context) {
    Widget deviceCard({
      required IconData icon,
      required String name,
      required String app,
      required Widget trailing,
    }) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: kIconBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF0DCC0)),
              ),
              child: Icon(icon, size: 26, color: AppColors.goldDeep),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppText.sans(
                      14,
                      color: Colors.black,
                      weight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(app, style: AppText.sans(11, color: Colors.black54)),
                  const SizedBox(height: 3),
                  Text(
                    tr('26 Oktober 2025 08.56 WIB'),
                    style: AppText.sans(10, color: Colors.black38),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      );
    }

    return SettingsScaffold(
      title: tr('Kelola Perangkat'),
      background: kBgGreen,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
        children: [
          SectionLabel(tr('Perangkat saat ini')),
          deviceCard(
            icon: Icons.smartphone,
            name: 'Samsung Galaxy S26 Ultra',
            app: tr('Aplikasi'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F8EF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF9ED9B5)),
              ),
              child: Text(
                tr('Aktif'),
                style: AppText.sans(
                  11,
                  color: const Color(0xFF1E8E4F),
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (_otherDeviceActive) ...[
            const SizedBox(height: 26),
            SectionLabel(tr('Perangkat lain tempat anda masuk')),
            deviceCard(
              icon: Icons.language,
              name: 'Chrome',
              app: 'Kainara web',
              trailing: TextButton(
                onPressed: () async {
                  final ok = await confirmDialog(
                    context,
                    title: tr('Keluar dari perangkat'),
                    message: '${tr('Keluarkan akun Anda dari')} Chrome?',
                    ok: tr('Keluar'),
                  );
                  if (ok && mounted) {
                    setState(() => _otherDeviceActive = false);
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFE11D48),
                  backgroundColor: const Color(0xFFFFF0F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  tr('Keluar'),
                  style: AppText.sans(
                    11,
                    color: const Color(0xFFE11D48),
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
