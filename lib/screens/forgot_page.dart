import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_store.dart';
import '../widgets/auth_kit.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _email = TextEditingController();
  String? _err;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    final e = _email.text.trim();
    if (!AuthStore.validEmail(e) || !AuthStore.instance.emailExists(e)) {
      setState(() =>
          _err = 'alamat email anda tidak sinkron atau kesalahan jaringan*.');
      return;
    }
    final flow = OtpFlow(purpose: OtpPurpose.reset, email: e);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Kode OTP (demo): ${flow.code}')));
    context.push('/otp', extra: flow);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      overlays: (s) => [
        authGreeting(s, 'Tabik Pun, selamat\ndatang di KAINARA'),
        ...authTitle(
          s,
          text: 'Lupa Password',
          underlineLeft: 33,
          underlineTop: 383,
        ),
        authDesc(
          s,
          'Silakan masukkan email terdaftar untuk menerima petunjuk reset kata sandi akun Anda.',
          391.5,
        ),
        AuthInput(
          s: s,
          lineTop: 504.5,
          controller: _email,
          hint: 'Masukkan alamat email anda',
          hintError: false,
          icon: 'assets/images/icon_mail.png',
          iconTop: 476,
          iconWidth: 20,
          iconHeight: 20,
          keyboard: TextInputType.emailAddress,
          inputWidth: 286,
          onChanged: () {
            if (_err != null) setState(() => _err = null);
          },
        ),
        if (_err != null)
          authError(
            s,
            _err!,
            510,
            left: 29,
            width: 286,
          ),
        AuthFooter(
          s: s,
          loginLink: false,
          onButton: _submit,
          onSwitch: () => context.go('/login'),
          onGoogle: () => authSocialMessage(context, 'Google'),
          onFacebook: () => authSocialMessage(context, 'Facebook'),
        ),
      ],
    );
  }
}
