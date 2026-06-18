// NOTE : Utilitaire centralisé pour les actions « sortantes » : appel, WhatsApp, itinéraire.
// Concept mis en avant : encapsuler url_launcher pour ne pas répéter la logique d'URL partout.

import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  AppLauncher._();

  /// Lance un appel téléphonique vers [phone] (format libre, ex. « +237 6.. » ou « 117 »).
  static Future<bool> call(String phone) {
    final sanitized = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    return _launch(Uri(scheme: 'tel', path: sanitized));
  }

  /// Ouvre une conversation WhatsApp avec [number] (les non-chiffres sont retirés).
  static Future<bool> whatsapp(String number, {String? message}) {
    final digits = number.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse(
      'https://wa.me/$digits${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}',
    );
    return _launch(uri);
  }

  /// Ouvre l'itinéraire vers les coordonnées dans l'app de cartes par défaut.
  static Future<bool> openDirections(double lat, double lng, {String? label}) {
    final query = label != null ? '$lat,$lng($label)' : '$lat,$lng';
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(query)}',
    );
    return _launch(uri);
  }

  static Future<bool> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
