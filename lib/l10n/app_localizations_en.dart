// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Discover Cameroon';

  @override
  String get navHome => 'Home';

  @override
  String get navExperiences => 'Experiences';

  @override
  String get navMap => 'Map';

  @override
  String get navFavorites => 'Favourites';

  @override
  String get homeEyebrow => 'TOURIST GUIDE';

  @override
  String get homeTitle => 'Discover\nCameroon';

  @override
  String homeDestinationsToExplore(int count) {
    return '$count destinations to explore';
  }

  @override
  String get searchHint => 'Search a destination...';

  @override
  String destinationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinations',
      one: '1 destination',
      zero: 'No destination',
    );
    return '$_temp0';
  }

  @override
  String get emptyNoDestinations => 'No destination found';

  @override
  String get filterAll => 'All';

  @override
  String get emergencyTooltip => 'Emergency numbers';

  @override
  String get aboutContent =>
      'Tourist guide to Cameroonian destinations.\n\nFlutter demonstration project.';

  @override
  String get actionClose => 'Close';

  @override
  String get mapTitle => 'Map of Cameroon';

  @override
  String get mapFilterTooltip => 'Filter by category';

  @override
  String get favoritesTitle => 'My Favourites';

  @override
  String get favoritesEmptyTitle => 'No favourites yet';

  @override
  String get favoritesEmptyHint =>
      'Tap the bookmark on a destination to save it.';

  @override
  String get experiencesTitle => 'Experiences';

  @override
  String get experiencesEmpty => 'No experience';

  @override
  String get emergencyTitle => 'Emergency numbers';

  @override
  String get emergencyBanner =>
      'Tap a contact to call immediately. Check local numbers on arrival.';

  @override
  String get emergencyNational => 'National emergencies';

  @override
  String get emergencyRegional => 'Regional contacts';

  @override
  String guidesTitle(String name) {
    return 'Guides · $name';
  }

  @override
  String get guidesEmpty => 'No guide listed yet.';

  @override
  String get sectionAbout => 'About';

  @override
  String get sectionActivities => 'Activities';

  @override
  String get sectionLocation => 'Location';

  @override
  String get sectionPracticalInfo => 'Practical info';

  @override
  String get sectionHowToGet => 'How to get there';

  @override
  String get sectionTips => 'Tips & recommendations';

  @override
  String get sectionSeason => 'Best season';

  @override
  String get sectionEntryFee => 'Entry fee';

  @override
  String get sectionGuides => 'Local guides';

  @override
  String get sectionExperiences => 'Experiences to live';

  @override
  String get sectionWhereToSleep => 'Where to sleep';

  @override
  String get sectionWhereToEat => 'Where to eat';

  @override
  String get actionBack => 'Back';

  @override
  String get actionCall => 'Call';

  @override
  String get actionWhatsApp => 'WhatsApp';

  @override
  String get actionDirections => 'Directions';

  @override
  String get actionSeeAll => 'See all';

  @override
  String get tooltipCopy => 'Copy info';

  @override
  String get tooltipAddFav => 'Add to favourites';

  @override
  String get tooltipRemoveFav => 'Remove from favourites';

  @override
  String get snackCopied => 'Copied to clipboard';

  @override
  String get snackCallFailed => 'Unable to start the call';

  @override
  String get snackWhatsappUnavailable => 'WhatsApp is not available';

  @override
  String get labelFree => 'Free';

  @override
  String get labelFrom => 'from';

  @override
  String get labelPerNight => '/ night';

  @override
  String get labelPerDay => '/ day';

  @override
  String get ratingNew => 'New';

  @override
  String altitudeLabel(int value) {
    return 'Altitude: $value m';
  }

  @override
  String routeFromYou(String distance, String duration) {
    return '$distance · $duration from you';
  }

  @override
  String get routeByCar => 'by car';

  @override
  String get mapRecenter => 'Recenter';

  @override
  String get mapMyLocation => 'My location';

  @override
  String get mapZoomIn => 'Zoom in';

  @override
  String get mapZoomOut => 'Zoom out';

  @override
  String get mapLayers => 'Map type';

  @override
  String get actionView => 'View';

  @override
  String get sectionRegions => 'Discover Cameroon by region';

  @override
  String get sectionPopularStays => 'Popular stays';

  @override
  String priceFrom(String price) {
    return 'From $price';
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
  String get navProfile => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileTraveler => 'Traveller';

  @override
  String get profileTagline => 'Explore Cameroon';

  @override
  String get statDestinations => 'Destinations';

  @override
  String get statFavorites => 'Favorites';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileAbout => 'About';

  @override
  String get sectionSponsors => 'Our partners';

  @override
  String get navDiscover => 'Discover';

  @override
  String get tabHotels => 'Hotels';

  @override
  String get tabRestaurants => 'Restaurants';

  @override
  String get tabGuides => 'Guides';

  @override
  String get accommodationsEmpty => 'No accommodation listed.';

  @override
  String get restaurantsEmpty => 'No restaurant listed.';
}
