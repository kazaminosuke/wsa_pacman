// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get locale_desc => 'Polski';

  @override
  String get locale_system => 'Systemowy';

  @override
  String get btn_boot => 'Włącz';

  @override
  String get btn_auth => 'Ponownie uwierzytelnij';

  @override
  String get btn_dev_settings => 'Opcje dla programistów';

  @override
  String get btn_switch_on => 'Wł.';

  @override
  String get btn_switch_off => 'Wył.';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'Starsza wersja systemu Windows';

  @override
  String get status_unsupported => 'WSA nie jest zainstalowany';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return 'Wykryto $windowsVersion i nie znaleziono WSA; ta aplikacja jest zależna od WSA, który jest oficjalnie wspierany tylko w systemie Windows 11';
  }

  @override
  String get status_unauthorized => 'Nieupoważniony';

  @override
  String get status_unauthorized_desc =>
      'Autoryzacja debugowania została odrzucona lub cofnięta; naciśnij pierwszy przycisk, wybierz \'zawsze zezwalaj\' i kliknij \'zezwól\'; jeśli nie pojawi się okno dialogowe, otwórz opcje dla programistów i wyłącz i włącz ponownie \'debugowanie USB\'';

  @override
  String get status_missing => 'WSA nie jest zainstalowany';

  @override
  String get status_missing_desc =>
      'Nie znaleziono WSA; ta aplikacja jest zależna od WSA, zainstaluj Podsystem Windows dla systemu Android (lub Amazon Appstore) ze sklepu Microsoft Store';

  @override
  String get status_unknown => 'Łączenie';

  @override
  String get status_unknown_desc =>
      'Oczekiwanie na nawiązanie połączenia z WSA...';

  @override
  String get status_starting => 'Uruchamianie';

  @override
  String get status_starting_desc => 'WSA uruchamia się, proszę czekać...';

  @override
  String get status_arrested => 'Zatrzymany';

  @override
  String get status_arrested_desc => 'WSA jest wyłączony';

  @override
  String get status_offline => 'Offline';

  @override
  String get status_offline_desc =>
      'Nie można nawiązać połączenia z WSA: tryb programisty i debugowanie USB są wyłączone lub podano niewłaściwy port';

  @override
  String get status_disconnected => 'Odłączony';

  @override
  String get status_disconnected_desc =>
      'Z nieznanych przyczyn nie udało się nawiązać połączenia z WSA';

  @override
  String get status_connected => 'Połączony';

  @override
  String get status_connected_desc =>
      'Pomyślnie połączono z WSA, wszystkie systemy działają';

  @override
  String get screen_wsa => 'Menedżer pakietów WSA';

  @override
  String get screen_settings => 'Ustawienia';

  @override
  String get wsa_manage => 'Zarządzanie Androidem';

  @override
  String get wsa_manage_app => 'Aplikacje';

  @override
  String get wsa_manage_settings => 'Ustawienia';

  @override
  String get settings_port => 'Port WSA';

  @override
  String get settings_ip => 'Adres IP WSA';

  @override
  String get settings_autostart => 'Autostart WSA przed instalacją';

  @override
  String settings_timeout(String seconds) {
    return 'Limit czasowy ($seconds sekund)';
  }

  @override
  String get settings_language => 'Język';

  @override
  String get settings_option_generic_system => 'Systemowy';

  @override
  String get settings_option_generic_disabled => 'Wyłączone';

  @override
  String get theme_mode => 'Motyw';

  @override
  String get theme_mode_dark => 'Ciemny';

  @override
  String get theme_mode_light => 'Jasny';

  @override
  String get theme_mica => 'Przezroczystość okna';

  @override
  String get theme_mica_full => 'Pełna';

  @override
  String get theme_mica_partial => 'Częściowa';

  @override
  String get theme_icon_adaptive => 'Adaptacyjny kształt ikon';

  @override
  String get theme_icon_adaptive_squircle => 'Domyślny';

  @override
  String get theme_icon_adaptive_circle => 'Okrągły';

  @override
  String get theme_icon_adaptive_rounded_square => 'Zaokrąglony kwadrat';

  @override
  String get installer_message => 'Czy chcesz zainstalować tą aplikację?';

  @override
  String installer_info_version(String appVersion) {
    return 'Wersja: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'Wersja: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'Pakiet: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Instalowanie aplikacji $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'Aplikacja $appTitle została pomyślnie zainstalowana';
  }

  @override
  String installer_fail(String appTitle) {
    return 'Aplikacja $appTitle nie została zainstalowana';
  }

  @override
  String get installer_error_nomsg =>
      'Instalacja nie powiodła się, ale nie zgłoszono żadnego błędu';

  @override
  String get installer_error_timeout =>
      'Instalacja przekroczyła czas oczekiwania, klient przestał czekać, ale może nadal trwać w tle...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'Wymagane jest ręczne czyszczenie plików w katalogu „$tempDir”';
  }

  @override
  String get installer_btn_starting => 'Rozpoczynanie...';

  @override
  String get installer_btn_loading => 'Wczytywanie...';

  @override
  String get installer_btn_cancel => 'Anuluj';

  @override
  String get installer_btn_install => 'Zainstaluj';

  @override
  String get installer_btn_reinstall => 'Zainstaluj ponownie';

  @override
  String get installer_btn_update => 'Aktualizuj';

  @override
  String get installer_btn_downgrade => 'Downgrade (niebezpieczny)';

  @override
  String get installer_btn_dismiss => 'Gotowe';

  @override
  String get installer_btn_open => 'Otwórz';

  @override
  String get installer_btn_checkbox_shortcut => 'Utwórz skrót na pulpicie';

  @override
  String get android_permission_none => 'Nie wymaga żadnych uprawnień';

  @override
  String get android_permission_admin =>
      'Zarządzanie urządzeniem jako administrator';

  @override
  String get android_permission_admin_brick =>
      'Zdalne wyłączenie lub reset urządzenia';

  @override
  String get android_permission_admin_lock => 'Zdalne zablokowanie urządzenia';

  @override
  String get android_permission_storage => 'Pliki i multimedia';

  @override
  String get android_permission_microphone => 'Mikrofon';

  @override
  String get android_permission_camera => 'Aparat';

  @override
  String get android_permission_location => 'Lokalizacja';

  @override
  String get android_permission_phone => 'Telefon';

  @override
  String get android_permission_call_log => 'Rejestry połączeń';

  @override
  String get android_permission_sms => 'Wiadomości';

  @override
  String get android_permission_contacts => 'Kontakty';

  @override
  String get android_permission_calendar => 'Kalendarz';

  @override
  String get android_permission_activity_recognition => 'Aktywność fizyczna';

  @override
  String get android_permission_sensors => 'Czujniki urządzenia';

  @override
  String get android_permission_sensors_body => 'Czujniki na ciele';

  @override
  String get android_permission_nearby_devices =>
      'Wykrywanie urządzeń w pobliżu';
}
