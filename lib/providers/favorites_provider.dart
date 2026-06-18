// NOTE : Provider Riverpod qui gère la liste des destinations favorites avec persistance.
// Concept mis en avant : StateNotifier pour un état mutable + SharedPreferences pour la sauvegarde.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination.dart';
import 'destinations_provider.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _load();
  }

  static const _key = 'favorites_ids';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = (prefs.getStringList(_key) ?? []).toSet();
  }

  Future<void> toggle(String id) async {
    // On crée un nouveau Set à chaque fois pour que Riverpod détecte le changement.
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state.toList());
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);

// Provider dérivé : retourne uniquement les destinations marquées comme favorites.
final favoriteDestinationsProvider =
    Provider<AsyncValue<List<Destination>>>((ref) {
  final destinationsAsync = ref.watch(destinationsProvider);
  final favoriteIds = ref.watch(favoritesProvider);

  return destinationsAsync.whenData(
    (destinations) =>
        destinations.where((d) => favoriteIds.contains(d.id)).toList(),
  );
});
