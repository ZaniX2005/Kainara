import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_store.dart';
import '../widgets/auth_kit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _hide = true;

  bool _emptyEmail = false;
  bool _invalidEmail = false;
  bool _wrongPass = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _clearErrors() {
    if (_emptyEmail || _invalidEmail || _wrongPass) {
      setState(() {
        _emptyEmail = false;
        _invalidEmail = false;
        _wrongPass = false;
      });
    }
  }

  void _submit() {
    final e = _email.text.trim();
    final p = _pass.text;

    if (e.isEmpty) {
      setState(() {
        _emptyEmail = true;
        _invalidEmail = false;
        _wrongPass = false;
      });
      return;
    }
    if (!AuthStore.validEmail(e) || !AuthStore.instance.emailExists(e)) {
      setState(() {
        _emptyEmail = false;
        _invalidEmail = true;
        _wrongPass = false;
      });
      return;
    }
    final res = AuthStore.instance.login(e, p);
    if (res == AuthResult.ok) {
      if (mounted) context.go('/');
      return;
    }
    setState(() {
      _emptyEmail = false;
      _invalidEmail = res == AuthResult.emailNotFound;
      _wrongPass = res == AuthResult.wrongPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      overlays: (s) => [
        ...authTitle(s, text: 'Sign In', big: true),
        authLabel(s, 'Email', 429),
        authLabel(s, 'Password', 503),
        AuthInput(
          s: s,
          lineTop: 485.5,
          controller: _email,
          hint: 'Masukkan email anda',
          hintOverride: _emptyEmail ? 'Sihlakan isi email anda!' : null,
          hintError: _emptyEmail,
          filledError: _invalidEmail,
          icon: 'assets/images/icon_mail.png',
          iconTop: 457,
          iconWidth: 20,
          iconHeight: 20,
          keyboard: TextInputType.emailAddress,
          inputWidth: 254,
          onChanged: _clearErrors,
        ),
        if (_invalidEmail) ...[
          Positioned(
            left: 327 * s,
            top: 455 * s,
            width: 22 * s,
            height: 22 * s,
            child: Image.asset('assets/images/icon_error.png',
                fit: BoxFit.fill, filterQuality: FilterQuality.high),
          ),
          authError(
            s,
            'Email yang Anda masukkan tidak terdaftar atau tidak valid',
            488.5,
            left: 29,
            width: 286,
          ),
        ],
        AuthInput(
          s: s,
          lineTop: 559.5,
          controller: _pass,
          hint: 'Masukkan password anda',
          obscure: _hide,
          hintError: false,
          icon: 'assets/images/icon_lock.png',
          iconTop: 527,
          iconWidth: 20,
          iconHeight: 24,
          inputWidth: 240,
          onChanged: _clearErrors,
          eye: authEye(
            s,
            closed: _hide,
            lineTop: 559.5,
            onTap: () => setState(() => _hide = !_hide),
          ),
        ),
        if (_wrongPass) ...[
          Positioned(
            left: 29 * s,
            top: 566 * s,
            width: 22 * s,
            height: 22 * s,
            child: Image.asset('assets/images/icon_error.png',
                fit: BoxFit.fill, filterQuality: FilterQuality.high),
          ),
          authError(
            s,
            'Password yang Anda masukkan salah. Silakan coba lagi.',
            565.5,
            left: 63,
            width: 288,
          ),
        ],
        authForgotLink(
          s,
          top: _wrongPass ? 598.5 : 573.5,
          right: _wrongPass ? 45 : 55,
          onTap: () => context.push('/forgot'),
        ),
        AuthFooter(
          s: s,
          loginLink: true,
          onButton: _submit,
          onSwitch: () => context.go('/register'),
          onGoogle: () => authSocialMessage(context, 'Google'),
          onFacebook: () => authSocialMessage(context, 'Facebook'),
        ),
      ],
    );
  }
}
