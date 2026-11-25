import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../data/auth_store.dart';
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
    var selected = p.gender;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog.fullscreen(
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            final mq = MediaQuery.of(context);
            return Scaffold(
              backgroundColor: kBgWarm,
              body: SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(
                          Icons.chevron_left,
                          color: AppColors.maroon,
                          size: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.72,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              for (final g in _genders)
                                GestureDetector(
                                  onTap: () =>
                                      setDialogState(() => selected = g),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selected == g
                                          ? const Color(0xFFD8D5D5)
                                          : kBgWarm,
                                      border: Border.all(
                                        color: AppColors.gold,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 94,
                                          height: 94,
                                          decoration: BoxDecoration(
                                            color: _genderBg(g),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: _genderColor(g)
                                                  .withValues(alpha: 0.35),
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            _genderIcon(g),
                                            color: _genderColor(g),
                                            size: 48,
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        Text(
                                          tr(g),
                                          textAlign: TextAlign.center,
                                          style: AppText.serif(
                                            16,
                                            color: AppColors.dark,
                                            weight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        20 + mq.padding.bottom,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: () {
                                p.update(gender: selected);
                                Navigator.pop(dialogContext);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF00B33C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                tr('Simpan Perubahan'),
                                style: AppText.sans(
                                  14,
                                  color: Colors.white,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.maroon,
                                side: const BorderSide(color: AppColors.maroon),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                tr('Batalkan'),
                                style: AppText.sans(
                                  14,
                                  color: AppColors.maroon,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickAvatar(
    ImageSource source,
    BuildContext sheetContext,
    BuildContext pageContext,
  ) async {
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1200,
        imageQuality: 90,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      ProfileStore.instance.update(avatarBytes: bytes);
      if (sheetContext.mounted) Navigator.pop(sheetContext);
    } on PlatformException {
      if (!pageContext.mounted) return;
      ScaffoldMessenger.of(
        pageContext,
      ).showSnackBar(SnackBar(content: Text(tr('Foto tidak dapat dibuka.'))));
    } on MissingPluginException {
      if (!pageContext.mounted) return;
      ScaffoldMessenger.of(pageContext).showSnackBar(
        SnackBar(
          content: Text(tr('Fitur foto tidak tersedia di perangkat ini.')),
        ),
      );
    }
  }

  void _editAvatar(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kBgWarm,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4D4D4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tr('Edit foto profil'),
                      style: AppText.serif(
                        20,
                        color: AppColors.maroon,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    icon: const Icon(Icons.close, color: Colors.black45),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFBDBDBD)),
              const SizedBox(height: 6),
              _avatarAction(
                icon: Icons.camera_alt_outlined,
                title: tr('Ambil foto'),
                onTap: () =>
                    _pickAvatar(ImageSource.camera, sheetContext, context),
              ),
              const SizedBox(height: 10),
              _avatarAction(
                icon: Icons.photo_outlined,
                title: tr('Pilih foto'),
                onTap: () =>
                    _pickAvatar(ImageSource.gallery, sheetContext, context),
              ),
              if (ProfileStore.instance.avatarBytes != null) ...[
                const SizedBox(height: 10),
                _avatarAction(
                  icon: Icons.delete_outline,
                  title: tr('Hapus foto'),
                  danger: true,
                  onTap: () {
                    ProfileStore.instance.update(clearAvatar: true);
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    final color = danger ? const Color(0xFFE11D48) : AppColors.maroon;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: danger ? const Color(0xFFFFC5CC) : const Color(0xFF8C8982),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: danger
                      ? const Color(0xFFFFE9EC)
                      : const Color(0xFFFFFAF3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: danger
                        ? const Color(0xFFFFC5CC)
                        : const Color(0xFFBDB7AC),
                  ),
                ),
                child: Icon(icon, size: 19, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppText.sans(
                    14,
                    color: color,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: color, size: 22),
            ],
          ),
        ),
      ),
    );
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
                      GestureDetector(
                        onTap: () => _editAvatar(context),
                        child: Container(
                          width: 124,
                          height: 124,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFD9D9D9),
                            border: Border.all(color: AppColors.gold, width: 4),
                          ),
                          child: ClipOval(
                            child: p.avatarBytes == null
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Positioned(
                                        top: 12,
                                        child: CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Color(0xFFF8F8F8),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -34,
                                        child: Container(
                                          width: 94,
                                          height: 86,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF8F8F8),
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(48),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Image.memory(
                                    p.avatarBytes!,
                                    fit: BoxFit.cover,
                                    width: 124,
                                    height: 124,
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
                        context.push('/profil/nama');
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

class EditNamaProfilPage extends StatefulWidget {
  const EditNamaProfilPage({super.key});

  @override
  State<EditNamaProfilPage> createState() => _EditNamaProfilPageState();
}

class _EditNamaProfilPageState extends State<EditNamaProfilPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ProfileStore.instance.name)
      ..addListener(_refresh);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _save() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    if (!AuthStore.instance.updateName(value)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr('Akun demo tidak ditemukan.'))));
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final keyboardOpen = mq.viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: kBgWarm,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: !keyboardOpen,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Material(
                    color: AppColors.maroon,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(context).pop(),
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
                  Expanded(
                    child: Text(
                      tr('Nama').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppText.serif(
                        22,
                        color: AppColors.maroon,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 42),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: BoxDecoration(
                  color: AppColors.maroon,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tr('Nama Anda'),
                            style: AppText.sans(11, color: Colors.white),
                          ),
                        ),
                        Text(
                          '${_controller.text.length}/30',
                          style: AppText.sans(11, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      maxLength: 30,
                      textCapitalization: TextCapitalization.words,
                      style: AppText.sans(
                        15,
                        color: AppColors.maroon,
                        weight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: kBgWarm,
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.maroon,
                          size: 20,
                        ),
                        suffixIcon: _controller.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: _controller.clear,
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Color(0xFFEBD7DC),
                                  size: 20,
                                ),
                              ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(color: AppColors.gold),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                            color: AppColors.gold,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                keyboardOpen ? 12 : 20 + mq.padding.bottom,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _controller.text.trim().isEmpty ? null : _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF00B33C),
                        disabledBackgroundColor: const Color(0xFF9BCDAA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        tr('Simpan Perubahan'),
                        style: AppText.sans(
                          14,
                          color: Colors.white,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.maroon,
                        side: const BorderSide(color: AppColors.maroon),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        tr('Batalkan'),
                        style: AppText.sans(
                          14,
                          color: AppColors.maroon,
                          weight: FontWeight.w600,
                        ),
                      ),
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
}
