// NOTE : Gère la langue de l'application (FR / EN) avec persistance locale.
// Concept mis en avant : StateNotifier<Locale> + SharedPreferences, comme les favoris.

import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Langues prises en charge par l'application.
const supportedLocales = [Locale('fr'), Locale('en')];

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('fr')) {
    _load();
  }

  static const _key = 'app_locale';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }

  /// Bascule entre français et anglais.
  void toggle() {
    setLocale(state.languageCode == 'fr' ? const Locale('en') : const Locale('fr'));
  }
}

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());
