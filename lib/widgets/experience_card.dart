// NOTE : Expérience — tuile compacte → fiche détaillée (image, description,
// durée, prix, réservation) en bottom sheet.

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../models/booking_request.dart';
import '../models/tourist_experience.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'booking_sheet.dart';
import 'catalog_tile.dart';
import 'smart_image.dart';

IconData _experienceIcon(ExperienceType type) {
  switch (type) {
    case ExperienceType.culinaire:
      return Icons.restaurant_menu;
    case ExperienceType.peinture:
      return Icons.palette;
    case ExperienceType.atelierVannerie:
      return Icons.shopping_basket;
    case ExperienceType.artisanat:
      return Icons.handyman;
    case ExperienceType.danse:
      return Icons.music_note;
    case ExperienceType.musique:
      return Icons.library_music;
    case ExperienceType.nature:
      return Icons.forest;
  }
}

class ExperienceCard extends StatelessWidget {
  final TouristExperience experience;
  final String destinationName;

  const ExperienceCard(
      {super.key, required this.experience, this.destinationName = ''});

  @override
  Widget build(BuildContext context) {
    final e = experience;
    final meta = e.duration != null
        ? '${e.type.label} · ${e.duration}'
        : e.type.label;
    return CompactTile(
      leading: CatalogIcon(icon: _experienceIcon(e.type), color: AppColors.gold),
      title: e.title,
      subtitle: Text(meta,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.caption),
      trailing: e.price == null
          ? null
          : Text(formatFcfa(e.price!),
              style: AppTypography.sans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
      onTap: () => showCatalogSheet(context,
          child: _ExperienceSheet(
              experience: e, destinationName: destinationName)),
    );
  }
}

class _ExperienceSheet extends StatelessWidget {
  final TouristExperience experience;
  final String destinationName;

  const _ExperienceSheet(
      {required this.experience, required this.destinationName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final e = experience;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (e.photoPaths.isNotEmpty)
          ClipRRect(
            borderRadius: AppRadius.cardBorder,
            child: SmartImage(
              source: e.photoPaths.first,
              width: double.infinity,
              height: 150,
              fallbackColor: AppColors.primary,
              fallbackIcon: _experienceIcon(e.type),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
          child: Text(e.type.label, style: AppTypography.badge),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(e.title, style: AppTypography.sectionTitle),
        const SizedBox(height: AppSpacing.xs),
        Row(children: [
          if (e.duration != null) ...[
            const Icon(Icons.schedule, size: 14, color: AppColors.textLight),
            const SizedBox(width: AppSpacing.xxs),
            Text(e.duration!, style: AppTypography.caption),
            const SizedBox(width: AppSpacing.md),
          ],
          if (e.price != null)
            Text(formatFcfa(e.price!),
                style: AppTypography.sans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
        ]),
        if (e.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(e.description, style: AppTypography.bodyText),
        ],
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => showBookingSheet(
              context,
              type: BookingType.experience,
              itemName: e.title,
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
