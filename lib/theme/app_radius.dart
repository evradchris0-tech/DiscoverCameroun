// NOTE : Échelle de rayons d'arrondi (design tokens) pour des coins homogènes.
// Concept mis en avant : nommer les rayons par usage plutôt que par valeur brute.

import 'package:flutter/widgets.dart';

/// Jetons de rayon de Discover Cameroon.
///
/// On référence `AppRadius.card` plutôt que `16`, ce qui rend l'intention
/// explicite et garantit qu'une carte et une mini-carte partagent le même arrondi.
class AppRadius {
  AppRadius._();

  /// 2 px — petites barres d'accent (filet décoratif, séparateur fin).
  static const double indicator = 2;

  /// 3 px — pastilles d'indicateur de page (galerie).
  static const double dot = 3;

  /// 8 px — petits éléments (étiquette de marqueur de carte).
  static const double sm = 8;

  /// 10 px — éléments flottants courts (snackbar).
  static const double snackbar = 10;

  /// 12 px — boutons et champs de saisie.
  static const double button = 12;

  /// 16 px — cartes, feuilles et mini-cartes.
  static const double card = 16;

  /// 20 px — chips et badges (forme « pilule » douce).
  static const double chip = 20;

  /// 24 px — éléments entièrement arrondis (bouton « j'aime »).
  static const double pill = 24;

  // --- Raccourcis pratiques ----------------------------------------------
  /// `BorderRadius.circular(AppRadius.card)` prêt à l'emploi.
  static BorderRadius get cardBorder => BorderRadius.circular(card);

  /// `BorderRadius.circular(AppRadius.button)` prêt à l'emploi.
  static BorderRadius get buttonBorder => BorderRadius.circular(button);

  /// `BorderRadius.circular(AppRadius.button)` pour les champs de saisie.
  static BorderRadius get inputBorder => BorderRadius.circular(button);
}
