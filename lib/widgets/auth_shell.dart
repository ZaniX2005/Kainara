import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'auth_header.dart';
import 'auth_widgets.dart';

/// Kerangka halaman auth: header ilustrasi + panel krem bergelombang.
class AuthShell extends StatelessWidget {
  final String? headerText;
  final Widget content; // mulai di y ≈ 345
  final String buttonLabel;
  final VoidCallback? onButton;
  final double buttonTop; // posisi tombol pada desain 390 x 844

  const AuthShell({
    super.key,
    required this.content,
    this.headerText,
    this.buttonLabel = 'Masuk Akun',
    this.onButton,
    this.buttonTop = 669,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = math.min(mq.size.width, 430.0);
    final s = w / 390;
    final h = math.max(mq.size.height, 844 * s);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SizedBox(
          width: w,
          child: SingleChildScrollView(
            child: SizedBox(
              height: h,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(child: AuthHeader(s: s)),
                  if (headerText != null)
                    Positioned(
                      top: 66 * s,
                      left: 26 * s,
                      width: 260 * s,
                      child: Text(
                        headerText!,
                        style: AppText.serif(
                          24,
                          color: const Color(0xFF1E1E1E),
                          height: 1.15,
                        ),
                      ),
                    ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    width: 210 * s,
                    child: IgnorePointer(
                      child: Image.asset(
                        'assets/images/ornamen_login.png',
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 345 * s,
                    left: 28 * s,
                    right: 44 * s,
                    child: content,
                  ),
                  Positioned(
                    top: buttonTop * s,
                    left: 46 * s,
                    right: 62 * s,
                    child: Column(
                      children: [
                        AuthButton(
                          label: buttonLabel,
                          onTap: onButton ?? () {},
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            style: AppText.sans(
                              12,
                              color: const Color(0xFF555555),
                            ),
                            children: [
                              const TextSpan(text: 'Sudah buat akun? '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: Text(
                                    'Sign In',
                                    style: AppText.sans(
                                      12,
                                      color: AppColors.maroon,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Color(0xFFD9CFC4), height: 1),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _soon(context, 'Google'),
                              child: const FaIcon(
                                FontAwesomeIcons.google,
                                size: 22,
                                color: Color(0xFFDB4437),
                              ),
                            ),
                            const SizedBox(width: 22),
                            GestureDetector(
                              onTap: () => _soon(context, 'Facebook'),
                              child: const FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 24,
                                color: Color(0xFF1877F2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _soon(BuildContext c, String n) => ScaffoldMessenger.of(c)
      .showSnackBar(SnackBar(content: Text('Masuk dengan $n segera hadir')));
}

/// Judul maroon + garis tebal, opsional deskripsi.
class AuthTitle extends StatelessWidget {
  final String text;
  final String? desc;
  final double size;
  const AuthTitle(this.text, {super.key, this.desc, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppText.sans(
            size,
            color: AppColors.maroon,
            weight: FontWeight.w600,
          ),
        ),
        Container(
          width: 70,
          height: 4,
          margin: const EdgeInsets.only(top: 2, bottom: 6),
          decoration: BoxDecoration(
            color: AppColors.maroon,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        if (desc != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              desc!,
              style: AppText.sans(12, color: AppColors.maroon, height: 1.5),
            ),
          ),
      ],
    );
  }
}
