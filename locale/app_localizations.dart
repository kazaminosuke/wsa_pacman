import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ku.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_vi.dart';
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
/// import 'locale/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('ca'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('he'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ku'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('vi'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('zh')
  ];

  /// English (US) [en_US]
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get locale_desc;

  /// Describes the system locale
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get locale_system;

  /// No description provided for @btn_boot.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get btn_boot;

  /// No description provided for @btn_auth.
  ///
  /// In en, this message translates to:
  /// **'Reauthenticate'**
  String get btn_auth;

  /// No description provided for @btn_dev_settings.
  ///
  /// In en, this message translates to:
  /// **'Developer options'**
  String get btn_dev_settings;

  /// No description provided for @btn_switch_on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get btn_switch_on;

  /// No description provided for @btn_switch_off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get btn_switch_off;

  /// Only used inside 'status_unsupported_desc', modify taking this in consideration
  ///
  /// In en, this message translates to:
  /// **'Windows 10'**
  String get status_subtext_winver_10;

  /// Only used inside 'status_unsupported_desc', modify taking this in consideration
  ///
  /// In en, this message translates to:
  /// **'Older Windows Version'**
  String get status_subtext_winver_older;

  /// No description provided for @status_unsupported.
  ///
  /// In en, this message translates to:
  /// **'WSA not installed'**
  String get status_unsupported;

  /// No description provided for @status_unsupported_desc.
  ///
  /// In en, this message translates to:
  /// **'{windowsVersion} detected and WSA not found; this application depends on WSA, which is only officially supported on Windows 11'**
  String status_unsupported_desc(String windowsVersion);

  /// No description provided for @status_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get status_unauthorized;

  /// No description provided for @status_unauthorized_desc.
  ///
  /// In en, this message translates to:
  /// **'Debugging authorization was dismissed or revoked; press the first button, select \'always allow\', then click on \'allow\'; If no popup appears, open developer options and disable and re-enable \'USB debugging\''**
  String get status_unauthorized_desc;

  /// No description provided for @status_missing.
  ///
  /// In en, this message translates to:
  /// **'WSA not installed'**
  String get status_missing;

  /// No description provided for @status_missing_desc.
  ///
  /// In en, this message translates to:
  /// **'WSA not found; this application depends on WSA, please install Windows Subsystem for Android (or the Amazon Appstore) from the Microsoft Store'**
  String get status_missing_desc;

  /// No description provided for @status_unknown.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get status_unknown;

  /// No description provided for @status_unknown_desc.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a WSA connection to be established...'**
  String get status_unknown_desc;

  /// No description provided for @status_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get status_starting;

  /// No description provided for @status_starting_desc.
  ///
  /// In en, this message translates to:
  /// **'WSA is starting, please stand by...'**
  String get status_starting_desc;

  /// No description provided for @status_arrested.
  ///
  /// In en, this message translates to:
  /// **'Arrested'**
  String get status_arrested;

  /// No description provided for @status_arrested_desc.
  ///
  /// In en, this message translates to:
  /// **'WSA is turned off'**
  String get status_arrested_desc;

  /// No description provided for @status_offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get status_offline;

  /// No description provided for @status_offline_desc.
  ///
  /// In en, this message translates to:
  /// **'Could not establish a connection with WSA: either developer mode and USB debugging are disabled or a wrong port is specified'**
  String get status_offline_desc;

  /// No description provided for @status_disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get status_disconnected;

  /// No description provided for @status_disconnected_desc.
  ///
  /// In en, this message translates to:
  /// **'A WSA connection could not be enstablished for unknown reasons'**
  String get status_disconnected_desc;

  /// No description provided for @status_connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get status_connected;

  /// No description provided for @status_connected_desc.
  ///
  /// In en, this message translates to:
  /// **'Successfully connected to WSA, all systems go'**
  String get status_connected_desc;

  /// No description provided for @screen_wsa.
  ///
  /// In en, this message translates to:
  /// **'WSA Package Manager'**
  String get screen_wsa;

  /// No description provided for @screen_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get screen_settings;

  /// No description provided for @wsa_manage.
  ///
  /// In en, this message translates to:
  /// **'Android Management'**
  String get wsa_manage;

  /// No description provided for @wsa_manage_app.
  ///
  /// In en, this message translates to:
  /// **'Manage Applications'**
  String get wsa_manage_app;

  /// No description provided for @wsa_manage_settings.
  ///
  /// In en, this message translates to:
  /// **'Manage Settings'**
  String get wsa_manage_settings;

  /// No description provided for @settings_port.
  ///
  /// In en, this message translates to:
  /// **'WSA Port'**
  String get settings_port;

  /// No description provided for @settings_ip.
  ///
  /// In en, this message translates to:
  /// **'WSA IP address'**
  String get settings_ip;

  /// No description provided for @settings_autostart.
  ///
  /// In en, this message translates to:
  /// **'Autostart WSA before installation'**
  String get settings_autostart;

  /// No description provided for @settings_timeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout ({seconds} seconds)'**
  String settings_timeout(String seconds);

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_option_generic_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_option_generic_system;

  /// No description provided for @settings_option_generic_disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settings_option_generic_disabled;

  /// No description provided for @theme_mode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get theme_mode;

  /// No description provided for @theme_mode_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_mode_dark;

  /// No description provided for @theme_mode_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_mode_light;

  /// No description provided for @theme_mica.
  ///
  /// In en, this message translates to:
  /// **'Window transparency'**
  String get theme_mica;

  /// No description provided for @theme_mica_full.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get theme_mica_full;

  /// No description provided for @theme_mica_partial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get theme_mica_partial;

  /// No description provided for @theme_icon_adaptive.
  ///
  /// In en, this message translates to:
  /// **'Adaptive icons Shape'**
  String get theme_icon_adaptive;

  /// No description provided for @theme_icon_adaptive_squircle.
  ///
  /// In en, this message translates to:
  /// **'Squircle'**
  String get theme_icon_adaptive_squircle;

  /// No description provided for @theme_icon_adaptive_circle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get theme_icon_adaptive_circle;

  /// No description provided for @theme_icon_adaptive_rounded_square.
  ///
  /// In en, this message translates to:
  /// **'Rounded Square'**
  String get theme_icon_adaptive_rounded_square;

  /// No description provided for @installer_message.
  ///
  /// In en, this message translates to:
  /// **'Do you want to install this application?'**
  String get installer_message;

  /// No description provided for @installer_info_version.
  ///
  /// In en, this message translates to:
  /// **'Version: {appVersion}'**
  String installer_info_version(String appVersion);

  /// No description provided for @installer_info_version_change.
  ///
  /// In en, this message translates to:
  /// **'Version: {appVersionOld} => {appVersionNew}'**
  String installer_info_version_change(
      String appVersionOld, String appVersionNew);

  /// No description provided for @installer_info_package.
  ///
  /// In en, this message translates to:
  /// **'Package: {appPackage}'**
  String installer_info_package(String appPackage);

  /// No description provided for @installer_installing.
  ///
  /// In en, this message translates to:
  /// **'Installing application {appTitle}...'**
  String installer_installing(String appTitle);

  /// No description provided for @installer_installed.
  ///
  /// In en, this message translates to:
  /// **'The application {appTitle} was successfully installed'**
  String installer_installed(String appTitle);

  /// No description provided for @installer_fail.
  ///
  /// In en, this message translates to:
  /// **'The application {appTitle} was not installed'**
  String installer_fail(String appTitle);

  /// No description provided for @installer_error_nomsg.
  ///
  /// In en, this message translates to:
  /// **'The installation has failed, but no error was thrown'**
  String get installer_error_nomsg;

  /// No description provided for @installer_error_timeout.
  ///
  /// In en, this message translates to:
  /// **'Installation timed out, client has stopped waiting, but it may still be in progress in the background...'**
  String get installer_error_timeout;

  /// No description provided for @installer_warning_dirty.
  ///
  /// In en, this message translates to:
  /// **'A manual file cleanup is needed in directory “{tempDir}”'**
  String installer_warning_dirty(String tempDir);

  /// No description provided for @installer_btn_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting...'**
  String get installer_btn_starting;

  /// No description provided for @installer_btn_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get installer_btn_loading;

  /// No description provided for @installer_btn_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get installer_btn_cancel;

  /// No description provided for @installer_btn_install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get installer_btn_install;

  /// No description provided for @installer_btn_reinstall.
  ///
  /// In en, this message translates to:
  /// **'Reinstall'**
  String get installer_btn_reinstall;

  /// No description provided for @installer_btn_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get installer_btn_update;

  /// No description provided for @installer_btn_downgrade.
  ///
  /// In en, this message translates to:
  /// **'Downgrade (unsafe)'**
  String get installer_btn_downgrade;

  /// No description provided for @installer_btn_dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get installer_btn_dismiss;

  /// No description provided for @installer_btn_open.
  ///
  /// In en, this message translates to:
  /// **'Open app'**
  String get installer_btn_open;

  /// No description provided for @installer_btn_checkbox_shortcut.
  ///
  /// In en, this message translates to:
  /// **'Create desktop shortcut'**
  String get installer_btn_checkbox_shortcut;

  /// No description provided for @android_permission_none.
  ///
  /// In en, this message translates to:
  /// **'No permissions required'**
  String get android_permission_none;

  /// No description provided for @android_permission_admin.
  ///
  /// In en, this message translates to:
  /// **'Manage device as administrator'**
  String get android_permission_admin;

  /// No description provided for @android_permission_admin_brick.
  ///
  /// In en, this message translates to:
  /// **'Remotely disable or reset device'**
  String get android_permission_admin_brick;

  /// No description provided for @android_permission_admin_lock.
  ///
  /// In en, this message translates to:
  /// **'Remotely lock device'**
  String get android_permission_admin_lock;

  /// No description provided for @android_permission_storage.
  ///
  /// In en, this message translates to:
  /// **'Files and media'**
  String get android_permission_storage;

  /// No description provided for @android_permission_microphone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get android_permission_microphone;

  /// No description provided for @android_permission_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get android_permission_camera;

  /// No description provided for @android_permission_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get android_permission_location;

  /// No description provided for @android_permission_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get android_permission_phone;

  /// No description provided for @android_permission_call_log.
  ///
  /// In en, this message translates to:
  /// **'Call logs'**
  String get android_permission_call_log;

  /// No description provided for @android_permission_sms.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get android_permission_sms;

  /// No description provided for @android_permission_contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get android_permission_contacts;

  /// No description provided for @android_permission_calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get android_permission_calendar;

  /// No description provided for @android_permission_activity_recognition.
  ///
  /// In en, this message translates to:
  /// **'Physical activity'**
  String get android_permission_activity_recognition;

  /// No description provided for @android_permission_sensors.
  ///
  /// In en, this message translates to:
  /// **'Device sensors'**
  String get android_permission_sensors;

  /// No description provided for @android_permission_sensors_body.
  ///
  /// In en, this message translates to:
  /// **'Body sensors'**
  String get android_permission_sensors_body;

  /// No description provided for @android_permission_nearby_devices.
  ///
  /// In en, this message translates to:
  /// **'Locate nearby devices'**
  String get android_permission_nearby_devices;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'ca',
        'de',
        'en',
        'es',
        'fa',
        'fr',
        'he',
        'id',
        'it',
        'ja',
        'ko',
        'ku',
        'pl',
        'pt',
        'ru',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'ca':
      return AppLocalizationsCa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ku':
      return AppLocalizationsKu();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
