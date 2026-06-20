// NOTE : Source de vérité UNIQUE des couleurs de l'application (design tokens).
// Concept mis en avant : centraliser la palette pour qu'aucune couleur ne soit écrite « en dur »
// ailleurs dans le code. Changer la marque ici se répercute partout.

import 'package:flutter/material.dart';

/// Jetons de couleur (« color tokens ») de Discover Cameroon.
///
/// Règle d'or : aucun `Color(0xFF…)` ne doit apparaître hors de ce fichier.
/// On référence toujours `AppColors.xxx` ou, mieux, `Theme.of(context).colorScheme.xxx`.
class AppColors {
  AppColors._();

  // --- Couleurs de marque -------------------------------------------------
  /// Vert forêt — couleur primaire (barres, boutons, accents principaux).
  static const Color primary = Color(0xFF1A3C34);

  /// Vert plus clair — utilisé pour les dégradés et la bordure de focus.
  static const Color primaryLight = Color(0xFF2D6A4F);

  /// Or — couleur secondaire (mises en avant, badges, accents premium).
  static const Color gold = Color(0xFFC8973A);

  // --- Surfaces -----------------------------------------------------------
  /// Crème — fond général de l'application.
  static const Color background = Color(0xFFF5F1EA);

  /// Blanc — surfaces (cartes, champs, barre de navigation).
  static const Color surface = Color(0xFFFFFFFF);

  // --- Conteneurs (variantes douces des couleurs de marque) ---------------
  /// Vert très clair — conteneur primaire (chips d'activité, puces).
  static const Color primaryContainer = Color(0xFFD0E8DC);

  /// Beige doré clair — conteneur secondaire.
  static const Color goldContainer = Color(0xFFFFF3E0);

  /// Brun doré foncé — texte/contenu posé sur le conteneur secondaire.
  static const Color onGoldContainer = Color(0xFF7A5A1A);

  // --- Texte --------------------------------------------------------------
  /// Texte principal (titres, contenu fort).
  static const Color textDark = Color(0xFF1A1A2E);

  /// Texte secondaire (paragraphes, descriptions).
  static const Color textMedium = Color(0xFF5A6470);

  /// Texte tertiaire (légendes, métadonnées discrètes).
  static const Color textLight = Color(0xFF9BA3AF);

  // --- Couleurs par catégorie de destination ------------------------------
  /// Plage — turquoise océan.
  static const Color catPlage = Color(0xFF2A9D8F);

  /// Montagne — terre/terracotta.
  static const Color catMontagne = Color(0xFF9C6B3F);

  /// Ville — ardoise.
  static const Color catVille = Color(0xFF577590);

  /// Forêt — vert (réutilise le vert clair de marque).
  static const Color catForet = primaryLight;

  /// Parc naturel — or savane (réutilise l'or de marque).
  static const Color catParc = gold;

  /// Bleu « ma position » (point GPS de l'utilisateur sur la carte).
  static const Color userLocation = Color(0xFF2F6FED);

  // --- WhatsApp (réservation / contact) -----------------------------------
  /// Vert de marque WhatsApp.
  static const Color whatsapp = Color(0xFF25D366);

  /// Fond vert clair pour les encarts WhatsApp.
  static const Color whatsappContainer = Color(0xFFE8F5E9);

  /// Texte vert foncé posé sur [whatsappContainer].
  static const Color onWhatsappContainer = Color(0xFF1B5E20);

  // --- États sémantiques --------------------------------------------------
  /// Rouge d'urgence/danger (contacts d'urgence, erreurs critiques).
  static const Color danger = Color(0xFFC0392B);

  /// Fond doux pour les éléments d'urgence/danger.
  static const Color dangerContainer = Color(0xFFFDECEA);

  // --- Contours & ombres --------------------------------------------------
  /// Contour standard (bordure de focus, séparateurs de composants).
  static const Color outline = Color(0xFFE0DDD6);

  /// Contour discret (bordure des cartes, lignes de séparation).
  static const Color outlineVariant = Color(0xFFF0EDE6);

  /// Ombre portée (10 % de noir).
  static const Color shadow = Color(0x1A000000);
}
