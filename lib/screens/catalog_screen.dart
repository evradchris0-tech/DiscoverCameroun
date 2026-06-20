// NOTE : Onglet « Découvrir » — Expériences, Hôtels, Restaurants, Guides sous un
// TabBar, avec recherche partagée + un filtre propre à chaque onglet.
// Concept mis en avant : vues à état local (requête + filtre) et chips réutilisables.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/accommodation.dart';
import '../providers/catalog_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/accommodation_card.dart';
import '../widgets/guide_card.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/skeleton.dart';
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

// --- Hôtels : filtre par type ---------------------------------------------
class _AccommodationsView extends ConsumerStatefulWidget {
  final String query;
  const _AccommodationsView({required this.query});

  @override
  ConsumerState<_AccommodationsView> createState() =>
      _AccommodationsViewState();
}

class _AccommodationsViewState extends ConsumerState<_AccommodationsView> {
  AccommodationType? _type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = widget.query.trim().toLowerCase();
    return ref.watch(accommodationsProvider).when(
          loading: () => const SkeletonList(item: TileSkeleton()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (all) {
            final types = all.map((a) => a.type).toSet().toList();
            final list = all.where((a) {
              final mq = q.isEmpty || a.name.toLowerCase().contains(q);
              final mt = _type == null || a.type == _type;
              return mq && mt;
            }).toList();
            return _Tab(
              filters: [
                _FilterItem(l10n.filterAll, _type == null,
                    () => setState(() => _type = null)),
                ...types.map((t) => _FilterItem(
                    t.label, _type == t, () => setState(() => _type = t))),
              ],
              emptyText: l10n.accommodationsEmpty,
              children: list
                  .map((a) => AccommodationCard(accommodation: a))
                  .toList(),
            );
          },
        );
  }
}

// --- Restaurants : filtre par cuisine -------------------------------------
class _RestaurantsView extends ConsumerStatefulWidget {
  final String query;
  const _RestaurantsView({required this.query});

  @override
  ConsumerState<_RestaurantsView> createState() => _RestaurantsViewState();
}

class _RestaurantsViewState extends ConsumerState<_RestaurantsView> {
  String? _cuisine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = widget.query.trim().toLowerCase();
    return ref.watch(restaurantsProvider).when(
          loading: () => const SkeletonList(item: TileSkeleton()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (all) {
            final cuisines = {for (final r in all) ...r.cuisines}.toList()
              ..sort();
            final list = all.where((r) {
              final mq = q.isEmpty || r.name.toLowerCase().contains(q);
              final mc = _cuisine == null || r.cuisines.contains(_cuisine);
              return mq && mc;
            }).toList();
            return _Tab(
              filters: [
                _FilterItem(l10n.filterAll, _cuisine == null,
                    () => setState(() => _cuisine = null)),
                ...cuisines.map((c) => _FilterItem(
                    c, _cuisine == c, () => setState(() => _cuisine = c))),
              ],
              emptyText: l10n.restaurantsEmpty,
              children:
                  list.map((r) => RestaurantCard(restaurant: r)).toList(),
            );
          },
        );
  }
}

// --- Guides : filtre par langue -------------------------------------------
class _GuidesView extends ConsumerStatefulWidget {
  final String query;
  const _GuidesView({required this.query});

  @override
  ConsumerState<_GuidesView> createState() => _GuidesViewState();
}

class _GuidesViewState extends ConsumerState<_GuidesView> {
  String? _lang;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = widget.query.trim().toLowerCase();
    return ref.watch(guidesProvider).when(
          loading: () => const SkeletonList(item: TileSkeleton()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (all) {
            final langs = {for (final g in all) ...g.languages}.toList()
              ..sort();
            final list = all.where((g) {
              final mq = q.isEmpty || g.name.toLowerCase().contains(q);
              final ml = _lang == null || g.languages.contains(_lang);
              return mq && ml;
            }).toList();
            return _Tab(
              filters: [
                _FilterItem(l10n.filterAll, _lang == null,
                    () => setState(() => _lang = null)),
                ...langs.map((l) => _FilterItem(
                    l, _lang == l, () => setState(() => _lang = l))),
              ],
              emptyText: l10n.guidesEmpty,
              children: list.map((g) => GuideCard(guide: g)).toList(),
            );
          },
        );
  }
}

// --- Brique commune : barre de filtre + liste -----------------------------
class _FilterItem {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  _FilterItem(this.label, this.selected, this.onTap);
}

class _Tab extends StatelessWidget {
  final List<_FilterItem> filters;
  final String emptyText;
  final List<Widget> children;

  const _Tab(
      {required this.filters,
      required this.emptyText,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filters.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
            child: Row(
              children: filters
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: FilterChip(
                          label: Text(f.label),
                          selected: f.selected,
                          showCheckmark: false,
                          onSelected: (_) => f.onTap(),
                        ),
                      ))
                  .toList(),
            ),
          ),
        Expanded(
          child: children.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(emptyText,
                        textAlign: TextAlign.center,
                        style: AppTypography.emptyTitle
                            .copyWith(color: AppColors.textLight)),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.xxl),
                  children: children,
                ),
        ),
      ],
    );
  }
}
