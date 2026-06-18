// NOTE : Contact d'urgence (rubrique « contacts d'urgence »).
// Concept mis en avant : portée nationale/régionale + numéro composable (tap-to-call).
//
// ATTENTION : les numéros fournis dans le JSON doivent être VALIDÉS avant la mise en production.

enum EmergencyScope { national, regional }

extension EmergencyScopeX on EmergencyScope {
  String get label =>
      this == EmergencyScope.national ? 'National' : 'Régional';

  static EmergencyScope fromKey(String value) =>
      value == 'regional' ? EmergencyScope.regional : EmergencyScope.national;
}

class EmergencyContact {
  final String id;
  final String label; // ex. « Police secours »
  final String number; // ex. « 117 »
  final EmergencyScope scope;
  final String? region; // si régional
  final String? notes; // ex. « À vérifier »

  const EmergencyContact({
    required this.id,
    required this.label,
    required this.number,
    this.scope = EmergencyScope.national,
    this.region,
    this.notes,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String,
      label: json['label'] as String,
      number: json['number'] as String,
      scope: EmergencyScopeX.fromKey(json['scope'] as String? ?? 'national'),
      region: json['region'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
