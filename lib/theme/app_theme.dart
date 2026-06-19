// NOTE : Assemblage du thème Material 3 à partir des design tokens.
// Concept mis en avant : un ThemeData unique qui consomme AppColors / AppTypography /
// AppRadius / AppSpacing — toute la cohérence visuelle découle d'ici.

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Fabrique du thème de l'application.
class AppTheme {
  AppTheme._();

  /// Thème clair (unique thème pour l'instant — un [darkTheme] pourra être ajouté ici).
  static ThemeData get light {
    final colorScheme = const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.gold,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.goldContainer,
      onSecondaryContainer: AppColors.onGoldContainer,
      surface: AppColors.surface,
      onSurface: AppColors.textDark,
      outline: AppColors.outline,
      shadow: AppColors.shadow,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      textTheme: AppTypography.baseTextTheme.copyWith(
        bodyLarge: AppTypography.sans(
            fontSize: 15, height: 1.6, color: AppColors.textDark),
        bodyMedium: AppTypography.sans(
            fontSize: 14, height: 1.5, color: AppColors.textMedium),
        bodySmall: AppTypography.sans(fontSize: 12, color: AppColors.textLight),
        labelMedium: AppTypography.sans(
            fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.serif(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          shape:
              RoundedRectangleBorder(borderRadius: AppRadius.buttonBorder),
          textStyle: AppTypography.sans(
              fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.3),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        // Texte BLANC quand le chip est sélectionné, foncé sinon.
        labelStyle: AppTypography.sans(
            fontSize: 13, fontWeight: FontWeight.w500).copyWith(
          color: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? Colors.white
                  : AppColors.textDark),
        ),
        secondaryLabelStyle: AppTypography.sans(
            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
        side: const BorderSide(color: AppColors.outline),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.chip)),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardBorder,
          side: const BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle:
            AppTypography.sans(color: AppColors.textLight, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: AppRadius.buttonBorder,
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.buttonBorder,
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonBorder,
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        backgroundColor: AppColors.surface,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 0,
      ),
    );
  }
}
