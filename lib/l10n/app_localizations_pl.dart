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
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
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
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'Connecting';

  @override
  String get status_unknown_desc =>
      'Waiting for a WSA connection to be established...';

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
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'Menedżer pakietów WSA';

  @override
  String get screen_settings => 'Ustawienia';

  @override
  String get wsa_manage => 'Zarządzanie Androidem';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

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
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => 'Motyw';

  @override
  String get theme_mode_dark => 'Ciemny';

  @override
  String get theme_mode_light => 'Jasny';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => 'Adaptacyjny kształt ikon';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => 'Okrągły';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

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

  @override
  String get screen_uninstall => 'Odinstaluj';

  @override
  String get scan_system => 'Skanuj system';

  @override
  String get scanning => 'Skanowanie...';

  @override
  String get backup_registry => 'Kopia zapasowa rejestru';

  @override
  String get execute_cleanup => 'Wykonaj czyszczenie';

  @override
  String get scanning_wsa_env => 'Skanowanie środowiska WSA...';

  @override
  String get click_scan_to_find_ghost_apps =>
      'Kliknij \'Skanuj system\', aby znaleźć pozostałości lub ukryte aplikacje.';

  @override
  String get type_registry_only => 'Registry Only';

  @override
  String get type_orphaned_shortcut => 'Orphaned Shortcut';

  @override
  String get type_hidden_adb_app => 'Hidden ADB App';

  @override
  String get cleanup_complete => 'Cleanup Complete';

  @override
  String cleanup_success_desc(int count) {
    return 'Completely deleted $count apps and unnecessary data.';
  }

  @override
  String get auto_backup_registry => 'Auto-backup before uninstall';

  @override
  String get backup_cancelled => 'Backup cancelled';

  @override
  String get backup_success => 'Backup successfully saved';

  @override
  String get btn_restart_wsa => 'Restart WSA';

  @override
  String get settings_auto_backup_dir => 'Auto Backup Directory';

  @override
  String get tooltip_reset_desktop => 'Reset to Default (Desktop)';

  @override
  String get btn_browse => 'Browse...';

  @override
  String get settings_theme_color => 'Theme Color';

  @override
  String get settings_theme_color_system => 'System (Windows)';

  @override
  String get settings_theme_color_default => 'Default';

  @override
  String get settings_custom_color => 'Create Custom Color:';

  @override
  String get btn_apply => 'Apply';

  @override
  String get dialog_backup_dir_title => 'Select a folder to save auto-backups';

  @override
  String get dialog_backup_dir_filename => 'Select this folder';

  @override
  String get dialog_backup_dir_filter => 'Folder|*.none';

  @override
  String uninstaller_status_uninstalling(String appName) {
    return 'Uninstalling $appName...';
  }

  @override
  String get uninstaller_status_starting_wsa =>
      'Starting Windows Subsystem for Android...';

  @override
  String get uninstaller_status_success => 'Successfully uninstalled.';

  @override
  String get uninstaller_status_errors => 'Uninstalled with some errors.';

  @override
  String uninstaller_status_error_msg(String error) {
    return 'Error during uninstall: $error';
  }

  @override
  String uninstaller_confirm(String appName) {
    return 'Are you sure you want to uninstall $appName?';
  }

  @override
  String get uninstaller_btn_yes => 'Yes';

  @override
  String get btn_refresh_status => 'Odśwież status';

  @override
  String get tooltip_refresh_status => 'Sprawdź ponownie status WSA teraz';

  @override
  String get btn_launch_wsa => 'Uruchom WSA';
}
