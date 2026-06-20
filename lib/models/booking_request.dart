// NOTE : Modèle d'une demande de réservation.
// Concerne aussi bien un hébergement, une expérience, qu'un guide.
// Concept mis en avant : type discriminant (BookingType) pour un seul modèle générique.

enum BookingType { accommodation, experience, guide }

extension BookingTypeX on BookingType {
  String get label {
    switch (this) {
      case BookingType.accommodation: return 'Hébergement';
      case BookingType.experience:    return 'Expérience';
      case BookingType.guide:         return 'Guide';
    }
  }
}

class BookingRequest {
  final BookingType type;
  final String itemName;         // nom de l'hébergement / expérience / guide
  final String destinationName;  // nom de la destination concernée
  final String guestName;
  final String guestPhone;       // numéro du voyageur (facultatif)
  final DateTime arrivalDate;
  final int nights;              // 0 pour les expériences (1 journée)
  final int guests;
  final String? message;         // message libre optionnel

  const BookingRequest({
    required this.type,
    required this.itemName,
    required this.destinationName,
    required this.guestName,
    required this.guestPhone,
    required this.arrivalDate,
    this.nights = 1,
    this.guests = 1,
    this.message,
  });

  /// Génère le message WhatsApp pré-rempli.
  String toWhatsAppText() {
    final dateStr =
        '${arrivalDate.day.toString().padLeft(2, '0')}/'
        '${arrivalDate.month.toString().padLeft(2, '0')}/'
        '${arrivalDate.year}';

    final buf = StringBuffer();
    buf.writeln('Bonjour, je vous contacte via *KmerTour*.');
    buf.writeln();
    buf.writeln('*Demande de réservation — ${type.label}*');
    buf.writeln('Destination : *$destinationName*');
    buf.writeln('${type.label} : *$itemName*');
    buf.writeln('Nom : $guestName');
    if (guestPhone.isNotEmpty) buf.writeln('Mon numéro : $guestPhone');
    buf.writeln('Arrivée : $dateStr');
    if (nights > 0) buf.writeln('Durée : $nights nuit${nights > 1 ? 's' : ''}');
    buf.writeln('Voyageurs : $guests personne${guests > 1 ? 's' : ''}');
    if (message != null && message!.isNotEmpty) {
      buf.writeln();
      buf.writeln('Message : $message');
    }
    buf.writeln();
    buf.writeln('Merci de me confirmer la disponibilité.');
    return buf.toString().trim();
  }
}
