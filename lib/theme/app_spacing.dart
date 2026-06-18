// NOTE : Échelle d'espacement (design tokens) pour des marges/paddings cohérents.
// Concept mis en avant : remplacer les valeurs « magiques » (8, 12, 16…) par une échelle nommée.

/// Jetons d'espacement de Discover Cameroon.
///
/// Utilisés pour les `SizedBox`, `EdgeInsets`, etc. afin que les rythmes
/// verticaux/horizontaux restent homogènes dans toute l'application.
///
/// NB : l'échelle reflète les valeurs réellement employées aujourd'hui.
/// Une normalisation stricte sur une base 4/8 pt pourra être faite plus tard.
class AppSpacing {
  AppSpacing._();

  /// 4 px — micro-espacement (entre une icône et son label).
  static const double xxs = 4;

  /// 6 px — très petit espacement.
  static const double xs = 6;

  /// 8 px — petit espacement (gouttière de chips).
  static const double sm = 8;

  /// 10 px — petit espacement intermédiaire.
  static const double smPlus = 10;

  /// 12 px — espacement par défaut entre éléments proches.
  static const double md = 12;

  /// 16 px — espacement standard (padding d'écran horizontal).
  static const double lg = 16;

  /// 20 px — espacement large (padding de contenu, marge de section).
  static const double xl = 20;

  /// 24 px — séparation entre sections.
  static const double xxl = 24;

  /// 32 px — grande séparation (bas de page).
  static const double xxxl = 32;

  /// 60 px — espacement décoratif (écran de démarrage).
  static const double huge = 60;
}
