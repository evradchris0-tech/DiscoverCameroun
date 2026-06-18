// NOTE : Carte « Séjour populaire » — accroche commerciale d'une destination
// (titre d'accroche, durée, prix d'appel) avec activités dépliables.
// Concept mis en avant : StatefulWidget pour l'expansion + SmartImage (réseau/asset).

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../enums/destination_category.dart';
import '../l10n/app_localizations.dart';
import '../models/destination.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/category_style.dart';
import 'smart_image.dart';

class PopularStayCard extends StatefulWidget {
  final Destination destination;
  final void Function(Destination) onTap;

  const PopularStayCard(
      {super.key, required this.destination, required this.onTap});

  @override
  State<PopularStayCard> createState() => _PopularStayCardState();
}

class _PopularStayCardState extends State<PopularStayCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final d = widget.destination;
    final hasActivities = d.activities.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardBorder,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => widget.onTap(d),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.card)),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Cover(destination: d),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _CategoryBadge(destination: d),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                d.titreAccroche ?? d.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.cardTitle,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              if (d.duree != null)
                                Row(children: [
                                  const Icon(Icons.schedule,
                                      size: 14, color: AppColors.textLight),
                                  const SizedBox(width: AppSpacing.xxs),
                                  Text(d.duree!, style: AppTypography.caption),
                                ]),
                              if (d.prixAppel != null) ...[
                                const SizedBox(height: 2),
                                Text.rich(TextSpan(
                                  style: AppTypography.caption,
                                  children: [
                                    TextSpan(
                                        text: l10n.priceFrom(''),
                                        style: AppTypography.caption),
                                    TextSpan(
                                      text: formatFcfa(d.prixAppel!),
                                      style: AppTypography.sans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary),
                                    ),
                                  ],
                                )),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (hasActivities) ...[
                const Divider(height: 1),
                InkWell(
                  onTap: () => setState(() => _expanded = !_expanded),
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppRadius.card)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(Icons.local_activity_outlined,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(l10n.sectionActivities,
                            style: AppTypography.sans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        const Spacer(),
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0,
                        AppSpacing.md, AppSpacing.md),
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: d.activities
                          .map((a) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.chip),
                                ),
                                child:
                                    Text(a, style: AppTypography.chipLabel),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final Destination destination;
  const _Cover({required this.destination});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.horizontal(left: Radius.circular(AppRadius.card)),
      child: SizedBox(
        width: 120,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'hero-${destination.id}',
              child: SmartImage(
                source: destination.cover,
                fallbackColor: destination.category.color,
                fallbackIcon: destination.category.icon,
              ),
            ),
            // Dégradé + nom en surimpression (bas de l'image).
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.textDark.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                child: Text(
                  destination.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.sans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final Destination destination;
  const _CategoryBadge({required this.destination});

  @override
  Widget build(BuildContext context) {
    final cat = destination.category;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: cat.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(cat.icon, size: 12, color: cat.color),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            cat.label.toUpperCase(),
            style: AppTypography.sans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: cat.color),
          ),
        ],
      ),
    );
  }
}
