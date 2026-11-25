import 'package:go_router/go_router.dart';

import 'data/auth_store.dart';
import 'screens/catalog_page.dart';
import 'screens/favorit_page.dart';
import 'screens/home_page.dart';
import 'screens/main_shell.dart';
import 'screens/motif_detail_page.dart';
import 'screens/outfit_page.dart';
import 'screens/scan_page.dart';
import 'screens/outfit_pick_page.dart';
import 'screens/share_outfit_page.dart';
import 'screens/riwayat_page.dart';
import 'screens/scan_result_page.dart';
import 'screens/profil_page.dart';
import 'screens/settings_pages.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/forgot_page.dart';
import 'screens/otp_page.dart';
import 'screens/verified_page.dart';
import 'screens/notification_page.dart';

final router = GoRouter(
  initialLocation: '/login',
  refreshListenable: AuthStore.instance,
  redirect: (context, state) {
    final loggedIn = AuthStore.instance.loggedIn;
    final path = state.uri.path;
    const authPaths = ['/login', '/register', '/forgot', '/otp', '/verified'];
    final isAuthPage = authPaths.contains(path);
    if (!loggedIn && !isAuthPage) return '/login';
    if (loggedIn && isAuthPage) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
    GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
    GoRoute(path: '/forgot', builder: (_, _) => const ForgotPage()),
    GoRoute(
      path: '/otp',
      builder: (_, state) => OtpPage(flow: state.extra as OtpFlow),
    ),
    GoRoute(
      path: '/verified',
      builder: (_, state) => VerifiedPage(flow: state.extra as OtpFlow),
    ),
    ShellRoute(
      builder: (context, state, child) =>
          MainShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HomePage()),
        GoRoute(
          path: '/catalog',
          builder: (_, state) =>
              CatalogPage(initialQuery: state.uri.queryParameters['q'] ?? ''),
        ),
        GoRoute(
          path: '/motif/:id',
          builder: (_, state) =>
              MotifDetailPage(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/scan-result/:id',
          builder: (_, state) => ScanResultPage(
            id: state.pathParameters['id']!,
            accuracy:
                int.tryParse(state.uri.queryParameters['acc'] ?? '') ?? 98,
          ),
        ),
        GoRoute(
          path: '/outfit-pick',
          builder: (_, _) => const OutfitPickPage(),
        ),
        GoRoute(
          path: '/share-outfit',
          builder: (_, _) => const ShareOutfitPage(),
        ),
        GoRoute(path: '/outfit', builder: (_, _) => const OutfitPage()),
        GoRoute(path: '/favorit', builder: (_, _) => const FavoritPage()),
        GoRoute(path: '/scan', builder: (_, _) => const ScanPage()),
        GoRoute(path: '/riwayat', builder: (_, _) => const RiwayatPage()),
        GoRoute(
          path: '/notifikasi',
          builder: (_, _) => const NotificationPage(),
        ),
        GoRoute(path: '/profil', builder: (_, _) => const ProfilPage()),
        GoRoute(
          path: '/profil/nama',
          builder: (_, _) => const EditNamaProfilPage(),
        ),
        GoRoute(path: '/pengaturan', builder: (_, _) => const PengaturanPage()),
        GoRoute(
          path: '/pengaturan/notifikasi',
          builder: (_, _) => const NotifikasiSettingsPage(),
        ),
        GoRoute(
          path: '/pengaturan/bahasa',
          builder: (_, _) => const BahasaPage(),
        ),
        GoRoute(
          path: '/pengaturan/privasi',
          builder: (_, _) => const PrivasiPage(),
        ),
        GoRoute(
          path: '/pengaturan/keamanan',
          builder: (_, _) => const KeamananPage(),
        ),
        GoRoute(
          path: '/pengaturan/akun',
          builder: (_, _) => const PasswordEmailPage(),
        ),
        GoRoute(
          path: '/pengaturan/perangkat',
          builder: (_, _) => const PerangkatPage(),
        ),
      ],
    ),
  ],
);
