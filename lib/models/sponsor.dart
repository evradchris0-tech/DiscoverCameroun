// NOTE : Partenaire / sponsor de l'application (modèle de revenus du POC).

class Sponsor {
  final String id;
  final String name;
  final String category; // ex. « Boissons & Brasserie »
  final String description;
  final String? imageUrl;

  const Sponsor({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.imageUrl,
  });

  factory Sponsor.fromJson(Map<String, dynamic> json) => Sponsor(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String?,
      );
}
