// NOTE : Page d'accueil — composition scrollable : en-tête de recherche, découverte
// par région, filtres par catégorie et liste « Séjours populaires ».
// Concept mis en avant : CustomScrollView (slivers) + providers Riverpod réactifs.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/destination_category.dart';
import '../l10n/app_localizations.dart';
import '../models/destination.dart';
import '../providers/destinations_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/popular_stay_card.dart';
import '../widgets/section_header.dart';
import '../widgets/smart_image.dart';
import 'detail_screen.dart';
import 'emergency_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _navigateToDetail(BuildContext context, Destination destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, _) =>
            DetailScreen(destination: destination),
        transitionsBuilder: (context, animation, _, child) {
          final curved = CurvedAnimation(
              parent: animation, curve: Curves.easeInOutCubic);
          return SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0), end: Offset.zero)
                .animate(curved),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorder),
        title: Text(l10n.appTitle, style: AppTypography.dialogTitle),
        content: Text(l10n.aboutContent, style: AppTypography.sans(height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.actionClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final filteredAsync = ref.watch(filteredDestinationsProvider);
    final totalCount = ref.watch(destinationsProvider).valueOrNull?.length ?? 0;
    final query = ref.watch(searchQueryProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text(
              locale.languageCode.toUpperCase(),
              style: AppTypography.sans(
                  fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.emergency_outlined, size: 22),
            tooltip: l10n.emergencyTooltip,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmergencyScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, size: 22),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HomeHeader(
              totalCount: totalCount,
              onSearchChanged: (q) =>
                  ref.read(searchQueryProvider.notifier).state = q,
            ),
          ),

          // Découvrir par région (masqué pendant une recherche)
          if (query.isEmpty) const SliverToBoxAdapter(child: _RegionSection()),

          SliverToBoxAdapter(
            child: _CategoryFilterBar(
              selectedCategory: ref.watch(selectedCategoryProvider),
              onCategorySelected: (cat) =>
                  ref.read(selectedCategoryProvider.notifier).state = cat,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: SectionHeader(title: l10n.sectionPopularStays),
            ),
          ),

          ...filteredAsync.when(
            loading: () => [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
            error: (e, _) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Center(child: Text('Erreur : $e')),
                ),
              ),
            ],
            data: (filtered) => filtered.isEmpty
                ? [const SliverToBoxAdapter(child: _EmptyState())]
                : [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => AnimatedListItem(
                            index: index,
                            key: ValueKey(filtered[index].id),
                            child: PopularStayCard(
                              destination: filtered[index],
                              onTap: (d) => _navigateToDetail(context, d),
                            ),
                          ),
                          childCount: filtered.length,
                        ),
                      ),
                    ),
                  ],
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.explore_off, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.emptyNoDestinations,
              style: AppTypography.emptyTitle.copyWith(color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionSection extends ConsumerWidget {
  const _RegionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final regionsAsync = ref.watch(regionsProvider);
    final selected = ref.watch(selectedRegionProvider);

    return regionsAsync.maybeWhen(
      data: (regions) {
        if (regions.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            SectionHeader(title: l10n.sectionRegions),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 116,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: regions.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) {
                  final r = regions[i];
                  return _RegionCircle(
                    region: r,
                    selected: selected == r.name,
                    onTap: () => ref.read(selectedRegionProvider.notifier).state =
                        selected == r.name ? null : r.name,
                  );
                },
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _RegionCircle extends StatelessWidget {
  final RegionInfo region;
  final bool selected;
  final VoidCallback onTap;

  const _RegionCircle(
      {required this.region, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Nom court : retire le préfixe « Région du / de l' / de la ».
    final shortName = region.name
        .replaceFirst(RegExp(r"^R[ée]gion (du |de la |de l'|de |des )?"), '');
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 78,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? AppColors.gold : AppColors.outlineVariant,
                      width: selected ? 2.5 : 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: SmartImage(
                      source: region.cover,
                      width: 64,
                      height: 64,
                      fallbackColor: AppColors.primary,
                      fallbackIcon: Icons.place,
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 22, minHeight: 22),
                    child: Text(
                      '${region.count}',
                      textAlign: TextAlign.center,
                      style: AppTypography.sans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              shortName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.sans(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final int totalCount;
  final void Function(String) onSearchChanged;

  const _HomeHeader(
      {required this.totalCount, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40, top: -40,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            right: 20, bottom: 30,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 4, height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(AppRadius.indicator),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.homeEyebrow,
                    style: AppTypography.eyebrow.copyWith(color: AppColors.gold),
                  ),
                ]),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.homeTitle,
                  style: AppTypography.headingLarge.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.homeDestinationsToExplore(totalCount),
                  style: AppTypography.heroSubtitle
                      .copyWith(color: Colors.white.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  onChanged: onSearchChanged,
                  style: AppTypography.searchInput,
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textLight, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  final DestinationCategory? selectedCategory;
  final void Function(DestinationCategory?) onCategorySelected;

  const _CategoryFilterBar(
      {required this.selectedCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.smPlus, AppSpacing.lg, AppSpacing.smPlus),
        child: Row(
          children: [
            _buildChip(context, null, l10n.filterAll),
            ...DestinationCategory.values
                .map((cat) => _buildChip(context, cat, cat.label)),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
      BuildContext context, DestinationCategory? category, String label) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onCategorySelected(
            isSelected && category != null ? null : category),
        showCheckmark: false,
      ),
    );
  }
}
