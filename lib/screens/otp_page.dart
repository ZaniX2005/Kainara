import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_store.dart';
import '../widgets/auth_kit.dart';

class OtpPage extends StatefulWidget {
  final OtpFlow flow;
  const OtpPage({super.key, required this.flow});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _left = 48;
  bool _started = false;
  bool _wrong = false;

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _left = 48;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_left > 0) {
          _left--;
        } else {
          t.cancel();
        }
      });
    });
  }

  void _onChanged() {
    setState(() {
      _wrong = false;
      if (!_started && _ctrl.text.isNotEmpty) {
        _started = true;
        _startTimer();
      }
    });
  }

  void _verify() {
    if (_ctrl.text == widget.flow.code) {
      _timer?.cancel();
      FocusScope.of(context).unfocus();
      context.push('/verified', extra: widget.flow);
    } else {
      setState(() => _wrong = true);
    }
  }

  void _resend() {
    setState(() {
      widget.flow.regenerate();
      _started = true;
      _startTimer();
      _wrong = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kode OTP baru (demo): ${widget.flow.code}')));
  }

  @override
  Widget build(BuildContext context) {
    final timer = '00:${_left.toString().padLeft(2, '0')}';
    return AuthScaffold(
      overlays: (s) => [
        authGreeting(s, 'Tabik Pun, selamat\ndatang di KAINARA'),
        ...authTitle(
          s,
          text: 'kode OTP',
          left: 34,
          underlineLeft: 37,
          underlineTop: 383,
        ),
        authDesc(
          s,
          'Silakan masukkan 5 digit kode verifikasi yang telah dikirimkan ke email terdaftar anda.',
          391.5,
        ),
        AuthOtpField(
          s: s,
          controller: _ctrl,
          focus: _focus,
          wrong: _wrong,
          onChanged: _onChanged,
        ),
        Positioned(
          left: 58 * s,
          top: 529.5 * s,
          child: Text(
            'Tidak menerima kode?',
            style: authText(11, color: AuthColors.smallGray, height: 1),
          ),
        ),
        if (_started)
          Positioned(
            right: 60 * s,
            top: 529.5 * s,
            child: GestureDetector(
              onTap: _left == 0 ? _resend : null,
              child: Text(
                _left == 0 ? 'Kirim ulang' : 'Kirim ulang ($timer)',
                style: authText(
                  10.5,
                  color: AuthColors.maroon,
                  weight: FontWeight.w600,
                  height: 1,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        AuthFooter(
          s: s,
          loginLink: false,
          onButton: _verify,
          onSwitch: () => context.go('/login'),
          onGoogle: () => authSocialMessage(context, 'Google'),
          onFacebook: () => authSocialMessage(context, 'Facebook'),
        ),
      ],
    );
  }
}
