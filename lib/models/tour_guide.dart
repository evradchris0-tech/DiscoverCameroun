// NOTE : Guide touristique local (rubrique « guides locaux »).
// Concept mis en avant : entité avec contacts (appel / WhatsApp) et liens vers les destinations.

class TourGuide {
  final String id;
  final String name;
  final String photoPath;
  final List<String> languages; // ex. ['Français', 'Anglais', 'Pidgin']
  final List<String> specialties; // ex. ['Randonnée', 'Histoire']
  final String phone; // format international ex. +237...
  final String? whatsapp; // numéro WhatsApp (souvent identique au phone)
  final double rating; // 0..5
  final int? pricePerDay; // FCFA / jour
  final String bio;
  final List<String> destinationIds; // destinations couvertes

  const TourGuide({
    required this.id,
    required this.name,
    required this.photoPath,
    this.languages = const [],
    this.specialties = const [],
    required this.phone,
    this.whatsapp,
    this.rating = 0,
    this.pricePerDay,
    this.bio = '',
    this.destinationIds = const [],
  });

  factory TourGuide.fromJson(Map<String, dynamic> json) {
    return TourGuide(
      id: json['id'] as String,
      name: json['name'] as String,
      photoPath: json['photoPath'] as String? ?? '',
      languages:
          (json['languages'] as List<dynamic>?)?.cast<String>() ?? const [],
      specialties:
          (json['specialties'] as List<dynamic>?)?.cast<String>() ?? const [],
      phone: json['phone'] as String? ?? '',
      whatsapp: json['whatsapp'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      pricePerDay: (json['pricePerDay'] as num?)?.toInt(),
      bio: json['bio'] as String? ?? '',
      destinationIds:
          (json['destinationIds'] as List<dynamic>?)?.cast<String>() ??
              const [],
    );
  }
}
