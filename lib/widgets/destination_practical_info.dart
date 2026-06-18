// NOTE : Bloc « infos pratiques » d'une destination : saison, prix d'entrée, transport, conseils.
// Concept mis en avant : widget de présentation pur, alimenté par le modèle Destination enrichi.

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/destination.dart';
import '../models/season.dart';
import '../models/transport_option.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'section_header.dart';

class DestinationPracticalInfo extends StatelessWidget {
  final Destination destination;

  const DestinationPracticalInfo({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final hasSeasons = destination.bestSeasons.isNotEmpty ||
        destination.seasonAdvice != null;
    final hasFee = destination.entryFee != null;
    final hasTransport = destination.transportOptions.isNotEmpty;
    final hasTips = destination.tips.isNotEmpty;

    if (!hasSeasons && !hasFee && !hasTransport && !hasTips) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.sectionPracticalInfo),
        const SizedBox(height: AppSpacing.md),

        if (hasSeasons) _SeasonBlock(destination: destination),
        if (hasFee) ...[
          const SizedBox(height: AppSpacing.md),
          _InfoTile(
            icon: Icons.confirmation_number_outlined,
            title: l10n.sectionEntryFee,
            value: destination.entryFee!.displayPrice,
            note: destination.entryFee!.notes,
          ),
        ],

        if (hasTransport) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: l10n.sectionHowToGet),
          const SizedBox(height: AppSpacing.md),
          ...destination.transportOptions
              .map((t) => _TransportRow(option: t)),
        ],

        if (hasTips) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: l10n.sectionTips),
          const SizedBox(height: AppSpacing.md),
          ...destination.tips.map((tip) => _Bullet(text: tip)),
        ],
      ],
    );
  }
}

class _SeasonBlock extends StatelessWidget {
  final Destination destination;
  const _SeasonBlock({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.wb_sunny_outlined,
              size: 18, color: AppColors.gold),
          const SizedBox(width: AppSpacing.sm),
          Text(AppLocalizations.of(context).sectionSeason,
              style: AppTypography.meta),
        ]),
        const SizedBox(height: AppSpacing.sm),
        if (destination.bestSeasons.isNotEmpty)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: destination.bestSeasons
                .map((s) => _SeasonChip(season: s))
                .toList(),
          ),
        if (destination.seasonAdvice != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(destination.seasonAdvice!, style: AppTypography.cardBody),
        ],
      ],
    );
  }
}

class _SeasonChip extends StatelessWidget {
  final Season season;
  const _SeasonChip({required this.season});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.goldContainer,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        '${season.label} · ${season.months}',
        style: AppTypography.sans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.onGoldContainer,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? note;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.meta),
                const SizedBox(height: 2),
                Text(value,
                    style: AppTypography.sans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                if (note != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(note!, style: AppTypography.caption),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransportRow extends StatelessWidget {
  final TransportOption option;
  const _TransportRow({required this.option});

  IconData get _icon {
    switch (option.mode) {
      case TransportMode.avion:
        return Icons.flight;
      case TransportMode.train:
        return Icons.train;
      case TransportMode.bus:
        return Icons.directions_bus;
      case TransportMode.taxiBrousse:
        return Icons.local_taxi;
      case TransportMode.motoTaxi:
        return Icons.two_wheeler;
      case TransportMode.locationVoiture:
        return Icons.directions_car;
      case TransportMode.bateau:
        return Icons.directions_boat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(_icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(option.mode.label,
                          style: AppTypography.sans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                    ),
                    if (option.indicativePrice != null)
                      Text(option.indicativePrice!,
                          style: AppTypography.sans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(option.description, style: AppTypography.cardBody),
                if (option.duration != null) ...[
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.schedule,
                        size: 13, color: AppColors.textLight),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(option.duration!, style: AppTypography.caption),
                  ]),
                ],
                if (option.tips != null) ...[
                  const SizedBox(height: 2),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.lightbulb_outline,
                        size: 13, color: AppColors.gold),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                        child: Text(option.tips!,
                            style: AppTypography.caption)),
                  ]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: AppTypography.bodyText)),
        ],
      ),
    );
  }
}
