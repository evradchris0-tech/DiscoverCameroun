// NOTE : Ce fichier liste les catégories possibles d'une destination sous forme d'enum.
// Concept mis en avant : enum typé + extension pour ajouter une méthode sans modifier le type d'origine.

enum DestinationCategory {
  plage,
  montagne,
  ville,
  foret,
  parc,
}

// L'extension permet d'ajouter des propriétés à un enum existant.
extension DestinationCategoryLabel on DestinationCategory {
  String get label {
    // Le switch sur un enum est exhaustif : Dart signale si j'oublie un cas.
    switch (this) {
      case DestinationCategory.plage:
        return 'Plage';
      case DestinationCategory.montagne:
        return 'Montagne';
      case DestinationCategory.ville:
        return 'Ville';
      case DestinationCategory.foret:
        return 'Forêt';
      case DestinationCategory.parc:
        return 'Parc naturel';
    }
  }
}
