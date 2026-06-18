// NOTE : Carte interactive du Cameroun avec pins par catégorie, aperçu au tap,
// position de l'utilisateur, contrôles zoom/recentrage et fond de carte épuré (CARTO).
// Concept mis en avant : flutter_map + MapController + état de sélection local.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/launcher.dart';
import '../enums/destination_category.dart';
import '../l10n/app_localizations.dart';
import '../models/destination.dart';
import '../providers/destinations_provider.dart';
import '../providers/location_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/category_style.dart';
import '../widgets/smart_image.dart';
import 'detail_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const _cameroonCenter = LatLng(4.5, 11.5);
  static const _initialZoom = 5.5;

  // Fond de carte épuré CARTO Voyager (cohérent avec le thème éditorial).
  static const _tileUrl =
      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';
  static const _subdomains = ['a', 'b', 'c', 'd'];

  final MapController _mapController = MapController();
  DestinationCategory? _filter;
  Destination? _selected;

  void _zoomBy(double delta) {
    final cam = _mapController.camera;
    _mapController.move(cam.center, cam.zoom + delta);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destinationsAsync = ref.watch(destinationsProvider);
    final userLocation = ref.watch(userLocationProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mapTitle)),
      body: destinationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (destinations) {
          final filtered = _filter == null
              ? destinations
              : destinations.where((d) => d.category == _filter).toList();

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _cameroonCenter,
                  initialZoom: _initialZoom,
                  minZoom: 4,
                  maxZoom: 16,
                  onTap: (_, __) => setState(() => _selected = null),
                ),
                children: [
                  TileLayer(
                    urlTemplate: _tileUrl,
                    subdomains: _subdomains,
                    userAgentPackageName: 'com.example.discover_cameroon',
                  ),
                  MarkerLayer(
                    markers: [
                      for (final dest in filtered)
                        _destinationMarker(dest),
                      if (userLocation != null) _userMarker(userLocation),
                    ],
                  ),
                  RichAttributionWidget(
                    alignment: AttributionAlignment.bottomLeft,
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap',
                        onTap: () => launchUrl(
                          Uri.parse('https://www.openstreetmap.org/copyright'),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                      TextSourceAttribution(
                        'CARTO',
                        onTap: () => launchUrl(
                          Uri.parse('https://carto.com/attributions'),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Filtres par catégorie (en haut)
              _FilterOverlay(
                selected: _filter,
                onSelected: (cat) => setState(() {
                  _filter = cat;
                  _selected = null;
                }),
              ),

              // Contrôles (zoom, ma position, recentrage)
              Positioned(
                right: AppSpacing.md,
                top: 72,
                child: Column(
                  children: [
                    _MapButton(
                      icon: Icons.add,
                      tooltip: l10n.mapZoomIn,
                      onTap: () => _zoomBy(1),
                    ),
                    _MapButton(
                      icon: Icons.remove,
                      tooltip: l10n.mapZoomOut,
                      onTap: () => _zoomBy(-1),
                    ),
                    _MapButton(
                      icon: Icons.my_location,
                      tooltip: l10n.mapMyLocation,
                      onTap: () {
                        if (userLocation != null) {
                          _mapController.move(userLocation, 12);
                        } else {
                          ref.invalidate(userLocationProvider);
                        }
                      },
                    ),
                    _MapButton(
                      icon: Icons.center_focus_strong,
                      tooltip: l10n.mapRecenter,
                      onTap: () =>
                          _mapController.move(_cameroonCenter, _initialZoom),
                    ),
                  ],
                ),
              ),

              // Aperçu de la destination sélectionnée (en bas)
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 0.3), end: Offset.zero)
                        .animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: _selected == null
                      ? const SizedBox.shrink()
                      : _DestinationPreview(
                          key: ValueKey(_selected!.id),
                          destination: _selected!,
                          onClose: () => setState(() => _selected = null),
                          onView: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailScreen(destination: _selected!),
                            ),
                          ),
                          onDirections: () => AppLauncher.openDirections(
                            _selected!.latitude,
                            _selected!.longitude,
                            label: _selected!.name,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Marker _destinationMarker(Destination dest) {
    final isSelected = _selected?.id == dest.id;
    final size = isSelected ? 46.0 : 38.0;
    return Marker(
      point: LatLng(dest.latitude, dest.longitude),
      width: 52,
      height: 52,
      child: GestureDetector(
        onTap: () {
          setState(() => _selected = dest);
          _mapController.move(
              LatLng(dest.latitude, dest.longitude), _mapController.camera.zoom);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: dest.category.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.gold : Colors.white,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
            ],
          ),
          child: Icon(dest.category.icon,
              color: Colors.white, size: isSelected ? 24 : 20),
        ),
      ),
    );
  }

  Marker _userMarker(LatLng point) {
    return Marker(
      point: point,
      width: 22,
      height: 22,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 4),
          ],
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _MapButton(
      {required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        elevation: 3,
        shadowColor: AppColors.shadow,
        child: Tooltip(
          message: tooltip,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 42,
              height: 42,
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationPreview extends StatelessWidget {
  final Destination destination;
  final VoidCallback onClose;
  final VoidCallback onView;
  final VoidCallback onDirections;

  const _DestinationPreview({
    super.key,
    required this.destination,
    required this.onClose,
    required this.onView,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.cardBorder,
      elevation: 6,
      shadowColor: AppColors.shadow,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: SmartImage(
                    source: destination.cover,
                    width: 64,
                    height: 64,
                    fallbackColor: destination.category.color,
                    fallbackIcon: destination.category.icon,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(destination.name, style: AppTypography.cardTitle),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(children: [
                        Icon(destination.category.icon,
                            size: 13, color: destination.category.color),
                        const SizedBox(width: AppSpacing.xxs),
                        Flexible(
                          child: Text(destination.category.label,
                              style: AppTypography.caption),
                        ),
                      ]),
                      const SizedBox(height: 2),
                      Text(destination.region,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.cardMeta),
                    ],
                  ),
                ),
                InkWell(
                  onTap: onClose,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.xxs),
                    child: Icon(Icons.close,
                        size: 18, color: AppColors.textLight),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDirections,
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
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onView,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(l10n.actionView),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _FilterOverlay extends StatelessWidget {
  final DestinationCategory? selected;
  final void Function(DestinationCategory?) onSelected;

  const _FilterOverlay({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Positioned(
      top: AppSpacing.md,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            _chip(context, null, l10n.filterAll, null),
            ...DestinationCategory.values
                .map((c) => _chip(context, c, c.label, c.icon)),
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, DestinationCategory? category,
      String label, IconData? icon) {
    final isSelected = selected == category;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        avatar: icon == null
            ? null
            : Icon(icon,
                size: 16,
                color: isSelected ? Colors.white : category?.color),
        label: Text(label),
        selected: isSelected,
        showCheckmark: false,
        backgroundColor: AppColors.surface,
        elevation: 2,
        onSelected: (_) =>
            onSelected(isSelected && category != null ? null : category),
      ),
    );
  }
}
