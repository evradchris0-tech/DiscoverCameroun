// NOTE : Onglet « Découvrir » — Expériences, Hôtels, Restaurants, Guides sous un
// TabBar, avec une barre de recherche partagée qui filtre l'onglet actif.
// Concept mis en avant : StatefulWidget (requête locale) + vues filtrées.

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

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navDiscover),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(106),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    style: AppTypography.searchInput,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: l10n.searchGeneric,
                      prefixIcon: const Icon(Icons.search,
                          color: AppColors.textLight, size: 20),
                    ),
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
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
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ExperiencesView(query: _query),
            _AccommodationsView(query: _query),
            _RestaurantsView(query: _query),
            _GuidesView(query: _query),
          ],
        ),
      ),
    );
  }
}

class _AccommodationsView extends ConsumerWidget {
  final String query;
  const _AccommodationsView({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final q = query.trim().toLowerCase();
    return ref.watch(accommodationsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (all) {
            final list = q.isEmpty
                ? all
                : all.where((a) => a.name.toLowerCase().contains(q)).toList();
            return list.isEmpty
                ? _Empty(text: l10n.accommodationsEmpty)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg,
                        AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
                    children: list
                        .map((a) => AccommodationCard(accommodation: a))
                        .toList(),
                  );
          },
        );
  }
}

class _RestaurantsView extends ConsumerWidget {
  final String query;
  const _RestaurantsView({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final q = query.trim().toLowerCase();
    return ref.watch(restaurantsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (all) {
            final list = q.isEmpty
                ? all
                : all.where((r) => r.name.toLowerCase().contains(q)).toList();
            return list.isEmpty
                ? _Empty(text: l10n.restaurantsEmpty)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg,
                        AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
                    children: list
                        .map((r) => RestaurantCard(restaurant: r))
                        .toList(),
                  );
          },
        );
  }
}

class _GuidesView extends ConsumerWidget {
  final String query;
  const _GuidesView({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final q = query.trim().toLowerCase();
    return ref.watch(guidesProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (all) {
            final list = q.isEmpty
                ? all
                : all.where((g) => g.name.toLowerCase().contains(q)).toList();
            return list.isEmpty
                ? _Empty(text: l10n.guidesEmpty)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg,
                        AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
                    children:
                        list.map((g) => GuideCard(guide: g)).toList(),
                  );
          },
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
