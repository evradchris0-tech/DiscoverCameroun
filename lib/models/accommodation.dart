// NOTE : Hébergement à proximité d'une destination (rubrique « hébergement »).
// Concept mis en avant : enum de type + coordonnées GPS pour l'itinéraire.

enum AccommodationType {
  hotel,
  auberge,
  campement,
  chambreDHote,
  residence,
}

extension AccommodationTypeX on AccommodationType {
  String get label {
    switch (this) {
      case AccommodationType.hotel:
        return 'Hôtel';
      case AccommodationType.auberge:
        return 'Auberge';
      case AccommodationType.campement:
        return 'Campement';
      case AccommodationType.chambreDHote:
        return "Chambre d'hôte";
      case AccommodationType.residence:
        return 'Résidence meublée';
    }
  }

  String get key {
    switch (this) {
      case AccommodationType.hotel:
        return 'hotel';
      case AccommodationType.auberge:
        return 'auberge';
      case AccommodationType.campement:
        return 'campement';
      case AccommodationType.chambreDHote:
        return 'chambre_dhote';
      case AccommodationType.residence:
        return 'residence';
    }
  }

  static AccommodationType fromKey(String value) {
    return AccommodationType.values.firstWhere(
      (t) => t.key == value,
      orElse: () => AccommodationType.hotel,
    );
  }
}

class Accommodation {
  final String id;
  final String name;
  final AccommodationType type;
  final List<String> photoPaths;
  final int? priceFrom; // à partir de … (FCFA / nuit)
  final String currency;
  final double rating;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<String> amenities; // ex. ['Wifi', 'Piscine', 'Petit-déjeuner']
  final String? phone;
  final String destinationId;

  const Accommodation({
    required this.id,
    required this.name,
    this.type = AccommodationType.hotel,
    this.photoPaths = const [],
    this.priceFrom,
    this.currency = 'XAF',
    this.rating = 0,
    this.address = '',
    this.latitude,
    this.longitude,
    this.amenities = const [],
    this.phone,
    required this.destinationId,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'] as String,
      name: json['name'] as String,
      type: AccommodationTypeX.fromKey(json['type'] as String? ?? 'hotel'),
      photoPaths:
          (json['photoPaths'] as List<dynamic>?)?.cast<String>() ?? const [],
      priceFrom: (json['priceFrom'] as num?)?.toInt(),
      currency: json['currency'] as String? ?? 'XAF',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      amenities:
          (json['amenities'] as List<dynamic>?)?.cast<String>() ?? const [],
      phone: json['phone'] as String?,
      destinationId: json['destinationId'] as String,
    );
  }
}
