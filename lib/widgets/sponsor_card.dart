// NOTE : Carte d'un partenaire / sponsor (bandeau horizontal de l'accueil).

import 'package:flutter/material.dart';

import '../models/sponsor.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'smart_image.dart';

class SponsorCard extends StatelessWidget {
  final Sponsor sponsor;
  const SponsorCard({super.key, required this.sponsor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.card)),
            child: SmartImage(
              source: sponsor.imageUrl ?? '',
              width: 240,
              height: 104,
              fallbackColor: AppColors.primary,
              fallbackIcon: Icons.business,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.goldContainer,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Text(
                    sponsor.category.toUpperCase(),
                    style: AppTypography.sans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: AppColors.onGoldContainer),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(sponsor.name, style: AppTypography.cardTitle),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  sponsor.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
