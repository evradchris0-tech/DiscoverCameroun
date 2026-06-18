// NOTE : Affichage compact d'une note (étoiles + valeur).
// Concept mis en avant : petit composant atomique réutilisé par toutes les cartes.

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class RatingStars extends StatelessWidget {
  final double rating; // 0..5
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    if (rating <= 0) {
      return Text(AppLocalizations.of(context).ratingNew,
          style: AppTypography.caption);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          final filled = i < rating.floor();
          final half = !filled && i < rating;
          return Icon(
            half
                ? Icons.star_half
                : (filled ? Icons.star : Icons.star_border),
            size: size,
            color: AppColors.gold,
          );
        }),
        const SizedBox(width: AppSpacing.xxs),
        Text(rating.toStringAsFixed(1),
            style: AppTypography.sans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMedium)),
      ],
    );
  }
}
