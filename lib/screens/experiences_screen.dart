// NOTE : Vue « Expériences » (corps réutilisable, sans Scaffold) — filtrable par type.
// Utilisée comme onglet dans CatalogScreen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/tourist_experience.dart';
import '../providers/catalog_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/experience_card.dart';

class ExperiencesView extends ConsumerStatefulWidget {
  final String query;
  const ExperiencesView({super.key, this.query = ''});

  @override
  ConsumerState<ExperiencesView> createState() => _ExperiencesViewState();
}

class _ExperiencesViewState extends ConsumerState<ExperiencesView> {
  ExperienceType? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final experiencesAsync = ref.watch(experiencesProvider);

    return experiencesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (all) {
        final q = widget.query.trim().toLowerCase();
        final types = all.map((e) => e.type).toSet().toList();
        final filtered = all.where((e) {
          final matchesType = _filter == null || e.type == _filter;
          final matchesQuery = q.isEmpty || e.title.toLowerCase().contains(q);
          return matchesType && matchesQuery;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
              child: Row(
                children: [
                  _FilterChip(
                    label: l10n.filterAll,
                    selected: _filter == null,
                    onTap: () => setState(() => _filter = null),
                  ),
                  ...types.map((t) => _FilterChip(
                        label: t.label,
                        selected: _filter == t,
                        onTap: () => setState(() => _filter = t),
                      )),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(l10n.experiencesEmpty,
                          style: AppTypography.emptyTitle
                              .copyWith(color: AppColors.textLight)),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
                      children: filtered
                          .map((e) => ExperienceCard(experience: e))
                          .toList(),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
