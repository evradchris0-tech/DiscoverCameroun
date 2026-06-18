// NOTE : Écran listant les guides touristiques locaux d'une destination.
// Concept mis en avant : ConsumerWidget + FutureProvider.family paramétré par destination.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/catalog_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/guide_card.dart';

class GuidesScreen extends ConsumerWidget {
  final String destinationId;
  final String destinationName;

  const GuidesScreen({
    super.key,
    required this.destinationId,
    required this.destinationName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final guidesAsync = ref.watch(guidesForDestinationProvider(destinationId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.guidesTitle(destinationName))),
      body: guidesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (guides) {
          if (guides.isEmpty) {
            return Center(
              child: Text(l10n.guidesEmpty,
                  style: AppTypography.emptyTitle
                      .copyWith(color: AppColors.textLight)),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: guides.map((g) => GuideCard(guide: g)).toList(),
          );
        },
      ),
    );
  }
}
