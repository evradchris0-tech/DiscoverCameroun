// NOTE : Squelettes de chargement (effet shimmer) — remplacent les roues qui tournent.
// Concept mis en avant : placeholders animés cohérents avec le Design System.

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Bloc shimmer arrondi (brique de base).
class Skeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const Skeleton({super.key, this.width, this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.outlineVariant,
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.outlineVariant,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Squelette d'une carte « séjour » (vignette + lignes) pour l'accueil.
class StayCardSkeleton extends StatelessWidget {
  const StayCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.cardBorder,
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            const Skeleton(width: 120, height: 110, radius: AppRadius.card),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Skeleton(width: 80, height: 16, radius: AppRadius.chip),
                  SizedBox(height: AppSpacing.sm),
                  Skeleton(width: 180, height: 14),
                  SizedBox(height: AppSpacing.xs),
                  Skeleton(width: 120, height: 12),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

/// Squelette d'une tuile compacte (vignette carrée + 2 lignes) pour Découvrir.
class TileSkeleton extends StatelessWidget {
  const TileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: const [
          Skeleton(width: 48, height: 48, radius: AppRadius.sm),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Skeleton(width: 140, height: 15),
                SizedBox(height: AppSpacing.sm),
                Skeleton(width: 90, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Liste de squelettes (n éléments) pour un état de chargement.
class SkeletonList extends StatelessWidget {
  final int count;
  final Widget item;

  const SkeletonList({super.key, this.count = 5, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: List.generate(count, (_) => item),
    );
  }
}
