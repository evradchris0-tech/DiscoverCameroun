// NOTE : Onglet « Découvrir » — regroupe Expériences, Hôtels, Restaurants et Guides
// sous un TabBar, pour garder la barre de navigation épurée.
// Concept mis en avant : DefaultTabController + vues qui consomment les providers globaux.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/catalog_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/accommodation_card.dart';
import '../widgets/guide_card.dart';
import '../widgets/restaurant_card.dart';
import 'experiences_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navDiscover),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColors.gold,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: l10n.experiencesTitle),
              Tab(text: l10n.tabHotels),
              Tab(text: l10n.tabRestaurants),
              Tab(text: l10n.tabGuides),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ExperiencesView(),
            _AccommodationsView(),
            _RestaurantsView(),
            _GuidesView(),
          ],
        ),
      ),
    );
  }
}

class _AccommodationsView extends ConsumerWidget {
  const _AccommodationsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref.watch(accommodationsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (list) => list.isEmpty
              ? _Empty(text: l10n.accommodationsEmpty)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
                  children:
                      list.map((a) => AccommodationCard(accommodation: a)).toList(),
                ),
        );
  }
}

class _RestaurantsView extends ConsumerWidget {
  const _RestaurantsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref.watch(restaurantsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (list) => list.isEmpty
              ? _Empty(text: l10n.restaurantsEmpty)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
                  children:
                      list.map((r) => RestaurantCard(restaurant: r)).toList(),
                ),
        );
  }
}

class _GuidesView extends ConsumerWidget {
  const _GuidesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref.watch(guidesProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (list) => list.isEmpty
              ? _Empty(text: l10n.guidesEmpty)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
                  children: list.map((g) => GuideCard(guide: g)).toList(),
                ),
        );
  }
}

class _Empty extends StatelessWidget {
  final String text;
  const _Empty({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(text,
            textAlign: TextAlign.center,
            style: AppTypography.emptyTitle.copyWith(color: AppColors.textLight)),
      ),
    );
  }
}
