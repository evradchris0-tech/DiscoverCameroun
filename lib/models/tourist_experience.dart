// NOTE : Expérience touristique immersive (rubrique « expérience touristique »).
// Concept mis en avant : différenciateur local — culinaire, peinture, ateliers « paniers mboa »…

enum ExperienceType {
  culinaire,
  peinture,
  atelierVannerie, // paniers / vannerie « souvenir mboa »
  artisanat,
  danse,
  musique,
  nature,
}

extension ExperienceTypeX on ExperienceType {
  String get label {
    switch (this) {
      case ExperienceType.culinaire:
        return 'Expérience culinaire';
      case ExperienceType.peinture:
        return 'Peinture';
      case ExperienceType.atelierVannerie:
        return 'Atelier paniers (mboa)';
      case ExperienceType.artisanat:
        return 'Artisanat';
      case ExperienceType.danse:
        return 'Danse';
      case ExperienceType.musique:
        return 'Musique';
      case ExperienceType.nature:
        return 'Nature';
    }
  }

  String get key {
    switch (this) {
      case ExperienceType.culinaire:
        return 'culinaire';
      case ExperienceType.peinture:
        return 'peinture';
      case ExperienceType.atelierVannerie:
        return 'atelier_vannerie';
      case ExperienceType.artisanat:
        return 'artisanat';
      case ExperienceType.danse:
        return 'danse';
      case ExperienceType.musique:
        return 'musique';
      case ExperienceType.nature:
        return 'nature';
    }
  }

  static ExperienceType fromKey(String value) {
    return ExperienceType.values.firstWhere(
      (t) => t.key == value,
      orElse: () => ExperienceType.artisanat,
    );
  }
}

class TouristExperience {
  final String id;
  final String title;
  final ExperienceType type;
  final String description;
  final List<String> photoPaths;
  final String? duration; // ex. « 2 h »
  final int? price; // FCFA
  final String currency;
  final String destinationId;

  const TouristExperience({
    required this.id,
    required this.title,
    this.type = ExperienceType.artisanat,
    this.description = '',
    this.photoPaths = const [],
    this.duration,
    this.price,
    this.currency = 'XAF',
    required this.destinationId,
  });

  factory TouristExperience.fromJson(Map<String, dynamic> json) {
    return TouristExperience(
      id: json['id'] as String,
      title: json['title'] as String,
      type: ExperienceTypeX.fromKey(json['type'] as String? ?? 'artisanat'),
      description: json['description'] as String? ?? '',
      photoPaths:
          (json['photoPaths'] as List<dynamic>?)?.cast<String>() ?? const [],
      duration: json['duration'] as String?,
      price: (json['price'] as num?)?.toInt(),
      currency: json['currency'] as String? ?? 'XAF',
      destinationId: json['destinationId'] as String,
    );
  }
}
