import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'i10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// The App's Title
  ///
  /// In en, this message translates to:
  /// **'Book Shelf'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @visitorLogin.
  ///
  /// In en, this message translates to:
  /// **'Visitor Login'**
  String get visitorLogin;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @bookRack.
  ///
  /// In en, this message translates to:
  /// **'Book Shelf'**
  String get bookRack;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @serviceError.
  ///
  /// In en, this message translates to:
  /// **'Service Error:'**
  String get serviceError;

  /// No description provided for @dataFormatError.
  ///
  /// In en, this message translates to:
  /// **'Data format error'**
  String get dataFormatError;

  /// No description provided for @loadingFailure.
  ///
  /// In en, this message translates to:
  /// **'Loading failed'**
  String get loadingFailure;

  /// No description provided for @responseStatusCode.
  ///
  /// In en, this message translates to:
  /// **'Response status code: '**
  String get responseStatusCode;

  /// No description provided for @sslHandshakeFailed.
  ///
  /// In en, this message translates to:
  /// **'SSL handshake failed: '**
  String get sslHandshakeFailed;

  /// No description provided for @networkConnectionFailure.
  ///
  /// In en, this message translates to:
  /// **'Network connection failed: '**
  String get networkConnectionFailure;

  /// No description provided for @networkConnectionFailureTip.
  ///
  /// In en, this message translates to:
  /// **'Network connection failed, please check network settings'**
  String get networkConnectionFailureTip;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error: '**
  String get unknownError;

  /// No description provided for @requestTimedOutTip.
  ///
  /// In en, this message translates to:
  /// **'Request timed out, please retry'**
  String get requestTimedOutTip;

  /// No description provided for @dataParsingFailed.
  ///
  /// In en, this message translates to:
  /// **'Data parsing failed'**
  String get dataParsingFailed;

  /// No description provided for @networkAgentSettings.
  ///
  /// In en, this message translates to:
  /// **'Network proxy settings'**
  String get networkAgentSettings;

  /// No description provided for @enableProxyServer.
  ///
  /// In en, this message translates to:
  /// **'Enable proxy server'**
  String get enableProxyServer;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Save configuration'**
  String get saveConfiguration;

  /// No description provided for @proxyAddress.
  ///
  /// In en, this message translates to:
  /// **'Proxy address'**
  String get proxyAddress;

  /// No description provided for @proxyPort.
  ///
  /// In en, this message translates to:
  /// **'Proxy Port'**
  String get proxyPort;

  /// No description provided for @proxyAddressTip.
  ///
  /// In en, this message translates to:
  /// **'Proxy address must be filled in'**
  String get proxyAddressTip;

  /// No description provided for @authenticationOptional.
  ///
  /// In en, this message translates to:
  /// **'Authentication Information (Optional)'**
  String get authenticationOptional;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get testConnection;

  /// No description provided for @proxyPortTip.
  ///
  /// In en, this message translates to:
  /// **'Port number must be filled in'**
  String get proxyPortTip;

  /// No description provided for @figuresTip.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numbers'**
  String get figuresTip;

  /// No description provided for @portInvalidTip.
  ///
  /// In en, this message translates to:
  /// **'Port number invalid (1-65535)'**
  String get portInvalidTip;

  /// No description provided for @connectionTestSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Connection test successful'**
  String get connectionTestSuccessful;

  /// No description provided for @connectionTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection test failed'**
  String get connectionTestFailed;

  /// No description provided for @firstPublished.
  ///
  /// In en, this message translates to:
  /// **'First published in'**
  String get firstPublished;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @subjectClassification.
  ///
  /// In en, this message translates to:
  /// **'Subject classification'**
  String get subjectClassification;

  /// No description provided for @removeFromBookshelf.
  ///
  /// In en, this message translates to:
  /// **'Remove from bookshelf'**
  String get removeFromBookshelf;

  /// No description provided for @addToBookshelf.
  ///
  /// In en, this message translates to:
  /// **'Add to bookshelf'**
  String get addToBookshelf;

  /// No description provided for @removedFromBookshelf.
  ///
  /// In en, this message translates to:
  /// **'Removed from bookshelf'**
  String get removedFromBookshelf;

  /// No description provided for @addedToBookshelf.
  ///
  /// In en, this message translates to:
  /// **'Added to bookshelf'**
  String get addedToBookshelf;

  /// No description provided for @myBookshelf.
  ///
  /// In en, this message translates to:
  /// **'My bookshelf'**
  String get myBookshelf;

  /// No description provided for @searchBookshelfTip.
  ///
  /// In en, this message translates to:
  /// **'Search by title or author'**
  String get searchBookshelfTip;

  /// No description provided for @noBooksAvailable.
  ///
  /// In en, this message translates to:
  /// **'No books available'**
  String get noBooksAvailable;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get confirmDeletion;

  /// No description provided for @sureDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get sureDelete;

  /// No description provided for @bookMarkLeft.
  ///
  /// In en, this message translates to:
  /// **'\''**
  String get bookMarkLeft;

  /// No description provided for @bookMarkRight.
  ///
  /// In en, this message translates to:
  /// **'\''**
  String get bookMarkRight;

  /// No description provided for @questionMark.
  ///
  /// In en, this message translates to:
  /// **'?'**
  String get questionMark;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deletionFailed.
  ///
  /// In en, this message translates to:
  /// **'Deletion failed: '**
  String get deletionFailed;

  /// No description provided for @searchBooks.
  ///
  /// In en, this message translates to:
  /// **'Search books...'**
  String get searchBooks;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noPopularBooksAvailable.
  ///
  /// In en, this message translates to:
  /// **'No popular books available'**
  String get noPopularBooksAvailable;

  /// No description provided for @resultNotFound.
  ///
  /// In en, this message translates to:
  /// **'No results found: '**
  String get resultNotFound;

  /// No description provided for @setProxy.
  ///
  /// In en, this message translates to:
  /// **'Set proxy'**
  String get setProxy;

  /// No description provided for @registerImplemented.
  ///
  /// In en, this message translates to:
  /// **'Registration feature not implemented'**
  String get registerImplemented;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
