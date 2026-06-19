// NOTE : Carte d'une expérience touristique (culinaire, peinture, atelier paniers mboa…).
// Concept mis en avant : composant réutilisable avec image d'en-tête + badge de type.

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../models/booking_request.dart';
import '../models/tourist_experience.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'booking_sheet.dart';
import 'smart_image.dart';

class ExperienceCard extends StatelessWidget {
  final TouristExperience experience;
  final String destinationName;

  const ExperienceCard({
    super.key,
    required this.experience,
    this.destinationName = '',
  });

  IconData get _icon {
    switch (experience.type) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 130,
                width: double.infinity,
                child: experience.photoPaths.isNotEmpty
                    ? SmartImage(
                        source: experience.photoPaths.first,
                        width: double.infinity,
                        height: 130,
                        fallbackColor: AppColors.primary,
                        fallbackIcon: Icons.image_outlined,
                      )
                    : _fallback(),
              ),
              Positioned(
                left: AppSpacing.sm,
                top: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Text(experience.type.label,
                      style: AppTypography.badge),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(experience.title, style: AppTypography.cardTitle),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    if (experience.duration != null) ...[
                      const Icon(Icons.schedule,
                          size: 14, color: AppColors.textLight),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(experience.duration!,
                          style: AppTypography.caption),
                      const SizedBox(width: AppSpacing.md),
                    ],
                    if (experience.price != null)
                      Text(formatFcfa(experience.price!),
                          style: AppTypography.sans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                  ],
                ),
                if (experience.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(experience.description,
                      style: AppTypography.cardBody),
                ],
                const SizedBox(height: AppSpacing.md),
                // Bouton Réserver
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => showBookingSheet(
                      context,
                      type: BookingType.experience,
                      itemName: experience.title,
                      destinationName: destinationName,
                    ),
                    icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                    label: const Text('Réserver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.buttonBorder),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.primary,
      alignment: Alignment.center,
      child: Icon(_icon, size: 48, color: Colors.white.withValues(alpha: 0.5)),
    );
  }
}
