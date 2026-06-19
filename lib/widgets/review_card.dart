// NOTE : Widget affichant un avis unique avec avatar auto-généré, étoiles et date.
// Concept mis en avant : design token uniquement (aucune couleur/taille codée en dur).

import 'package:flutter/material.dart';

import '../models/review.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onDelete; // null = pas de bouton supprimer

  const ReviewCard({super.key, required this.review, this.onDelete});

  /// Génère une couleur d'avatar cohérente à partir du nom de l'auteur.
  Color _avatarColor(String name) {
    const palette = [
      Color(0xFF1A3C34), // vert forêt
      Color(0xFFC8973A), // or
      Color(0xFF2A9D8F), // turquoise
      Color(0xFF9C6B3F), // terre
      Color(0xFF577590), // ardoise
      Color(0xFF2D6A4F), // vert clair
    ];
    final index = name.codeUnits.fold(0, (a, b) => a + b) % palette.length;
    return palette[index];
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
      'jul', 'aoû', 'sep', 'oct', 'nov', 'déc',
    ];
    return '${dt.day} ${months[dt.month - 1]}. ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final color = _avatarColor(review.authorName);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : avatar + nom + date + (bouton supprimer)
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color,
                child: Text(
                  _initials(review.authorName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.authorName,
                            style: AppTypography.bodyText.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (review.isLocal)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.chip),
                            ),
                            child: Text(
                              'Moi',
                              style: AppTypography.meta.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(review.createdAt),
                      style: AppTypography.meta,
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      size: 18, color: AppColors.textLight),
                  tooltip: 'Supprimer',
                  onPressed: onDelete,
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Étoiles
          _StarRow(rating: review.rating),

          const SizedBox(height: AppSpacing.smPlus),

          // Commentaire
          Text(review.comment, style: AppTypography.bodyText),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ligne d'étoiles (demi-étoiles comprises)
// ---------------------------------------------------------------------------

class _StarRow extends StatelessWidget {
  final double rating; // 1.0 – 5.0

  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = rating >= i + 1;
        final halfFilled = !filled && rating >= i + 0.5;
        return Icon(
          filled
              ? Icons.star
              : halfFilled
                  ? Icons.star_half
                  : Icons.star_border,
          size: 18,
          color: AppColors.gold,
        );
      }),
    );
  }
}
