// NOTE : Saisons du Cameroun pour conseiller la meilleure période de visite.
// Concept mis en avant : enum typé + parsing tolérant depuis le JSON.

/// Saisons climatiques utilisées pour la rubrique « saison appropriée ».
enum Season {
  saisonSeche,
  petiteSaisonPluies,
  grandeSaisonPluies,
}

extension SeasonX on Season {
  /// Libellé affichable.
  String get label {
    switch (this) {
      case Season.saisonSeche:
        return 'Saison sèche';
      case Season.petiteSaisonPluies:
        return 'Petite saison des pluies';
      case Season.grandeSaisonPluies:
        return 'Grande saison des pluies';
    }
  }

  /// Période indicative (mois) — repère pour les voyageurs.
  String get months {
    switch (this) {
      case Season.saisonSeche:
        return 'Nov. – Févr.';
      case Season.petiteSaisonPluies:
        return 'Mars – Juin';
      case Season.grandeSaisonPluies:
        return 'Juil. – Oct.';
    }
  }

  /// Clé JSON stable (sérialisation).
  String get key {
    switch (this) {
      case Season.saisonSeche:
        return 'saison_seche';
      case Season.petiteSaisonPluies:
        return 'petite_saison_pluies';
      case Season.grandeSaisonPluies:
        return 'grande_saison_pluies';
    }
  }

  /// Parse une clé JSON en [Season] (défaut : saison sèche).
  static Season fromKey(String value) {
    return Season.values.firstWhere(
      (s) => s.key == value,
      orElse: () => Season.saisonSeche,
    );
  }
}
