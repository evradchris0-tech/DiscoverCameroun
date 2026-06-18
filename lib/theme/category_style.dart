// NOTE : Style visuel (icône + couleur) associé à chaque catégorie de destination.
// Concept mis en avant : centraliser le mapping catégorie → apparence dans le Design System,
// avec des icônes Material (pas d'emojis) réutilisables partout (carte, cartes, badges).

import 'package:flutter/material.dart';

import '../enums/destination_category.dart';
import 'app_colors.dart';

extension DestinationCategoryStyle on DestinationCategory {
  /// Icône Material représentant la catégorie.
  IconData get icon {
    switch (this) {
      case DestinationCategory.plage:
        return Icons.beach_access;
      case DestinationCategory.montagne:
        return Icons.terrain;
      case DestinationCategory.ville:
        return Icons.location_city;
      case DestinationCategory.foret:
        return Icons.forest;
      case DestinationCategory.parc:
        return Icons.pets;
    }
  }

  /// Couleur d'accent de la catégorie (jeton du Design System).
  Color get color {
    switch (this) {
      case DestinationCategory.plage:
        return AppColors.catPlage;
      case DestinationCategory.montagne:
        return AppColors.catMontagne;
      case DestinationCategory.ville:
        return AppColors.catVille;
      case DestinationCategory.foret:
        return AppColors.catForet;
      case DestinationCategory.parc:
        return AppColors.catParc;
    }
  }
}
