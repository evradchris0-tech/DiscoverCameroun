// NOTE : Carte d'un hébergement à proximité (rubrique « hébergement »).
// Concept mis en avant : actions « itinéraire » et « appeler » via AppLauncher.

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/accommodation.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'rating_stars.dart';
import 'route_info.dart';

class AccommodationCard extends StatelessWidget {
  final Accommodation accommodation;

  const AccommodationCard({super.key, required this.accommodation});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final a = accommodation;
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
                    Text(a.name, style: AppTypography.cardTitle),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(children: [
                      _TypePill(label: a.type.label),
                      const SizedBox(width: AppSpacing.sm),
                      RatingStars(rating: a.rating),
                    ]),
                  ],
                ),
              ),
              if (a.priceFrom != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(l10n.labelFrom, style: AppTypography.caption),
                    Text(formatFcfa(a.priceFrom!),
                        style: AppTypography.sans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                    Text(l10n.labelPerNight, style: AppTypography.caption),
                  ],
                ),
            ],
          ),
          if (a.address.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              const Icon(Icons.location_on,
                  size: 14, color: AppColors.textLight),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(child: Text(a.address, style: AppTypography.caption)),
            ]),
          ],
          if (a.amenities.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children:
                  a.amenities.map((m) => _Amenity(label: m)).toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (a.latitude != null && a.longitude != null)
            RouteInfo(lat: a.latitude!, lng: a.longitude!),
          Row(children: [
            if (a.latitude != null && a.longitude != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => AppLauncher.openDirections(
                      a.latitude!, a.longitude!,
                      label: a.name),
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
            if (a.phone != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => AppLauncher.call(a.phone!),
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

class _TypePill extends StatelessWidget {
  final String label;
  const _TypePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(label, style: AppTypography.badgeSmall),
    );
  }
}

class _Amenity extends StatelessWidget {
  final String label;
  const _Amenity({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(label, style: AppTypography.caption),
    );
  }
}
