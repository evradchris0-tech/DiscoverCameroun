// NOTE : Écran listant les destinations mises en favoris par l'utilisateur.
// Concept mis en avant : ConsumerWidget qui réagit automatiquement au provider de favoris.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/destination_card.dart';
import 'detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favoritesAsync = ref.watch(favoriteDestinationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.favoritesEmptyTitle,
                    style: AppTypography.emptyTitle.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.favoritesEmptyHint,
                    textAlign: TextAlign.center,
                    style: AppTypography.emptySubtitle
                        .copyWith(color: Colors.grey.shade400),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(
                top: AppSpacing.sm, bottom: AppSpacing.xxl),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final dest = favorites[index];
              return DestinationCard(
                destination: dest,
                onTap: (_) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailScreen(destination: dest)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
