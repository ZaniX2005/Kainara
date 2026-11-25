import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/l10n.dart';
import 'router.dart';
import 'theme/app_theme.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const KainaraApp());
}

class KainaraApp extends StatelessWidget {
  const KainaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: L10n.instance,
      builder: (context, _) => MaterialApp.router(
        key: ValueKey(L10n.instance.lang),
        title: 'KAINARA',
        theme: AppTheme.light,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
 