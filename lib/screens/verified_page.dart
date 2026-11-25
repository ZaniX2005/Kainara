import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_store.dart';
import '../widgets/auth_kit.dart';
import '../widgets/settings_kit.dart' show promptText;

class VerifiedPage extends StatefulWidget {
  final OtpFlow flow;
  const VerifiedPage({super.key, required this.flow});

  @override
  State<VerifiedPage> createState() => _VerifiedPageState();
}

class _VerifiedPageState extends State<VerifiedPage> {
  bool _show = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _show = true);
    });
  }

  Future<void> _finish() async {
    if (_busy) return;
    _busy = true;
    final f = widget.flow;
    if (f.purpose == OtpPurpose.register) {
      AuthStore.instance.register(f.name, f.email, f.password);
      if (mounted) context.go('/');
    } else {
      final pw = await promptText(context,
          title: 'Password baru', hint: 'Lebih dari 6 karakter', obscure: true);
      if (pw != null && pw.length > 6) {
        AuthStore.instance.resetPassword(f.email, pw);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password berhasil diganti')));
        }
      }
      if (mounted) context.go('/login');
    }
    _busy = false;
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      overlays: (s) => [
        authGreeting(s, 'Tabik Pun, selamat\ndatang di KAINARA'),
        ...authTitle(
          s,
          text: 'Proses verifikasi',
          underlineLeft: 68,
          underlineTop: 382,
        ),
        Positioned(
          left: 76 * s,
          top: 400 * s,
          width: 238 * s,
          height: 240 * s,
          child: AnimatedOpacity(
            opacity: _show ? 1 : 0,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOut,
            child: Image.asset(
              'assets/images/auth_verified.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        AuthFooter(
          s: s,
          loginLink: false,
          onButton: _finish,
          onSwitch: () => context.go('/login'),
          onGoogle: () => authSocialMessage(context, 'Google'),
          onFacebook: () => authSocialMessage(context, 'Facebook'),
        ),
      ],
    );
  }
}
