// NOTE : Bottom-sheet modale de rédaction d'un avis.
// Concept mis en avant : StatefulWidget + ConsumerStatefulWidget + Form validation.
// Aucune dépendance uuid externe : id généré via timestamp + hashCode.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/review.dart';
import '../providers/reviews_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Ouvre la feuille de saisie d'avis et retourne true si un avis a été soumis.
Future<bool?> showWriteReviewSheet(
  BuildContext context,
  WidgetRef ref, {
  required String destinationId,
  required String destinationName,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _WriteReviewSheet(
      destinationId: destinationId,
      destinationName: destinationName,
      widgetRef: ref,
    ),
  );
}

// ---------------------------------------------------------------------------
// Sheet stateful (ConsumerStatefulWidget pour accéder à Riverpod)
// ---------------------------------------------------------------------------

class _WriteReviewSheet extends ConsumerStatefulWidget {
  final String destinationId;
  final String destinationName;
  final WidgetRef widgetRef; // ref du widget appelant (pour update immédiat)

  const _WriteReviewSheet({
    required this.destinationId,
    required this.destinationName,
    required this.widgetRef,
  });

  @override
  ConsumerState<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends ConsumerState<_WriteReviewSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  double _rating = 4.0;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  String _generateId() {
    final now = DateTime.now();
    return '${now.millisecondsSinceEpoch}-${widget.destinationId.hashCode.abs()}';
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);

    final review = Review(
      id: _generateId(),
      destinationId: widget.destinationId,
      authorName: _nameController.text.trim(),
      rating: _rating,
      comment: _commentController.text.trim(),
      createdAt: DateTime.now(),
      isLocal: true,
    );

    await ref
        .read(reviewsProvider(widget.destinationId).notifier)
        .addReview(review);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl + bottomPadding,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poignée de glissement
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Titre
              Text('Donner mon avis', style: AppTypography.headingMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.destinationName,
                style: AppTypography.meta.copyWith(color: AppColors.primary),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Sélecteur d'étoiles interactif
              _StarSelector(
                value: _rating,
                onChanged: (v) => setState(() => _rating = v),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Champ nom
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration('Votre prénom / pseudo'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Champ commentaire
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration('Votre expérience…'),
                validator: (v) => (v == null || v.trim().length < 10)
                    ? 'Minimum 10 caractères'
                    : null,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Bouton soumettre
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitting ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(_submitting ? 'Envoi…' : "Publier l'avis"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.smPlus),
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.buttonBorder),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.meta,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      border: OutlineInputBorder(
        borderRadius: AppRadius.inputBorder,
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputBorder,
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputBorder,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputBorder,
        borderSide: const BorderSide(color: AppColors.danger),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sélecteur d'étoiles interactif
// ---------------------------------------------------------------------------

class _StarSelector extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _StarSelector({required this.value, required this.onChanged});

  String _label(double v) {
    if (v >= 5) return 'Exceptionnel ✨';
    if (v >= 4) return 'Très bien 😊';
    if (v >= 3) return 'Bien 👍';
    if (v >= 2) return 'Passable 😐';
    return 'Décevant 😞';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Note',
            style: AppTypography.bodyText
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affichage numérique
            Text(
              value.toStringAsFixed(0),
              style: AppTypography.headingLarge.copyWith(
                color: AppColors.gold,
                fontSize: 36,
              ),
            ),
            const SizedBox(width: AppSpacing.xl),
            // 5 étoiles cliquables
            Row(
              children: List.generate(5, (i) {
                final starValue = (i + 1).toDouble();
                return GestureDetector(
                  onTap: () => onChanged(starValue),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                      value >= starValue ? Icons.star : Icons.star_border,
                      size: 36,
                      color: value >= starValue
                          ? AppColors.gold
                          : AppColors.outline,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Center(
          child: Text(
            _label(value),
            style: AppTypography.meta.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
