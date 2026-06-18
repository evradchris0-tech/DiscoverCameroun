// NOTE : Position de l'utilisateur (GPS) + calcul d'itinéraire vers une cible.
// Concept mis en avant : FutureProvider pour la position, FutureProvider.family pour la route.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../core/route_service.dart';

/// Position courante de l'utilisateur, ou `null` si indisponible/refusée.
/// La demande de permission est faite paresseusement, au premier besoin.
final userLocationProvider = FutureProvider<LatLng?>((ref) async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
    return LatLng(pos.latitude, pos.longitude);
  } catch (_) {
    return null;
  }
});

/// Coordonnées cibles d'un itinéraire (clé de family à égalité structurelle).
typedef RouteTarget = ({double lat, double lng});

/// Itinéraire en voiture depuis la position de l'utilisateur vers [target].
/// Renvoie `null` si la position est inconnue ou le calcul échoue.
final routeToProvider =
    FutureProvider.family<RouteInfoData?, RouteTarget>((ref, target) async {
  final from = await ref.watch(userLocationProvider.future);
  if (from == null) return null;
  return RouteService.driving(from, LatLng(target.lat, target.lng));
});
