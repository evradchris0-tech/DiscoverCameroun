// NOTE : Rubriques d'une fiche destination (guides, expériences, hébergements,
// restaurants) présentées en panneaux DÉPLIABLES pour raccourcir la page.
// Concept mis en avant : ConsumerWidget + ExpansionTile (repliés par défaut).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/destination.dart';
import '../providers/catalog_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'accommodation_card.dart';
import 'experience_card.dart';
import 'guide_card.dart';
import 'restaurant_card.dart';

class DestinationRubrics extends ConsumerWidget {
  final Destination destination;

  const DestinationRubrics({super.key, required this.destination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = destination.id;
    final name = destination.name;
    final guides = ref.watch(guidesForDestinationProvider(id));
    final experiences = ref.watch(experiencesForDestinationProvider(id));
    final accommodations = ref.watch(accommodationsForDestinationProvider(id));
    final restaurants = ref.watch(restaurantsForDestinationProvider(id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        guides.maybeWhen(
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : _ExpandableSection(
                  icon: Icons.person_pin_circle_outlined,
                  title: '${l10n.sectionGuides} · ${list.length}',
                  children: list
                      .map((g) =>
                          GuideCard(guide: g, destinationName: name))
                      .toList(),
                ),
          orElse: () => const SizedBox.shrink(),
        ),
        experiences.maybeWhen(
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : _ExpandableSection(
                  icon: Icons.local_activity_outlined,
                  title: '${l10n.sectionExperiences} · ${list.length}',
                  children: list
                      .map((e) =>
                          ExperienceCard(experience: e, destinationName: name))
                      .toList(),
                ),
          orElse: () => const SizedBox.shrink(),
        ),
        accommodations.maybeWhen(
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : _ExpandableSection(
                  icon: Icons.hotel_outlined,
                  title: '${l10n.sectionWhereToSleep} · ${list.length}',
                  children: list
                      .map((a) => AccommodationCard(
                          accommodation: a, destinationName: name))
                      .toList(),
                ),
          orElse: () => const SizedBox.shrink(),
        ),
        restaurants.maybeWhen(
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : _ExpandableSection(
                  icon: Icons.restaurant_outlined,
                  title: '${l10n.sectionWhereToEat} · ${list.length}',
                  children:
                      list.map((r) => RestaurantCard(restaurant: r)).toList(),
                ),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Panneau dépliable (replié par défaut) avec un titre et une icône.
class _ExpandableSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _ExpandableSection(
      {required this.icon, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Divider(height: 1),
        Theme(
          // Retire les liserés par défaut de l'ExpansionTile.
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(top: AppSpacing.sm),
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.textLight,
            leading: Icon(icon, color: AppColors.primary),
            title: Text(title, style: AppTypography.sectionTitle),
            children: children,
          ),
        ),
      ],
    );
  }
}
