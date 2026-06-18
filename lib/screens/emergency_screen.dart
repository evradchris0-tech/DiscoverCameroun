// NOTE : Écran des contacts d'urgence — appel direct (tap-to-call).
// Concept mis en avant : ConsumerWidget + AppLauncher pour composer un numéro d'un tap.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/emergency_contact.dart';
import '../providers/catalog_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contactsAsync = ref.watch(emergencyContactsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emergencyTitle),
        backgroundColor: AppColors.danger,
      ),
      body: contactsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (contacts) {
          final national = contacts
              .where((c) => c.scope == EmergencyScope.national)
              .toList();
          final regional = contacts
              .where((c) => c.scope == EmergencyScope.regional)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _Banner(text: l10n.emergencyBanner),
              const SizedBox(height: AppSpacing.lg),
              if (national.isNotEmpty) ...[
                Text(l10n.emergencyNational, style: AppTypography.sectionTitle),
                const SizedBox(height: AppSpacing.md),
                ...national.map((c) => _ContactTile(contact: c)),
              ],
              if (regional.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.emergencyRegional, style: AppTypography.sectionTitle),
                const SizedBox(height: AppSpacing.md),
                ...regional.map((c) => _ContactTile(contact: c)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final String text;
  const _Banner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dangerContainer,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.danger),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AppTypography.sans(
                  fontSize: 13, height: 1.4, color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final EmergencyContact contact;
  const _ContactTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        child: InkWell(
          borderRadius: AppRadius.cardBorder,
          onTap: () async {
            final ok = await AppLauncher.call(contact.number);
            if (!ok && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Impossible de lancer l'appel")),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.cardBorder,
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.dangerContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.call, color: AppColors.danger),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact.label,
                          style: AppTypography.sans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      if (contact.region != null)
                        Text(contact.region!, style: AppTypography.caption),
                      if (contact.notes != null)
                        Text(contact.notes!,
                            style: AppTypography.sans(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textLight)),
                    ],
                  ),
                ),
                Text(contact.number,
                    style: AppTypography.serif(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.danger)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
