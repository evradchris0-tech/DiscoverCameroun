// NOTE : Échelle typographique (design tokens) — point unique du choix des polices.
// Concept mis en avant : découpler le RÔLE typographique (titre, corps, légende…)
// de son IMPLÉMENTATION (Playfair Display / Lato). Changer de police = un seul endroit.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Jetons typographiques de Discover Cameroon.
///
/// Deux familles :
///  - [serif] = Playfair Display, pour les titres (caractère « éditorial »).
///  - [sans]  = Lato, pour le corps et l'interface (lisibilité).
///
/// Règle d'or : aucun `GoogleFonts.xxx(...)` ne doit apparaître hors de ce fichier.
/// On utilise les rôles nommés (`AppTypography.cardTitle`, etc.) ou, à défaut,
/// les fabriques [serif] / [sans]. La couleur d'un rôle peut être surchargée
/// au point d'appel via `.copyWith(color: …)`.
class AppTypography {
  AppTypography._();

  // --- Fabriques de familles (chokepoint unique du choix de police) -------

  /// Police à empattements (titres). Wrapper unique de Playfair Display.
  static TextStyle serif({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontStyle: fontStyle,
    );
  }

  /// Police sans empattements (corps + interface). Wrapper unique de Lato.
  static TextStyle sans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontStyle: fontStyle,
    );
  }

  /// TextTheme de base dérivé de Playfair Display (utilisé par le ThemeData).
  static TextTheme get baseTextTheme => GoogleFonts.playfairDisplayTextTheme();

  // --- Rôles à empattements (Playfair Display) ----------------------------

  /// Titre de marque de l'écran de démarrage (« Discover » / « Cameroon »).
  /// Couleur à fournir au point d'appel.
  static TextStyle get splashTitle =>
      serif(fontSize: 42, fontWeight: FontWeight.w700, letterSpacing: 1);

  /// Grand titre de contenu (en-tête d'accueil, nom de destination).
  /// Couleur à fournir au point d'appel (blanc sur en-tête, foncé sur détail).
  static TextStyle get headingLarge =>
      serif(fontSize: 26, fontWeight: FontWeight.w700, height: 1.2);

  /// Titre de section (« À propos », « Activités », « Localisation »).
  static TextStyle get sectionTitle => serif(
      fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark);

  /// Titre de carte de destination.
  static TextStyle get cardTitle => serif(
      fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark);

  /// Titre de boîte de dialogue.
  static TextStyle get dialogTitle => serif(fontWeight: FontWeight.w700);

  // --- Rôles sans empattements (Lato) -------------------------------------

  /// Sur-titre / « eyebrow » (ex. « GUIDE TOURISTIQUE »).
  /// Couleur à fournir au point d'appel.
  static TextStyle get eyebrow =>
      sans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5);

  /// Sous-titre posé sur l'en-tête vert. Couleur à fournir au point d'appel.
  static TextStyle get heroSubtitle => sans(fontSize: 13);

  /// Texte saisi dans le champ de recherche.
  static TextStyle get searchInput =>
      sans(fontSize: 14, color: AppColors.textDark);

  /// Légende / compteur discret.
  static TextStyle get caption => sans(
      fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textLight);

  /// Petit badge de catégorie (sur la carte de destination).
  static TextStyle get badgeSmall => sans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.3,
      color: AppColors.primary);

  /// Métadonnée discrète d'une carte (région).
  static TextStyle get cardMeta =>
      sans(fontSize: 11, color: AppColors.textLight);

  /// Description résumée d'une carte (2 lignes).
  static TextStyle get cardBody =>
      sans(fontSize: 12, height: 1.5, color: AppColors.textMedium);

  /// Métadonnée d'en-tête de détail (région, altitude).
  static TextStyle get meta => sans(
      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textMedium);

  /// Paragraphe de contenu (description complète).
  static TextStyle get bodyText =>
      sans(fontSize: 14, height: 1.8, color: AppColors.textMedium);

  /// Étiquette de chip d'activité.
  static TextStyle get chipLabel => sans(
      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary);

  /// Badge de catégorie (en-tête de la page détail).
  static TextStyle get badge => sans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      color: Colors.white);

  /// Étiquette de marqueur sur la carte.
  static TextStyle get marker =>
      sans(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white);

  /// Slogan de l'écran de démarrage. Couleur à fournir au point d'appel.
  static TextStyle get tagline => sans(fontSize: 14, letterSpacing: 1.5);

  /// Titre d'état vide. Couleur à fournir au point d'appel.
  static TextStyle get emptyTitle => sans(fontSize: 15);

  /// Sous-titre d'état vide. Couleur à fournir au point d'appel.
  static TextStyle get emptySubtitle => sans(fontSize: 13);
}
