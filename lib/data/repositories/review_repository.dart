// NOTE : Repository des avis — persistance locale via SharedPreferences.
// Concept mis en avant : le repository isole complètement la mécanique de stockage ;
// migrer vers une API distante ne changerait que ce fichier.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/review.dart';

class ReviewRepository {
  static const String _keyPrefix = 'reviews_';

  // Clé SharedPreferences pour une destination donnée.
  String _key(String destinationId) => '$_keyPrefix$destinationId';

  /// Charge tous les avis d'une destination depuis le stockage local.
  Future<List<Review>> getForDestination(String destinationId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key(destinationId)) ?? [];
    return raw
        .map((s) => Review.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // tri anti-chronologique
  }

  /// Sauvegarde un nouvel avis (ajouté en tête de liste).
  Future<void> addReview(Review review) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(review.destinationId);
    final existing = prefs.getStringList(key) ?? [];
    existing.insert(0, jsonEncode(review.toJson()));
    await prefs.setStringList(key, existing);
  }

  /// Supprime un avis par son id (soft-delete côté liste).
  Future<void> deleteReview(String destinationId, String reviewId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(destinationId);
    final existing = prefs.getStringList(key) ?? [];
    existing.removeWhere((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return map['id'] == reviewId;
    });
    await prefs.setStringList(key, existing);
  }
}
