// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'KmerTour';

  @override
  String get navHome => 'Accueil';

  @override
  String get navExperiences => 'Expériences';

  @override
  String get navMap => 'Carte';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get homeEyebrow => 'GUIDE TOURISTIQUE';

  @override
  String get homeTitle => 'Découvrez\nle Cameroun';

  @override
  String homeDestinationsToExplore(int count) {
    return '$count destinations à explorer';
  }

  @override
  String get searchHint => 'Rechercher une destination...';

  @override
  String destinationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinations',
      one: '1 destination',
      zero: 'Aucune destination',
    );
    return '$_temp0';
  }

  @override
  String get emptyNoDestinations => 'Aucune destination trouvée';

  @override
  String get filterAll => 'Tout';

  @override
  String get emergencyTooltip => 'Numéros d\'urgence';

  @override
  String get aboutContent =>
      'Guide touristique des destinations camerounaises.\n\nProjet Flutter de démonstration.';

  @override
  String get actionClose => 'Fermer';

  @override
  String get mapTitle => 'Carte du Cameroun';

  @override
  String get mapFilterTooltip => 'Filtrer par catégorie';

  @override
  String get favoritesTitle => 'Mes Favoris';

  @override
  String get favoritesEmptyTitle => 'Aucun favori pour l\'instant';

  @override
  String get favoritesEmptyHint =>
      'Appuyez sur le signet d\'une destination pour la sauvegarder.';

  @override
  String get experiencesTitle => 'Expériences';

  @override
  String get experiencesEmpty => 'Aucune expérience';

  @override
  String get emergencyTitle => 'Numéros d\'urgence';

  @override
  String get emergencyBanner =>
      'Appuyez sur un contact pour appeler immédiatement. Vérifiez les numéros locaux à votre arrivée.';

  @override
  String get emergencyNational => 'Urgences nationales';

  @override
  String get emergencyRegional => 'Contacts régionaux';

  @override
  String guidesTitle(String name) {
    return 'Guides · $name';
  }

  @override
  String get guidesEmpty => 'Aucun guide référencé pour le moment.';

  @override
  String get sectionAbout => 'À propos';

  @override
  String get sectionActivities => 'Activités';

  @override
  String get sectionLocation => 'Localisation';

  @override
  String get sectionPracticalInfo => 'Infos pratiques';

  @override
  String get sectionHowToGet => 'Comment s\'y rendre';

  @override
  String get sectionTips => 'Conseils & recommandations';

  @override
  String get sectionSeason => 'Saison appropriée';

  @override
  String get sectionEntryFee => 'Prix d\'entrée';

  @override
  String get sectionGuides => 'Guides locaux';

  @override
  String get sectionExperiences => 'Expériences à vivre';

  @override
  String get sectionWhereToSleep => 'Où dormir';

  @override
  String get sectionWhereToEat => 'Où manger';

  @override
  String get actionBack => 'Retour';

  @override
  String get actionCall => 'Appeler';

  @override
  String get actionWhatsApp => 'WhatsApp';

  @override
  String get actionDirections => 'Itinéraire';

  @override
  String get actionSeeAll => 'Voir tout';

  @override
  String get tooltipCopy => 'Copier les infos';

  @override
  String get tooltipAddFav => 'Ajouter aux favoris';

  @override
  String get tooltipRemoveFav => 'Retirer des favoris';

  @override
  String get snackCopied => 'Copié dans le presse-papiers';

  @override
  String get snackCallFailed => 'Impossible de lancer l\'appel';

  @override
  String get snackWhatsappUnavailable => 'WhatsApp n\'est pas disponible';

  @override
  String get labelFree => 'Gratuit';

  @override
  String get labelFrom => 'dès';

  @override
  String get labelPerNight => '/ nuit';

  @override
  String get labelPerDay => '/ jour';

  @override
  String get ratingNew => 'Nouveau';

  @override
  String altitudeLabel(int value) {
    return 'Altitude : $value m';
  }

  @override
  String routeFromYou(String distance, String duration) {
    return '$distance · $duration depuis vous';
  }

  @override
  String get routeByCar => 'en voiture';

  @override
  String get mapRecenter => 'Recentrer';

  @override
  String get mapMyLocation => 'Ma position';

  @override
  String get mapZoomIn => 'Zoom avant';

  @override
  String get mapZoomOut => 'Zoom arrière';

  @override
  String get mapLayers => 'Type de carte';

  @override
  String get actionView => 'Voir';

  @override
  String get actionShare => 'Partager';

  @override
  String get actionBook => 'Réserver';

  @override
  String get actionBookGuide => 'Réserver ce guide';

  @override
  String get sectionRegions => 'Découvrir le Cameroun par région';

  @override
  String get sectionPopularStays => 'Séjours populaires';

  @override
  String priceFrom(String price) {
    return 'À partir de $price';
  }

  @override
  String regionDestinationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinations',
      one: '$count destination',
    );
    return '$_temp0';
  }

  @override
  String get allDestinationsTitle => 'Toutes les destinations';

  @override
  String get menuTitle => 'Menu';

  @override
  String get navProfile => 'Profil';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileTraveler => 'Voyageur';

  @override
  String get profileTagline => 'Explorez le Cameroun';

  @override
  String get statDestinations => 'Destinations';

  @override
  String get statFavorites => 'Favoris';

  @override
  String get profileLanguage => 'Langue';

  @override
  String get profileAbout => 'À propos';

  @override
  String get profileMyFavorites => 'Mes favoris';

  @override
  String get profileHelp => 'Aide & contact';

  @override
  String get profileShare => 'Partager l\'application';

  @override
  String get profileGroupAccount => 'Mon espace';

  @override
  String get profileGroupPreferences => 'Préférences';

  @override
  String get profileGroupSupport => 'Aide & infos';

  @override
  String get shareAppText =>
      'Découvre le Cameroun avec KmerTour — le guide touristique des 50 destinations du pays.';

  @override
  String shareDestinationText(String name, String region) {
    return '$name ($region) — à découvrir sur KmerTour.';
  }

  @override
  String get sectionSponsors => 'Nos partenaires';

  @override
  String get navDiscover => 'Découvrir';

  @override
  String get searchGeneric => 'Rechercher…';

  @override
  String get tabHotels => 'Hôtels';

  @override
  String get tabRestaurants => 'Restaurants';

  @override
  String get tabGuides => 'Guides';

  @override
  String get accommodationsEmpty => 'Aucun hébergement référencé.';

  @override
  String get restaurantsEmpty => 'Aucun restaurant référencé.';

  @override
  String get sectionReviews => 'Avis & Notes';

  @override
  String get reviewsEmpty => 'Aucun avis pour le moment';

  @override
  String get reviewsEmptyHint =>
      'Soyez le premier à partager votre expérience !';

  @override
  String get reviewWriteButton => 'Laisser un avis';

  @override
  String get reviewAddButton => 'Ajouter un avis';

  @override
  String get reviewAuthorHint => 'Votre prénom / pseudo';

  @override
  String get reviewCommentHint => 'Votre expérience…';

  @override
  String get reviewPublish => 'Publier l\'avis';

  @override
  String get reviewDelete => 'Supprimer';

  @override
  String get reviewMeLabel => 'Moi';

  @override
  String get reviewNoteLabel => 'Note';

  @override
  String get bookingTitle => 'Réserver';

  @override
  String get bookingStepWho => 'Vos coordonnées';

  @override
  String get bookingStepWhen => 'Dates & détails';

  @override
  String get bookingStepConfirm => 'Confirmation';

  @override
  String get bookingNext => 'Suivant';

  @override
  String get bookingBack => 'Retour';

  @override
  String get bookingModify => '← Modifier';

  @override
  String get bookingSendWhatsApp => 'Envoyer via WhatsApp';

  @override
  String get bookingButtonLabel => 'Réserver';

  @override
  String get bookingGuideButtonLabel => 'Réserver ce guide';

  @override
  String get bookingSnackSuccess => 'Demande envoyée via WhatsApp !';

  @override
  String get bookingSnackNoWhatsApp =>
      'WhatsApp n\'est pas disponible sur cet appareil.';
}
