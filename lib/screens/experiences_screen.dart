// NOTE : Onglet « Expériences » — toutes les expériences touristiques, filtrables par type.
// Concept mis en avant : ConsumerStatefulWidget pour un filtre local + provider global.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/tourist_experience.dart';
import '../providers/catalog_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/experience_card.dart';

class ExperiencesScreen extends ConsumerStatefulWidget {
  const ExperiencesScreen({super.key});

  @override
  ConsumerState<ExperiencesScreen> createState() => _ExperiencesScreenState();
}

class _ExperiencesScreenState extends ConsumerState<ExperiencesScreen> {
  ExperienceType? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final experiencesAsync = ref.watch(experiencesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.experiencesTitle)),
      body: experiencesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (all) {
          final types = all.map((e) => e.type).toSet().toList();
          final filtered = _filter == null
              ? all
              : all.where((e) => e.type == _filter).toList();

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
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0,
                            AppSpacing.lg, AppSpacing.xxl),
                        children: filtered
                            .map((e) => ExperienceCard(experience: e))
                            .toList(),
                      ),
              ),
            ],
          );
        },
      ),
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
