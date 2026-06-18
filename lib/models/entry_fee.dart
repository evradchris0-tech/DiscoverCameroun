// NOTE : Tarif d'entrée d'un site touristique (rubrique « prix d'entrée »).
// Concept mis en avant : Value Object immuable avec un affichage formaté centralisé.

import '../core/format.dart';

class EntryFee {
  final bool isFree;
  final int? residentPrice;
  final int? nonResidentPrice;
  final int? childPrice;
  final String currency; // ISO 4217 — 'XAF' (franc CFA)
  final String? notes;

  const EntryFee({
    this.isFree = false,
    this.residentPrice,
    this.nonResidentPrice,
    this.childPrice,
    this.currency = 'XAF',
    this.notes,
  });

  factory EntryFee.fromJson(Map<String, dynamic> json) {
    return EntryFee(
      isFree: json['isFree'] as bool? ?? false,
      residentPrice: (json['residentPrice'] as num?)?.toInt(),
      nonResidentPrice: (json['nonResidentPrice'] as num?)?.toInt(),
      childPrice: (json['childPrice'] as num?)?.toInt(),
      currency: json['currency'] as String? ?? 'XAF',
      notes: json['notes'] as String?,
    );
  }

  /// Affichage court pour une fiche (ex. « 2 000 – 5 000 FCFA » ou « Gratuit »).
  String get displayPrice {
    if (isFree) return 'Gratuit';
    final prices = [residentPrice, nonResidentPrice]
        .whereType<int>()
        .toList()
      ..sort();
    if (prices.isEmpty) return 'Tarif non communiqué';
    final unit = currency == 'XAF' ? 'FCFA' : currency;
    if (prices.length == 1 || prices.first == prices.last) {
      return '${formatThousands(prices.first)} $unit';
    }
    return '${formatThousands(prices.first)} – ${formatThousands(prices.last)} $unit';
  }
}
