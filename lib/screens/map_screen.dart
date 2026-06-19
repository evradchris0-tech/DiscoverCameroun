// NOTE : Carte du Cameroun « façon Google » sans clé : flutter_map + bascule
// Plan / Satellite (imagerie Esri), animations de caméra, pins par catégorie,
// aperçu au tap, position de l'utilisateur et contrôles zoom/recentrage.

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

enum _MapType { plan, satellite }

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  static const _cameroonCenter = LatLng(4.5, 11.5);
  static const _initialZoom = 5.5;
  static const _minZoom = 4.0;
  static const _maxZoom = 18.0;

  // Plan : CARTO Voyager (style clair proche de Google).
  static const _planUrl =
      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';
  static const _planSubdomains = ['a', 'b', 'c', 'd'];
  // Satellite : imagerie Esri + couche de labels (vue hybride type Google).
  static const _satUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
  static const _satLabelsUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}';

  final MapController _mapController = MapController();
  AnimationController? _moveCtrl;
  DestinationCategory? _filter;
  Destination? _selected;
  _MapType _mapType = _MapType.plan;

  @override
  void dispose() {
    _moveCtrl?.dispose();
    super.dispose();
  }

  /// Déplacement animé de la caméra (fly-to façon Google Maps).
  void _animatedMove(LatLng dest, double zoom) {
    final cam = _mapController.camera;
    final latTween = Tween(begin: cam.center.latitude, end: dest.latitude);
    final lngTween = Tween(begin: cam.center.longitude, end: dest.longitude);
    final zoomTween =
        Tween(begin: cam.zoom, end: zoom.clamp(_minZoom, _maxZoom));

    _moveCtrl?.dispose();
    final ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 550));
    _moveCtrl = ctrl;
    final anim = CurvedAnimation(parent: ctrl, curve: Curves.easeInOutCubic);
    ctrl.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(anim), lngTween.evaluate(anim)),
        zoomTween.evaluate(anim),
      );
    });
    ctrl.forward();
  }

  void _zoomBy(double delta) {
    final cam = _mapController.camera;
    _animatedMove(cam.center, cam.zoom + delta);
  }

  List<Widget> _baseLayers() {
    if (_mapType == _MapType.satellite) {
      return [
        TileLayer(
          urlTemplate: _satUrl,
          userAgentPackageName: 'com.example.discover_cameroon',
          maxNativeZoom: 18,
        ),
        TileLayer(
          urlTemplate: _satLabelsUrl,
          userAgentPackageName: 'com.example.discover_cameroon',
          maxNativeZoom: 18,
        ),
      ];
    }
    return [
      TileLayer(
        urlTemplate: _planUrl,
        subdomains: _planSubdomains,
        userAgentPackageName: 'com.example.discover_cameroon',
      ),
    ];
  }

  RichAttributionWidget _attribution() {
    if (_mapType == _MapType.satellite) {
      return RichAttributionWidget(
        alignment: AttributionAlignment.bottomLeft,
        attributions: [
          TextSourceAttribution(
            'Esri, Maxar, Earthstar Geographics',
            onTap: () => launchUrl(
              Uri.parse('https://www.esri.com'),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ],
      );
    }
    return RichAttributionWidget(
      alignment: AttributionAlignment.bottomLeft,
      attributions: [
        TextSourceAttribution('OpenStreetMap',
            onTap: () => launchUrl(
                Uri.parse('https://www.openstreetmap.org/copyright'),
                mode: LaunchMode.externalApplication)),
        TextSourceAttribution('CARTO',
            onTap: () => launchUrl(Uri.parse('https://carto.com/attributions'),
                mode: LaunchMode.externalApplication)),
      ],
    );
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
                  minZoom: _minZoom,
                  maxZoom: _maxZoom,
                  onTap: (_, __) => setState(() => _selected = null),
                ),
                children: [
                  ..._baseLayers(),
                  MarkerLayer(
                    markers: [
                      for (final dest in filtered) _destinationMarker(dest),
                      if (userLocation != null) _userMarker(userLocation),
                    ],
                  ),
                  _attribution(),
                ],
              ),

              _FilterOverlay(
                selected: _filter,
                onSelected: (cat) => setState(() {
                  _filter = cat;
                  _selected = null;
                }),
              ),

              // Contrôles (calques, zoom, position, recentrage)
              Positioned(
                right: AppSpacing.md,
                top: 72,
                child: Column(
                  children: [
                    _MapButton(
                      icon: Icons.layers_outlined,
                      tooltip: l10n.mapLayers,
                      active: _mapType == _MapType.satellite,
                      onTap: () => setState(() => _mapType =
                          _mapType == _MapType.plan
                              ? _MapType.satellite
                              : _MapType.plan),
                    ),
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
                          _animatedMove(userLocation, 12);
                        } else {
                          ref.invalidate(userLocationProvider);
                        }
                      },
                    ),
                    _MapButton(
                      icon: Icons.center_focus_strong,
                      tooltip: l10n.mapRecenter,
                      onTap: () => _animatedMove(_cameroonCenter, _initialZoom),
                    ),
                  ],
                ),
              ),

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
          _animatedMove(LatLng(dest.latitude, dest.longitude),
              _mapController.camera.zoom);
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
          color: AppColors.userLocation,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  const _MapButton(
      {required this.icon,
      required this.tooltip,
      required this.onTap,
      this.active = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: active ? AppColors.primary : AppColors.surface,
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
              child: Icon(icon,
                  color: active ? Colors.white : AppColors.primary, size: 22),
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
                    child:
                        Icon(Icons.close, size: 18, color: AppColors.textLight),
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
                size: 16, color: isSelected ? Colors.white : category?.color),
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
