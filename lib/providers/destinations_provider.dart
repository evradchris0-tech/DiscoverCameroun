// NOTE : Providers Riverpod pour gérer les destinations et les filtres de manière globale.
// Concept mis en avant : FutureProvider via le repository + Provider dérivé pour le filtrage.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/destination_category.dart';
import '../models/destination.dart';
import 'repository_providers.dart';

// Charge la liste complète via le DestinationRepository (source JSON ou API).
final destinationsProvider = FutureProvider<List<Destination>>((ref) async {
  return ref.watch(destinationRepositoryProvider).getAll();
});

// Requête de recherche saisie dans la barre de recherche.
final searchQueryProvider = StateProvider<String>((ref) => '');

// Catégorie sélectionnée pour filtrer (null = toutes les catégories).
final selectedCategoryProvider = StateProvider<DestinationCategory?>((ref) => null);

// Région sélectionnée pour filtrer (null = toutes les régions).
final selectedRegionProvider = StateProvider<String?>((ref) => null);

// Provider dérivé : se recalcule automatiquement quand query, category ou region change.
final filteredDestinationsProvider = Provider<AsyncValue<List<Destination>>>((ref) {
  final destinationsAsync = ref.watch(destinationsProvider);
  final query = ref.watch(searchQueryProvider);
  final category = ref.watch(selectedCategoryProvider);
  final region = ref.watch(selectedRegionProvider);

  return destinationsAsync.whenData((destinations) {
    return destinations.where((dest) {
      final matchesSearch =
          dest.name.toLowerCase().contains(query.toLowerCase());
      final matchesCategory =
          category == null || dest.category == category;
      final matchesRegion = region == null || dest.region == region;
      return matchesSearch && matchesCategory && matchesRegion;
    }).toList();
  });
});

/// Résumé d'une région pour la vue « Découvrir par région ».
class RegionInfo {
  final String name;
  final int count;
  final String cover; // image représentative (1re destination de la région)

  const RegionInfo(
      {required this.name, required this.count, required this.cover});
}

// Liste des régions (avec compte + image), triée par nombre de destinations décroissant.
final regionsProvider = Provider<AsyncValue<List<RegionInfo>>>((ref) {
  return ref.watch(destinationsProvider).whenData((destinations) {
    final byRegion = <String, List<Destination>>{};
    for (final d in destinations) {
      byRegion.putIfAbsent(d.region, () => []).add(d);
    }
    final regions = byRegion.entries
        .map((e) => RegionInfo(
              name: e.key,
              count: e.value.length,
              cover: e.value.first.cover,
            ))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    return regions;
  });
});

// Récupère une destination par son identifiant (pratique pour les écrans dérivés).
final destinationByIdProvider =
    Provider.family<AsyncValue<Destination?>, String>((ref, id) {
  return ref.watch(destinationsProvider).whenData((list) {
    final matches = list.where((d) => d.id == id);
    return matches.isEmpty ? null : matches.first;
  });
});
