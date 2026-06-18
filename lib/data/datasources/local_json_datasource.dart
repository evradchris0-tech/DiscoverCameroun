// NOTE : Source de données locale — lit les fichiers JSON embarqués dans les assets.
// Concept mis en avant : abstraction de la source. Demain, un RemoteApiDataSource
// implémentant la même intention (renvoyer des listes de Map) remplacera celui-ci
// sans toucher aux repositories ni à l'UI.

import 'dart:convert';
import 'package:flutter/services.dart';

class LocalJsonDataSource {
  const LocalJsonDataSource();

  /// Charge un fichier JSON contenant une liste d'objets et renvoie les Map brutes.
  /// Les repositories se chargent ensuite du mapping vers les entités typées.
  Future<List<Map<String, dynamic>>> loadRawList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }
}
