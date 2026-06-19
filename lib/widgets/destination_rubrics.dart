// NOTE : Sections « rubriques » d'une fiche destination : guides, expériences,
// hébergements, restaurants — alimentées par les FutureProvider.family.
// Concept mis en avant : ConsumerWidget qui agrège plusieurs providers liés à un id.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/destination.dart';
import '../providers/catalog_providers.dart';
import '../screens/guides_screen.dart';
import '../theme/app_spacing.dart';
import 'accommodation_card.dart';
import 'experience_card.dart';
import 'guide_card.dart';
import 'restaurant_card.dart';
import 'section_header.dart';

class DestinationRubrics extends ConsumerWidget {
  final Destination destination;

  const DestinationRubrics({super.key, required this.destination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = destination.id;
    final guides = ref.watch(guidesForDestinationProvider(id));
    final experiences = ref.watch(experiencesForDestinationProvider(id));
    final accommodations = ref.watch(accommodationsForDestinationProvider(id));
    final restaurants = ref.watch(restaurantsForDestinationProvider(id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Guides locaux (aperçu + voir tout) ---
        guides.maybeWhen(
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : _Section(
                  header: SectionHeader(
                    title: l10n.sectionGuides,
                    actionLabel: list.length > 2 ? l10n.actionSeeAll : null,
                    onAction: list.length > 2
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GuidesScreen(
                                  destinationId: id,
                                  destinationName: destination.name,
                                ),
                              ),
                            )
                        : null,
                  ),
                  children: list
                      .take(2)
                      .map((g) => GuideCard(
                            guide: g,
                            destinationName: destination.name,
                          ))
                      .toList(),
                ),
          orElse: () => const SizedBox.shrink(),
        ),

        // --- Expériences touristiques ---
        experiences.maybeWhen(
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : _Section(
                  header: SectionHeader(title: l10n.sectionExperiences),
                  children: list
                      .map((e) => ExperienceCard(
                            experience: e,
                            destinationName: destination.name,
                          ))
                      .toList(),
                ),
          orElse: () => const SizedBox.shrink(),
        ),

        // --- Hébergements à proximité ---
        accommodations.maybeWhen(
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : _Section(
                  header: SectionHeader(title: l10n.sectionWhereToSleep),
                  children: list
                      .map((a) => AccommodationCard(
                            accommodation: a,
                            destinationName: destination.name,
                          ))
                      .toList(),
                ),
          orElse: () => const SizedBox.shrink(),
        ),

        // --- Restaurants à proximité ---
        restaurants.maybeWhen(
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : _Section(
                  header: SectionHeader(title: l10n.sectionWhereToEat),
                  children: list
                      .map((r) => RestaurantCard(restaurant: r))
                      .toList(),
                ),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final Widget header;
  final List<Widget> children;

  const _Section({required this.header, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        header,
        const SizedBox(height: AppSpacing.md),
        ...children,
      ],
    );
  }
}
