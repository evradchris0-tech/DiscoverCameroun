// NOTE : Liste complète des destinations (depuis « Voir tout » des séjours populaires).
// Concept mis en avant : réutilise filteredDestinationsProvider + PopularStayCard.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/destination.dart';
import '../providers/destinations_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/popular_stay_card.dart';
import 'detail_screen.dart';

class AllDestinationsScreen extends ConsumerWidget {
  const AllDestinationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(filteredDestinationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.allDestinationsTitle)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) => list.isEmpty
            ? Center(
                child: Text(l10n.emptyNoDestinations,
                    style: AppTypography.emptyTitle
                        .copyWith(color: AppColors.textLight)),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: list.length,
                itemBuilder: (context, i) => PopularStayCard(
                  destination: list[i],
                  onTap: (d) => _openDetail(context, d),
                ),
              ),
      ),
    );
  }

  void _openDetail(BuildContext context, Destination d) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(destination: d)),
    );
  }
}
