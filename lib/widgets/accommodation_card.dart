// NOTE : Hébergement — tuile compacte → fiche détaillée (adresse, équipements,
// itinéraire, appel, réservation) en bottom sheet.

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/accommodation.dart';
import '../models/booking_request.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'booking_sheet.dart';
import 'catalog_tile.dart';
import 'rating_stars.dart';
import 'route_info.dart';

class AccommodationCard extends StatelessWidget {
  final Accommodation accommodation;
  final String destinationName;

  const AccommodationCard(
      {super.key, required this.accommodation, this.destinationName = ''});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final a = accommodation;
    return CompactTile(
      leading: const CatalogIcon(icon: Icons.hotel),
      title: a.name,
      subtitle: Row(
        children: [
          RatingStars(rating: a.rating),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(a.type.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption),
          ),
        ],
      ),
      trailing: a.priceFrom == null
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatFcfa(a.priceFrom!),
                    style: AppTypography.sans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
                Text(l10n.labelPerNight, style: AppTypography.caption),
              ],
            ),
      onTap: () => showCatalogSheet(context,
          child: _AccommodationSheet(
              accommodation: a, destinationName: destinationName)),
    );
  }
}

class _AccommodationSheet extends StatelessWidget {
  final Accommodation accommodation;
  final String destinationName;

  const _AccommodationSheet(
      {required this.accommodation, required this.destinationName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final a = accommodation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(a.name, style: AppTypography.sectionTitle),
        const SizedBox(height: AppSpacing.xs),
        Row(children: [
          _TypePill(label: a.type.label),
          const SizedBox(width: AppSpacing.sm),
          RatingStars(rating: a.rating),
          const Spacer(),
          if (a.priceFrom != null)
            Text('${l10n.labelFrom} ${formatFcfa(a.priceFrom!)}',
                style: AppTypography.sans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
        ]),
        if (a.address.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Row(children: [
            const Icon(Icons.location_on, size: 14, color: AppColors.textLight),
            const SizedBox(width: AppSpacing.xxs),
            Expanded(child: Text(a.address, style: AppTypography.caption)),
          ]),
        ],
        if (a.amenities.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: a.amenities.map((m) => _Amenity(label: m)).toList(),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
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
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => showBookingSheet(
              context,
              type: BookingType.accommodation,
              itemName: a.name,
              destinationName: destinationName,
            ),
            icon: const Icon(Icons.bookmark_add_outlined, size: 16),
            label: Text(l10n.actionBook),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: AppRadius.buttonBorder),
            ),
          ),
        ),
      ],
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
