// NOTE : Moyen de locomotion pour rejoindre / parcourir une destination.
// Concept mis en avant : enum de modes de transport + parsing depuis le JSON.

/// Modes de transport disponibles au Cameroun.
enum TransportMode {
  avion,
  train,
  bus,
  taxiBrousse,
  motoTaxi, // « bend-skin »
  locationVoiture,
  bateau,
}

extension TransportModeX on TransportMode {
  String get label {
    switch (this) {
      case TransportMode.avion:
        return 'Avion';
      case TransportMode.train:
        return 'Train';
      case TransportMode.bus:
        return 'Bus / car';
      case TransportMode.taxiBrousse:
        return 'Taxi-brousse';
      case TransportMode.motoTaxi:
        return 'Moto-taxi (bend-skin)';
      case TransportMode.locationVoiture:
        return 'Location de voiture';
      case TransportMode.bateau:
        return 'Bateau / pirogue';
    }
  }

  String get key {
    switch (this) {
      case TransportMode.avion:
        return 'avion';
      case TransportMode.train:
        return 'train';
      case TransportMode.bus:
        return 'bus';
      case TransportMode.taxiBrousse:
        return 'taxi_brousse';
      case TransportMode.motoTaxi:
        return 'moto_taxi';
      case TransportMode.locationVoiture:
        return 'location_voiture';
      case TransportMode.bateau:
        return 'bateau';
    }
  }

  static TransportMode fromKey(String value) {
    return TransportMode.values.firstWhere(
      (m) => m.key == value,
      orElse: () => TransportMode.bus,
    );
  }
}

class TransportOption {
  final TransportMode mode;
  final String description;
  final String? indicativePrice; // ex. « 3 000 – 6 000 FCFA »
  final String? duration; // ex. « ~3 h depuis Douala »
  final String? tips;

  const TransportOption({
    required this.mode,
    required this.description,
    this.indicativePrice,
    this.duration,
    this.tips,
  });

  factory TransportOption.fromJson(Map<String, dynamic> json) {
    return TransportOption(
      mode: TransportModeX.fromKey(json['mode'] as String? ?? 'bus'),
      description: json['description'] as String? ?? '',
      indicativePrice: json['indicativePrice'] as String?,
      duration: json['duration'] as String?,
      tips: json['tips'] as String?,
    );
  }
}
