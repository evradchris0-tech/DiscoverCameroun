// NOTE : Point d'entrée de l'application — ProviderScope active Riverpod pour toute l'appli.
// Concept mis en avant : MaterialApp avec thème centralisé (AppTheme), i18n FR/EN et ProviderScope.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  // ProviderScope est obligatoire pour utiliser Riverpod dans l'application.
  runApp(const ProviderScope(child: DiscoverCameroonApp()));
}

class DiscoverCameroonApp extends ConsumerWidget {
  const DiscoverCameroonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'KmerTour',
      debugShowCheckedModeBanner: false,
      // Tout le Design System (couleurs, typo, rayons, espacements) vit dans theme/.
      theme: AppTheme.light,
      // Internationalisation FR / EN.
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
