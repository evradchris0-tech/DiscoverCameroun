import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Cameroon'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExperiences.
  ///
  /// In en, this message translates to:
  /// **'Experiences'**
  String get navExperiences;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get navFavorites;

  /// No description provided for @homeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'TOURIST GUIDE'**
  String get homeEyebrow;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover\nCameroon'**
  String get homeTitle;

  /// No description provided for @homeDestinationsToExplore.
  ///
  /// In en, this message translates to:
  /// **'{count} destinations to explore'**
  String homeDestinationsToExplore(int count);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search a destination...'**
  String get searchHint;

  /// No description provided for @destinationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No destination} =1{1 destination} other{{count} destinations}}'**
  String destinationsCount(int count);

  /// No description provided for @emptyNoDestinations.
  ///
  /// In en, this message translates to:
  /// **'No destination found'**
  String get emptyNoDestinations;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @emergencyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Emergency numbers'**
  String get emergencyTooltip;

  /// No description provided for @aboutContent.
  ///
  /// In en, this message translates to:
  /// **'Tourist guide to Cameroonian destinations.\n\nFlutter demonstration project.'**
  String get aboutContent;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map of Cameroon'**
  String get mapTitle;

  /// No description provided for @mapFilterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filter by category'**
  String get mapFilterTooltip;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Favourites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favourites yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark on a destination to save it.'**
  String get favoritesEmptyHint;

  /// No description provided for @experiencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Experiences'**
  String get experiencesTitle;

  /// No description provided for @experiencesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No experience'**
  String get experiencesEmpty;

  /// No description provided for @emergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency numbers'**
  String get emergencyTitle;

  /// No description provided for @emergencyBanner.
  ///
  /// In en, this message translates to:
  /// **'Tap a contact to call immediately. Check local numbers on arrival.'**
  String get emergencyBanner;

  /// No description provided for @emergencyNational.
  ///
  /// In en, this message translates to:
  /// **'National emergencies'**
  String get emergencyNational;

  /// No description provided for @emergencyRegional.
  ///
  /// In en, this message translates to:
  /// **'Regional contacts'**
  String get emergencyRegional;

  /// No description provided for @guidesTitle.
  ///
  /// In en, this message translates to:
  /// **'Guides · {name}'**
  String guidesTitle(String name);

  /// No description provided for @guidesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No guide listed yet.'**
  String get guidesEmpty;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @sectionActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get sectionActivities;

  /// No description provided for @sectionLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get sectionLocation;

  /// No description provided for @sectionPracticalInfo.
  ///
  /// In en, this message translates to:
  /// **'Practical info'**
  String get sectionPracticalInfo;

  /// No description provided for @sectionHowToGet.
  ///
  /// In en, this message translates to:
  /// **'How to get there'**
  String get sectionHowToGet;

  /// No description provided for @sectionTips.
  ///
  /// In en, this message translates to:
  /// **'Tips & recommendations'**
  String get sectionTips;

  /// No description provided for @sectionSeason.
  ///
  /// In en, this message translates to:
  /// **'Best season'**
  String get sectionSeason;

  /// No description provided for @sectionEntryFee.
  ///
  /// In en, this message translates to:
  /// **'Entry fee'**
  String get sectionEntryFee;

  /// No description provided for @sectionGuides.
  ///
  /// In en, this message translates to:
  /// **'Local guides'**
  String get sectionGuides;

  /// No description provided for @sectionExperiences.
  ///
  /// In en, this message translates to:
  /// **'Experiences to live'**
  String get sectionExperiences;

  /// No description provided for @sectionWhereToSleep.
  ///
  /// In en, this message translates to:
  /// **'Where to sleep'**
  String get sectionWhereToSleep;

  /// No description provided for @sectionWhereToEat.
  ///
  /// In en, this message translates to:
  /// **'Where to eat'**
  String get sectionWhereToEat;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get actionCall;

  /// No description provided for @actionWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get actionWhatsApp;

  /// No description provided for @actionDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get actionDirections;

  /// No description provided for @actionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get actionSeeAll;

  /// No description provided for @tooltipCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy info'**
  String get tooltipCopy;

  /// No description provided for @tooltipAddFav.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get tooltipAddFav;

  /// No description provided for @tooltipRemoveFav.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get tooltipRemoveFav;

  /// No description provided for @snackCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get snackCopied;

  /// No description provided for @snackCallFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to start the call'**
  String get snackCallFailed;

  /// No description provided for @snackWhatsappUnavailable.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is not available'**
  String get snackWhatsappUnavailable;

  /// No description provided for @labelFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get labelFree;

  /// No description provided for @labelFrom.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get labelFrom;

  /// No description provided for @labelPerNight.
  ///
  /// In en, this message translates to:
  /// **'/ night'**
  String get labelPerNight;

  /// No description provided for @labelPerDay.
  ///
  /// In en, this message translates to:
  /// **'/ day'**
  String get labelPerDay;

  /// No description provided for @ratingNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get ratingNew;

  /// No description provided for @altitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Altitude: {value} m'**
  String altitudeLabel(int value);

  /// No description provided for @routeFromYou.
  ///
  /// In en, this message translates to:
  /// **'{distance} · {duration} from you'**
  String routeFromYou(String distance, String duration);

  /// No description provided for @routeByCar.
  ///
  /// In en, this message translates to:
  /// **'by car'**
  String get routeByCar;

  /// No description provided for @mapRecenter.
  ///
  /// In en, this message translates to:
  /// **'Recenter'**
  String get mapRecenter;

  /// No description provided for @mapMyLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get mapMyLocation;

  /// No description provided for @mapZoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get mapZoomIn;

  /// No description provided for @mapZoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get mapZoomOut;

  /// No description provided for @actionView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get actionView;

  /// No description provided for @sectionRegions.
  ///
  /// In en, this message translates to:
  /// **'Discover Cameroon by region'**
  String get sectionRegions;

  /// No description provided for @sectionPopularStays.
  ///
  /// In en, this message translates to:
  /// **'Popular stays'**
  String get sectionPopularStays;

  /// No description provided for @priceFrom.
  ///
  /// In en, this message translates to:
  /// **'From {price}'**
  String priceFrom(String price);

  /// No description provided for @regionDestinationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} destination} other{{count} destinations}}'**
  String regionDestinationsCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
