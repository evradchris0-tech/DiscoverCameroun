// NOTE : Section « Avis & Notes » affichée en bas de DetailScreen.
// Concept mis en avant : AsyncValue Riverpod pattern (loading / error / data)
// + carte résumé avec barres de répartition animées + bouton CTA rédaction.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/review.dart';
import '../providers/reviews_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'review_card.dart';
import 'write_review_sheet.dart';

class DestinationReviews extends ConsumerWidget {
  final String destinationId;
  final String destinationName;

  const DestinationReviews({
    super.key,
    required this.destinationId,
    required this.destinationName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(reviewsProvider(destinationId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Avis & Notes', style: AppTypography.sectionTitle),
            TextButton.icon(
              onPressed: () => showWriteReviewSheet(
                context,
                ref,
                destinationId: destinationId,
                destinationName: destinationName,
              ),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Laisser un avis'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Contenu selon état Riverpod
        reviewsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Text('Erreur : $e', style: AppTypography.meta),
          data: (reviews) => reviews.isEmpty
              ? _EmptyReviews(
                  onWrite: () => showWriteReviewSheet(
                    context,
                    ref,
                    destinationId: destinationId,
                    destinationName: destinationName,
                  ),
                )
              : _ReviewsContent(
                  reviews: reviews,
                  destinationId: destinationId,
                  destinationName: destinationName,
                  ref: ref,
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Contenu quand des avis existent
// ---------------------------------------------------------------------------

class _ReviewsContent extends StatelessWidget {
  final List<Review> reviews;
  final String destinationId;
  final String destinationName;
  final WidgetRef ref;

  const _ReviewsContent({
    required this.reviews,
    required this.destinationId,
    required this.destinationName,
    required this.ref,
  });

  double get _average {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }

  int _countForStar(int star) =>
      reviews.where((r) => r.rating.round() == star).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carte résumé
        _RatingSummaryCard(
          average: _average,
          totalCount: reviews.length,
          countForStar: _countForStar,
        ),

        const SizedBox(height: AppSpacing.xl),

        // Liste des avis
        ...reviews.map((review) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: ReviewCard(
              review: review,
              onDelete: review.isLocal
                  ? () => ref
                      .read(reviewsProvider(destinationId).notifier)
                      .deleteReview(review.id)
                  : null,
            ),
          );
        }),

        // Bouton ajouter un autre avis
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => showWriteReviewSheet(
              context,
              ref,
              destinationId: destinationId,
              destinationName: destinationName,
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Ajouter un avis'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonBorder),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Carte résumé note globale
// ---------------------------------------------------------------------------

class _RatingSummaryCard extends StatelessWidget {
  final double average;
  final int totalCount;
  final int Function(int) countForStar;

  const _RatingSummaryCard({
    required this.average,
    required this.totalCount,
    required this.countForStar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.cardBorder,
      ),
      child: Row(
        children: [
          // Score numérique + étoiles + compteur
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                average.toStringAsFixed(1),
                style: AppTypography.sans(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: List.generate(5, (i) {
                  final filled = average >= i + 1;
                  final half = !filled && average >= i + 0.5;
                  return Icon(
                    filled
                        ? Icons.star
                        : half
                            ? Icons.star_half
                            : Icons.star_border,
                    size: 16,
                    color: AppColors.gold,
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '$totalCount avis',
                style: AppTypography.sans(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(width: AppSpacing.xxl),

          // Barres de répartition (5 → 1 étoiles)
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final count = countForStar(star);
                final fraction =
                    totalCount > 0 ? count / totalCount : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style:
                            AppTypography.sans(fontSize: 11, color: Colors.white70),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, size: 10, color: AppColors.gold),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: fraction,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.gold),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// État vide (aucun avis)
// ---------------------------------------------------------------------------

class _EmptyReviews extends StatelessWidget {
  final VoidCallback onWrite;

  const _EmptyReviews({required this.onWrite});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          const Icon(Icons.chat_bubble_outline,
              size: 48, color: AppColors.outline),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Aucun avis pour le moment',
            style: AppTypography.bodyText.copyWith(
                fontWeight: FontWeight.w600, color: AppColors.textDark),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Soyez le premier à partager votre expérience !',
            style: AppTypography.meta,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: onWrite,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Écrire un avis'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonBorder),
            ),
          ),
        ],
      ),
    );
  }
}
