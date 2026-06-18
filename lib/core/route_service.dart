// NOTE : Calcul d'itinéraire routier (distance + durée) via OSRM, le moteur de routage
// open-source d'OpenStreetMap — gratuit et sans clé d'API.
// Concept mis en avant : appel HTTP + parsing JSON, avec repli silencieux (null) en cas d'échec.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Résultat d'un calcul d'itinéraire : distance (m) et durée (s) en voiture.
class RouteInfoData {
  final double distanceMeters;
  final double durationSeconds;

  const RouteInfoData({
    required this.distanceMeters,
    required this.durationSeconds,
  });

  /// Distance formatée (ex. « 850 m » ou « 12,4 km »).
  String get distanceLabel {
    if (distanceMeters < 1000) return '${distanceMeters.round()} m';
    final km = distanceMeters / 1000;
    final text = km >= 10 ? km.round().toString() : km.toStringAsFixed(1);
    return '${text.replaceAll('.', ',')} km';
  }

  /// Durée formatée (ex. « 35 min » ou « 2 h 15 »).
  String get durationLabel {
    final totalMin = (durationSeconds / 60).round();
    if (totalMin < 60) return '$totalMin min';
    final h = totalMin ~/ 60;
    final m = totalMin % 60;
    return m == 0 ? '$h h' : '$h h ${m.toString().padLeft(2, '0')}';
  }
}

class RouteService {
  RouteService._();

  static const _base = 'https://router.project-osrm.org/route/v1/driving';

  /// Itinéraire en voiture entre [from] et [to]. Renvoie `null` si indisponible.
  static Future<RouteInfoData?> driving(LatLng from, LatLng to) async {
    final uri = Uri.parse(
      '$_base/${from.longitude},${from.latitude};${to.longitude},${to.latitude}'
      '?overview=false',
    );
    try {
      final resp = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) return null;
      final body = json.decode(resp.body) as Map<String, dynamic>;
      if (body['code'] != 'Ok') return null;
      final routes = body['routes'] as List<dynamic>;
      if (routes.isEmpty) return null;
      final route = routes.first as Map<String, dynamic>;
      return RouteInfoData(
        distanceMeters: (route['distance'] as num).toDouble(),
        durationSeconds: (route['duration'] as num).toDouble(),
      );
    } catch (_) {
      // Réseau indisponible, timeout, JSON inattendu… → repli silencieux.
      return null;
    }
  }
}
