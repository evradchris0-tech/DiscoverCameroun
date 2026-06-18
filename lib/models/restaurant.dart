// NOTE : Restaurant à proximité d'une destination (rubrique « restaurant »).
// Concept mis en avant : mise en avant des plats signatures camerounais.

class Restaurant {
  final String id;
  final String name;
  final List<String> photoPaths;
  final List<String> cuisines; // ex. ['Camerounaise', 'Grillades']
  final List<String> signatureDishes; // ex. ['Ndolè', 'Poulet DG', 'Eru']
  final String priceRange; // ex. '€', '€€', '€€€'
  final double rating;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String destinationId;

  const Restaurant({
    required this.id,
    required this.name,
    this.photoPaths = const [],
    this.cuisines = const [],
    this.signatureDishes = const [],
    this.priceRange = '€€',
    this.rating = 0,
    this.address = '',
    this.latitude,
    this.longitude,
    this.phone,
    required this.destinationId,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      photoPaths:
          (json['photoPaths'] as List<dynamic>?)?.cast<String>() ?? const [],
      cuisines:
          (json['cuisines'] as List<dynamic>?)?.cast<String>() ?? const [],
      signatureDishes:
          (json['signatureDishes'] as List<dynamic>?)?.cast<String>() ??
              const [],
      priceRange: json['priceRange'] as String? ?? '€€',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      destinationId: json['destinationId'] as String,
    );
  }
}
