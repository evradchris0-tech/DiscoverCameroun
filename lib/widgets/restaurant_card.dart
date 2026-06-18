// NOTE : Carte d'un restaurant à proximité (rubrique « restaurant »).
// Concept mis en avant : mise en avant des plats signatures + actions itinéraire/appel.

import 'package:flutter/material.dart';

import '../core/launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/restaurant.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'rating_stars.dart';
import 'route_info.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final r = restaurant;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name, style: AppTypography.cardTitle),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(children: [
                      RatingStars(rating: r.rating),
                      const SizedBox(width: AppSpacing.sm),
                      Text(r.priceRange,
                          style: AppTypography.sans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          if (r.cuisines.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(r.cuisines.join(' · '), style: AppTypography.caption),
          ],
          if (r.signatureDishes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: r.signatureDishes
                  .map((d) => _Dish(label: d))
                  .toList(),
            ),
          ],
          if (r.address.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              const Icon(Icons.location_on,
                  size: 14, color: AppColors.textLight),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(child: Text(r.address, style: AppTypography.caption)),
            ]),
          ],
          const SizedBox(height: AppSpacing.md),
          if (r.latitude != null && r.longitude != null)
            RouteInfo(lat: r.latitude!, lng: r.longitude!),
          Row(children: [
            if (r.latitude != null && r.longitude != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => AppLauncher.openDirections(
                      r.latitude!, r.longitude!,
                      label: r.name),
                  icon: const Icon(Icons.directions, size: 16),
                  label: Text(l10n.actionDirections),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.buttonBorder),
                  ),
                ),
              ),
            if (r.phone != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => AppLauncher.call(r.phone!),
                  icon: const Icon(Icons.call, size: 16),
                  label: Text(l10n.actionCall),
                ),
              ),
            ],
          ]),
        ],
      ),
    );
  }
}

class _Dish extends StatelessWidget {
  final String label;
  const _Dish({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.goldContainer,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(label,
          style: AppTypography.sans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.onGoldContainer)),
    );
  }
}
