// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Discover Cameroon';

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
  String get actionView => 'Voir';

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
}
