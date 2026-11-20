import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../widgets/kainara_bottom_nav.dart';

class MainShell extends StatelessWidget {
  final String location;
  final Widget child;
  const MainShell({super.key, required this.location, required this.child});

  static const _paths = ['/', '/favorit', '/scan', '/riwayat', '/profil'];

  int get _index {
    if (location.startsWith('/favorit')) return 1;
    if (location.startsWith('/scan')) return 2;
    if (location.startsWith('/riwayat')) return 3;
    if (location.startsWith('/profil')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.maroon,
      body: child,
      bottomNavigationBar: (location.startsWith('/catalog') ||
              location.startsWith('/scan') ||
              location.startsWith('/outfit-pick') ||
              location.startsWith('/share-outfit') ||
              location.startsWith('/pengaturan'))
          ? null
          : KainaraBottomNav(index: _index, onTap: (i) => context.go(_paths[i])),
    );
  }
}
