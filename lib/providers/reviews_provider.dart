// NOTE : Provider Riverpod gérant les avis d'une destination.
// Concept mis en avant : AsyncNotifierProvider.family — chaque destinationId a son état isolé.
// Compatible Riverpod ^2.5.1.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/review_repository.dart';
import '../models/review.dart';

// --- Repository provider ---------------------------------------------------

final reviewRepositoryProvider = Provider<ReviewRepository>(
  (ref) => ReviewRepository(),
);

// --- FamilyAsyncNotifier ---------------------------------------------------

/// Notifier par destination (arg = destinationId).
class ReviewsNotifier extends FamilyAsyncNotifier<List<Review>, String> {
  late final String _destinationId;

  ReviewRepository get _repo => ref.read(reviewRepositoryProvider);

  @override
  Future<List<Review>> build(String arg) async {
    _destinationId = arg;
    return _repo.getForDestination(_destinationId);
  }

  /// Ajoute un avis et rafraîchit l'état localement.
  Future<void> addReview(Review review) async {
    await _repo.addReview(review);
    state = AsyncData([review, ...state.valueOrNull ?? []]);
  }

  /// Supprime un avis de l'utilisateur local.
  Future<void> deleteReview(String reviewId) async {
    await _repo.deleteReview(_destinationId, reviewId);
    state = AsyncData(
      (state.valueOrNull ?? []).where((r) => r.id != reviewId).toList(),
    );
  }
}

// --- Provider.family -------------------------------------------------------

/// Crée (ou récupère) un notifier par destinationId.
final reviewsProvider =
    AsyncNotifierProvider.family<ReviewsNotifier, List<Review>, String>(
  ReviewsNotifier.new,
);

// --- Providers dérivés -----------------------------------------------------

/// Note moyenne calculée à partir des avis chargés.
final averageRatingProvider = Provider.family<double, String>((ref, destId) {
  final reviews = ref.watch(reviewsProvider(destId)).valueOrNull ?? [];
  if (reviews.isEmpty) return 0.0;
  return reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
});
