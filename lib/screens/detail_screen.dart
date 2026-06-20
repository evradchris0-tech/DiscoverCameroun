// NOTE : Page de détail enrichie avec galerie, activités, carte embarquée et partage.
// Concept mis en avant : ConsumerWidget Riverpod + flutter_map + Clipboard pour le partage.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

import '../core/launcher.dart';
import '../enums/destination_category.dart';
import '../l10n/app_localizations.dart';
import '../models/destination.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/category_style.dart';
import '../widgets/destination_practical_info.dart';
import '../widgets/destination_reviews.dart';
import '../widgets/destination_rubrics.dart';
import '../widgets/image_gallery.dart';
import '../widgets/like_button.dart';
import '../widgets/route_info.dart';

class DetailScreen extends ConsumerWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  // Copie les infos dans le presse-papiers et affiche une confirmation.
  void _copyToClipboard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text =
        '${destination.name} — ${destination.region}\n\n'
        '${destination.description}\n\n'
        'Découvert via KmerTour';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(l10n.snackCopied),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.snackbar)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isFavorite =
        ref.watch(favoritesProvider).contains(destination.id);
    final colorScheme = Theme.of(context).colorScheme;

    // Menu 3 points : partager / copier / signet (évite de surcharger l'en-tête)
    final menu = PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'share':
            Share.share(l10n.shareDestinationText(
                destination.name, destination.region));
          case 'copy':
            _copyToClipboard(context);
          case 'fav':
            ref.read(favoritesProvider.notifier).toggle(destination.id);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'share',
          child: _MenuRow(icon: Icons.share_outlined, label: l10n.actionShare),
        ),
        PopupMenuItem(
          value: 'copy',
          child: _MenuRow(icon: Icons.copy, label: l10n.tooltipCopy),
        ),
        PopupMenuItem(
          value: 'fav',
          child: _MenuRow(
            icon: isFavorite ? Icons.bookmark : Icons.bookmark_border,
            label: isFavorite ? l10n.tooltipRemoveFav : l10n.tooltipAddFav,
          ),
        ),
      ],
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // En-tête rétractable avec galerie en parallax
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 16),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [menu],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              stretchModes: const [StretchMode.zoomBackground],
              titlePadding: const EdgeInsets.only(
                  left: 56, right: 56, bottom: AppSpacing.md),
              title: Text(
                destination.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.sans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ImageGallery(
                    images: destination.gallery,
                    heroTag: 'hero-${destination.id}',
                    fallbackColor: destination.category.color,
                    fallbackIcon: destination.category.icon,
                  ),
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom + Badge catégorie
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          destination.name,
                          style: AppTypography.headingLarge
                              .copyWith(color: AppColors.textDark),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _CategoryBadge(destination: destination),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.smPlus),

                  Row(children: [
                    Icon(Icons.location_on,
                        size: 15, color: colorScheme.secondary),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(destination.region, style: AppTypography.meta),
                  ]),

                  if (destination.altitude != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(children: [
                      Icon(Icons.terrain,
                          size: 15, color: colorScheme.secondary),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        l10n.altitudeLabel(destination.altitude!.toInt()),
                        style: AppTypography.meta,
                      ),
                    ]),
                  ],

                  const SizedBox(height: AppSpacing.xl),

                  Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius:
                          BorderRadius.circular(AppRadius.indicator),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(l10n.sectionAbout, style: AppTypography.sectionTitle),
                  const SizedBox(height: AppSpacing.smPlus),
                  Text(destination.description, style: AppTypography.bodyText),

                  // Section Activités
                  if (destination.activities.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxl),
                    Text(l10n.sectionActivities,
                        style: AppTypography.sectionTitle),
                    const SizedBox(height: AppSpacing.smPlus),
                    // Wrap affiche les chips en plusieurs lignes si nécessaire.
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: destination.activities
                          .map((activity) => _ActivityChip(label: activity))
                          .toList(),
                    ),
                  ],

                  // Section Localisation (mini-carte)
                  const SizedBox(height: AppSpacing.xxl),
                  Text(l10n.sectionLocation, style: AppTypography.sectionTitle),
                  const SizedBox(height: AppSpacing.smPlus),
                  ClipRRect(
                    borderRadius: AppRadius.cardBorder,
                    child: SizedBox(
                      height: 200,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                              destination.latitude, destination.longitude),
                          initialZoom: 10,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none, // carte non interactive
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'com.example.discover_cameroon',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(destination.latitude,
                                    destination.longitude),
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: AppColors.gold,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),
                  // Temps de trajet estimé depuis la position de l'utilisateur
                  RouteInfo(
                      lat: destination.latitude,
                      lng: destination.longitude),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => AppLauncher.openDirections(
                          destination.latitude, destination.longitude,
                          label: destination.name),
                      icon: const Icon(Icons.directions, size: 16),
                      label: Text(l10n.actionDirections),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.buttonBorder),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Infos pratiques : saison, prix d'entrée, transport, conseils
                  DestinationPracticalInfo(destination: destination),

                  // Rubriques : guides, expériences, hébergements, restaurants
                  DestinationRubrics(destination: destination),

                  const SizedBox(height: AppSpacing.xxl),

                  // Avis & Notes
                  DestinationReviews(
                    destinationId: destination.id,
                    destinationName: destination.name,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Like + Retour
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.cardBorder,
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LikeButton(
                          initialLikes: 42,
                          destinationId: destination.id,
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: Text(l10n.actionBack),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Text(label,
            style: AppTypography.sans(
                fontSize: 14, color: AppColors.textDark)),
      ],
    );
  }
}

class _ActivityChip extends StatelessWidget {
  final String label;

  const _ActivityChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(label, style: AppTypography.chipLabel),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final Destination destination;

  const _CategoryBadge({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(destination.category.label, style: AppTypography.badge),
    );
  }
}
