// NOTE : Modèle enrichi d'une destination touristique avec coordonnées, activités,
// saison, tarif d'entrée, conseils, transports et liens vers les autres rubriques.
// Concept mis en avant : factory `fromJson` tolérante (champs optionnels avec défauts).

import '../enums/destination_category.dart';
import 'entry_fee.dart';
import 'season.dart';
import 'transport_option.dart';

class Destination {
  final String id;
  final String name;
  final String description;
  final String imagePath; // image asset locale (peut être vide si imageUrl fourni)
  final List<String> imagePaths; // galerie d'images assets
  final String? imageUrl; // image distante (réseau) — schéma « 50 destinations »
  final List<String> imageUrls; // galerie distante
  final DestinationCategory category;
  final String region;
  final double? altitude;
  final List<String> activities; // activités proposées
  final double latitude;
  final double longitude;

  // --- Accroche commerciale (« Séjours populaires ») ---------------------
  final String? titreAccroche; // phrase d'accroche
  final String? duree; // ex. « 3 jours / 2 nuits »
  final int? prixAppel; // prix d'appel en FCFA

  // --- Rubriques enrichies (POC startup) ---------------------------------
  final List<Season> bestSeasons; // saison appropriée
  final String? seasonAdvice; // conseil saisonnier libre
  final EntryFee? entryFee; // prix d'entrée du site
  final List<String> tips; // conseils & recommandations
  final List<TransportOption> transportOptions; // moyens de locomotion

  // --- Relations (clés étrangères vers les autres entités) ---------------
  final List<String> guideIds;
  final List<String> accommodationIds;
  final List<String> restaurantIds;
  final List<String> experienceIds;

  const Destination({
    required this.id,
    required this.name,
    required this.description,
    this.imagePath = '',
    this.imagePaths = const [],
    this.imageUrl,
    this.imageUrls = const [],
    required this.category,
    required this.region,
    this.altitude,
    required this.activities,
    required this.latitude,
    required this.longitude,
    this.titreAccroche,
    this.duree,
    this.prixAppel,
    this.bestSeasons = const [],
    this.seasonAdvice,
    this.entryFee,
    this.tips = const [],
    this.transportOptions = const [],
    this.guideIds = const [],
    this.accommodationIds = const [],
    this.restaurantIds = const [],
    this.experienceIds = const [],
  });

  // Convertit un Map JSON en objet Destination typé.
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: (json['imagePath'] as String?) ?? '',
      imagePaths:
          (json['imagePaths'] as List<dynamic>?)?.cast<String>() ?? const [],
      imageUrl: json['imageUrl'] as String?,
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)?.cast<String>() ?? const [],
      category: _categoryFromString(json['category'] as String),
      region: json['region'] as String,
      altitude: (json['altitude'] as num?)?.toDouble(),
      activities:
          (json['activities'] as List<dynamic>?)?.cast<String>() ?? const [],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      titreAccroche: json['titre_accroche'] as String?,
      duree: json['duree'] as String?,
      prixAppel: (json['prix_appel'] as num?)?.toInt(),
      bestSeasons: (json['bestSeasons'] as List<dynamic>?)
              ?.map((e) => SeasonX.fromKey(e as String))
              .toList() ??
          const [],
      seasonAdvice: json['seasonAdvice'] as String?,
      entryFee: json['entryFee'] == null
          ? null
          : EntryFee.fromJson(json['entryFee'] as Map<String, dynamic>),
      tips: (json['tips'] as List<dynamic>?)?.cast<String>() ?? const [],
      transportOptions: (json['transportOptions'] as List<dynamic>?)
              ?.map((e) =>
                  TransportOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      guideIds:
          (json['guideIds'] as List<dynamic>?)?.cast<String>() ?? const [],
      accommodationIds:
          (json['accommodationIds'] as List<dynamic>?)?.cast<String>() ??
              const [],
      restaurantIds:
          (json['restaurantIds'] as List<dynamic>?)?.cast<String>() ??
              const [],
      experienceIds:
          (json['experienceIds'] as List<dynamic>?)?.cast<String>() ??
              const [],
    );
  }

  static DestinationCategory _categoryFromString(String value) {
    switch (value) {
      case 'plage':     return DestinationCategory.plage;
      case 'montagne':  return DestinationCategory.montagne;
      case 'ville':     return DestinationCategory.ville;
      case 'foret':     return DestinationCategory.foret;
      case 'parc':      return DestinationCategory.parc;
      default:          return DestinationCategory.ville;
    }
  }

  String get shortSummary => '${category.label} — $region';

  /// Image de couverture : distante si fournie, sinon asset locale.
  /// Une URL commence par « http », sinon c'est un chemin d'asset.
  String get cover {
    if (imageUrl != null && imageUrl!.isNotEmpty) return imageUrl!;
    if (imageUrls.isNotEmpty) return imageUrls.first;
    return imagePath;
  }

  /// Galerie unifiée (distante ou locale selon ce qui est disponible).
  List<String> get gallery {
    if (imageUrls.isNotEmpty) return imageUrls;
    if (imagePaths.isNotEmpty) return imagePaths;
    return cover.isEmpty ? const [] : [cover];
  }
}
