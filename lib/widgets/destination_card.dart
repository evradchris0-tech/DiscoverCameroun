// NOTE : Widget réutilisable affichant une destination sous forme de carte dans la liste.
// Concept mis en avant : widget stateless avec Hero pour partager l'animation d'image avec DetailScreen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/destination_category.dart';
import '../models/destination.dart';
import '../providers/reviews_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/category_style.dart';
import 'smart_image.dart';

class DestinationCard extends ConsumerWidget {
  final Destination destination;
  final void Function(Destination) onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final avgRating = ref.watch(averageRatingProvider(destination.id));

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: Material(
        color: Colors.white,
        borderRadius: AppRadius.cardBorder,
        child: InkWell(
          onTap: () => onTap(destination),
          borderRadius: AppRadius.cardBorder,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.cardBorder,
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                _DestinationThumbnail(
                  source: destination.cover,
                  category: destination.category,
                  heroTag: 'hero-${destination.id}',
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, AppSpacing.sm, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination.name,
                          style: AppTypography.cardTitle,
                        ),
                        const SizedBox(height: AppSpacing.xxs),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.chip),
                              ),
                              child: Text(
                                destination.category.label,
                                style: AppTypography.badgeSmall,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                destination.region,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.cardMeta,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        Text(
                          destination.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.cardBody,
                        ),

                        // Note moyenne (si des avis existent)
                        if (avgRating > 0) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 12, color: AppColors.gold),
                              const SizedBox(width: 3),
                              Text(
                                avgRating.toStringAsFixed(1),
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationThumbnail extends StatelessWidget {
  final String source;
  final DestinationCategory category;
  final String heroTag;

  const _DestinationThumbnail({
    required this.source,
    required this.category,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: ClipRRect(
        borderRadius:
            const BorderRadius.horizontal(left: Radius.circular(AppRadius.card)),
        child: SmartImage(
          source: source,
          width: 110,
          height: 100,
          fallbackColor: category.color,
          fallbackIcon: category.icon,
        ),
      ),
    );
  }
}
