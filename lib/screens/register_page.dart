import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_store.dart';
import '../widgets/auth_kit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _hide = true;

  bool _nameEmpty = false;
  bool _emailEmpty = false;
  bool _emailBad = false;
  bool _passShort = false;
  bool _passEmpty = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _clearErrors() {
    if (_nameEmpty || _emailEmpty || _emailBad || _passShort || _passEmpty) {
      setState(() {
        _nameEmpty = false;
        _emailEmpty = false;
        _emailBad = false;
        _passShort = false;
        _passEmpty = false;
      });
    }
  }

  void _submit() {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final pass = _pass.text;

    setState(() {
      _nameEmpty = name.isEmpty;
      _emailEmpty = email.isEmpty;
      _emailBad = email.isNotEmpty && !AuthStore.validEmail(email);
      _passEmpty = pass.isEmpty;
      _passShort = pass.isNotEmpty && pass.length <= 6;
    });

    final hasError = _nameEmpty ||
        _emailEmpty ||
        _emailBad ||
        _passEmpty ||
        _passShort;
    if (hasError) return;

    if (AuthStore.instance.emailExists(email)) {
      setState(() => _emailBad = true);
      return;
    }

    final flow = OtpFlow(
      purpose: OtpPurpose.register,
      email: email,
      name: name,
      password: pass,
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Kode OTP (demo): ${flow.code}')));
    context.push('/otp', extra: flow);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      overlays: (s) => [
        authGreeting(s, 'Tabik Pun, selamat\ndatang di KAINARA'),
        ...authTitle(s, text: 'Sign Up', big: true),
        authLabel(s, 'Nama Lengkap', 440),
        authLabel(s, 'Email', 514),
        authLabel(s, 'Password', 588),
        AuthInput(
          s: s,
          lineTop: 497.5,
          controller: _name,
          hint: 'Masukkan nama lengkap anda',
          hintOverride: _nameEmpty ? 'Sihlakan isi nama anda!' : null,
          hintError: _nameEmpty,
          icon: 'assets/images/icon_person.png',
          iconTop: 466,
          iconWidth: 20,
          iconHeight: 23,
          inputWidth: 254,
          onChanged: _clearErrors,
        ),
        AuthInput(
          s: s,
          lineTop: 571.5,
          controller: _email,
          hint: 'Masukkan email anda',
          hintOverride: _emailEmpty ? 'Sihlakan isi email anda!' : null,
          hintError: _emailEmpty || _emailBad,
          filledError: _emailBad,
          icon: 'assets/images/icon_mail.png',
          iconTop: 543,
          iconWidth: 20,
          iconHeight: 20,
          keyboard: TextInputType.emailAddress,
          inputWidth: 254,
          onChanged: _clearErrors,
        ),
        AuthInput(
          s: s,
          lineTop: 645.5,
          controller: _pass,
          hint: 'Masukkan password anda',
          hintOverride: _passEmpty ? 'Sihlakan isi password anda!' : null,
          hintError: _passEmpty,
          obscure: _hide,
          icon: 'assets/images/icon_lock.png',
          iconTop: 613,
          iconWidth: 20,
          iconHeight: 24,
          inputWidth: 240,
          onChanged: _clearErrors,
          eye: authEye(
            s,
            closed: _hide && _pass.text.isNotEmpty,
            lineTop: 645.5,
            onTap: () => setState(() => _hide = !_hide),
          ),
        ),
        if (_passShort)
          authError(
            s,
            '*Karakte tidak sesuai, harus lebih dari 6 karakter',
            648.5,
            left: 28,
            width: 318,
            color: AuthColors.maroon,
          ),
        AuthFooter(
          s: s,
          loginLink: false,
          shift: _passShort ? 9 : 0,
          onButton: _submit,
          onSwitch: () => context.go('/login'),
          onGoogle: () => authSocialMessage(context, 'Google'),
          onFacebook: () => authSocialMessage(context, 'Facebook'),
        ),
      ],
    );
  }
}
