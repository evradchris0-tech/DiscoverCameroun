// NOTE : Carte d'un guide touristique local avec actions de contact (appel / WhatsApp).
// Concept mis en avant : composant réutilisable + actions sortantes via AppLauncher.

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/booking_request.dart';
import '../models/tour_guide.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'booking_sheet.dart';
import 'rating_stars.dart';
import 'smart_image.dart';

class GuideCard extends StatelessWidget {
  final TourGuide guide;
  final String destinationName;

  const GuideCard({
    super.key,
    required this.guide,
    this.destinationName = '',
  });

  Future<void> _call(BuildContext context) async {
    final ok = await AppLauncher.call(guide.phone);
    if (!ok && context.mounted) {
      _toast(context, AppLocalizations.of(context).snackCallFailed);
    }
  }

  Future<void> _whatsapp(BuildContext context) async {
    final number = guide.whatsapp ?? guide.phone;
    final ok = await AppLauncher.whatsapp(number,
        message: 'Bonjour ${guide.name}, je vous contacte via KmerTour.');
    if (!ok && context.mounted) {
      _toast(context, AppLocalizations.of(context).snackWhatsappUnavailable);
    }
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              _Avatar(photoPath: guide.photoPath, name: guide.name),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(guide.name, style: AppTypography.cardTitle),
                    const SizedBox(height: AppSpacing.xxs),
                    RatingStars(rating: guide.rating),
                    if (guide.languages.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(guide.languages.join(' · '),
                          style: AppTypography.caption),
                    ],
                  ],
                ),
              ),
              if (guide.pricePerDay != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatFcfa(guide.pricePerDay!),
                        style: AppTypography.sans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                    Text(l10n.labelPerDay, style: AppTypography.caption),
                  ],
                ),
            ],
          ),
          if (guide.bio.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(guide.bio, style: AppTypography.cardBody),
          ],
          if (guide.specialties.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: guide.specialties
                  .map((s) => _Tag(label: s))
                  .toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _call(context),
                  icon: const Icon(Icons.call, size: 16),
                  label: Text(l10n.actionCall),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.buttonBorder),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _whatsapp(context),
                  icon: const Icon(Icons.chat, size: 16),
                  label: Text(l10n.actionWhatsApp),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Bouton Réserver un guide
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => showBookingSheet(
                context,
                type: BookingType.guide,
                itemName: guide.name,
                destinationName: destinationName,
              ),
              icon: const Icon(Icons.bookmark_add_outlined, size: 16),
              label: const Text('Réserver ce guide'),
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
    );
  }
}

class _Avatar extends StatelessWidget {
  final String photoPath;
  final String name;
  const _Avatar({required this.photoPath, required this.name});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: 56,
        height: 56,
        child: photoPath.isEmpty
            ? _initials()
            : SmartImage(
                source: photoPath,
                width: 56,
                height: 56,
                fallbackColor: AppColors.primaryContainer,
                fallbackIcon: Icons.person,
              ),
      ),
    );
  }

  Widget _initials() => Container(
        color: AppColors.primaryContainer,
        alignment: Alignment.center,
        child: Text(
          name.isNotEmpty ? name[0] : '?',
          style: AppTypography.serif(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primary),
        ),
      );
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

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
