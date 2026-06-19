// NOTE : Modèle d'un avis utilisateur.
// Stocké en JSON dans SharedPreferences — pas de backend requis (POC offline).
// Concept mis en avant : toJson / fromJson symétriques pour la persistance locale.

class Review {
  final String id; // UUID généré côté client
  final String destinationId; // clé étrangère vers Destination
  final String authorName; // nom libre saisi par l'utilisateur
  final double rating; // 1.0 – 5.0 (demi-étoiles)
  final String comment; // texte libre
  final DateTime createdAt;
  final bool isLocal; // true = rédigé sur cet appareil

  const Review({
    required this.id,
    required this.destinationId,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.isLocal = false,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      destinationId: json['destinationId'] as String,
      authorName: json['authorName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isLocal: (json['isLocal'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'destinationId': destinationId,
        'authorName': authorName,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
        'isLocal': isLocal,
      };

  Review copyWith({
    String? id,
    String? destinationId,
    String? authorName,
    double? rating,
    String? comment,
    DateTime? createdAt,
    bool? isLocal,
  }) {
    return Review(
      id: id ?? this.id,
      destinationId: destinationId ?? this.destinationId,
      authorName: authorName ?? this.authorName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}
