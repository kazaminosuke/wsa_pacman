// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get locale_desc => 'Deutsch';

  @override
  String get locale_system => 'System';

  @override
  String get btn_boot => 'Starten';

  @override
  String get btn_auth => 'Erneut authentifizieren';

  @override
  String get btn_dev_settings => 'Entwickleroptionen';

  @override
  String get btn_switch_on => 'An';

  @override
  String get btn_switch_off => 'Aus';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'Frühere Windows Version';

  @override
  String get status_unsupported => 'WSA ist nicht installiert.';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion wurde erkannt und WSA nicht gefunden; diese Anwendung benötigt WSA welche nur auf Windows 11 offiziell verfügbar ist.';
  }

  @override
  String get status_unauthorized => 'Nicht autorisiert';

  @override
  String get status_unauthorized_desc =>
      'Die Debugging-Autorisierung wurde abgelehnt oder widerrufen; drücken Sie die erste Schaltfläche, wählen Sie \'Immer zulassen\' und klicken Sie dann auf \'Zulassen\'; Wenn kein Popup angezeigt wird, öffnen Sie die Entwickleroptionen und deaktivieren und reaktivieren Sie die \'USB-Debugging\'';

  @override
  String get status_missing => 'WSA ist nicht installiert.';

  @override
  String get status_missing_desc =>
      'WSA wurde nicht gefunden; diese Anwendung benötigt WSA, Windows Subsystem für Android (oder der Amazon AppStore) kann vom Microsoft Store bezogen werden.';

  @override
  String get status_unknown => 'Verbinde';

  @override
  String get status_unknown_desc => 'Warte auf die Verbindung zu WSA...';

  @override
  String get status_starting => 'Starte';

  @override
  String get status_starting_desc => 'WSA wird gestartet, bitte warten...';

  @override
  String get status_arrested => 'Gestoppt';

  @override
  String get status_arrested_desc => 'WSA läuft nicht.';

  @override
  String get status_offline => 'Offline';

  @override
  String get status_offline_desc =>
      'Es konnte keine Verbindung zu WSA hergestellt werden: entweder ist der Entwicklermodus deaktiviert oder USB-Debugging nicht aktiv bzw. ein falscher Port angegeben.';

  @override
  String get status_disconnected => 'Getrennt';

  @override
  String get status_disconnected_desc =>
      'Es konnte aus unbekannten Gründen keine Verbindung zu WSA hergestellt werden.';

  @override
  String get status_connected => 'Verbunden';

  @override
  String get status_connected_desc => 'Erfolgreich verbunden.';

  @override
  String get screen_wsa => 'WSA Paketmanager';

  @override
  String get screen_settings => 'Einstellungen';

  @override
  String get wsa_manage => 'Android Einstellungen';

  @override
  String get wsa_manage_app => 'Apps';

  @override
  String get wsa_manage_settings => 'System';

  @override
  String get settings_port => 'WSA-Debugging Port';

  @override
  String get settings_ip => 'WSA IP Adresse';

  @override
  String get settings_autostart => 'Starte WSA automatisch';

  @override
  String settings_timeout(String seconds) {
    return 'Zeitüberschreitung ($seconds Sekunden)';
  }

  @override
  String get settings_language => 'Sprache';

  @override
  String get settings_option_generic_system => 'System';

  @override
  String get settings_option_generic_disabled => 'Deaktiviert';

  @override
  String get theme_mode => 'Design';

  @override
  String get theme_mode_dark => 'Dunkel';

  @override
  String get theme_mode_light => 'Hell';

  @override
  String get theme_mica => 'Transparenz';

  @override
  String get theme_mica_full => 'Vollständig';

  @override
  String get theme_mica_partial => 'Teilweise';

  @override
  String get theme_icon_adaptive => 'Angepasste Icons';

  @override
  String get theme_icon_adaptive_squircle => 'Superkreis';

  @override
  String get theme_icon_adaptive_circle => 'Kreis';

  @override
  String get theme_icon_adaptive_rounded_square => 'Runde Ecken';

  @override
  String get installer_message => 'Soll diese App installiert werden?';

  @override
  String installer_info_version(String appVersion) {
    return 'Version: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'Version: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'Paketname: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Installiere $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return '$appTitle wurde erfolgreich installiert.';
  }

  @override
  String installer_fail(String appTitle) {
    return '$appTitle wurde nicht installiert.';
  }

  @override
  String get installer_error_nomsg =>
      'Installation ohne Angabe von Gründen fehlgeschlagen.';

  @override
  String get installer_error_timeout =>
      'Installation abgelaufen, der Client wartet nicht mehr, aber der Vorgang könnte im Hintergrund noch laufen...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'Eine manuelle Dateibereinigung ist in Verzeichnis „$tempDir“ erforderlich';
  }

  @override
  String get installer_btn_starting => 'Starte WSA...';

  @override
  String get installer_btn_loading => 'Lade App...';

  @override
  String get installer_btn_cancel => 'Abbrechen';

  @override
  String get installer_btn_install => 'Installieren';

  @override
  String get installer_btn_reinstall => 'Neu installieren';

  @override
  String get installer_btn_update => 'Update';

  @override
  String get installer_btn_downgrade => 'Downgrade (unsicher)';

  @override
  String get installer_btn_dismiss => 'Schließen';

  @override
  String get installer_btn_open => 'Öffnen';

  @override
  String get installer_btn_checkbox_shortcut =>
      'Erstelle eine Desktop Verknüpfung';

  @override
  String get android_permission_none => 'Keine Berechtigungen erforderlich';

  @override
  String get android_permission_admin => 'Gerät als Administrator verwalten';

  @override
  String get android_permission_admin_brick =>
      'Gerät aus der Ferne sperren oder zurücksetzen';

  @override
  String get android_permission_admin_lock => 'Gerät aus der Ferne sperren';

  @override
  String get android_permission_storage => 'Speicher';

  @override
  String get android_permission_microphone => 'Mikrofon';

  @override
  String get android_permission_camera => 'Kamera';

  @override
  String get android_permission_location => 'Standort';

  @override
  String get android_permission_phone => 'Telefon';

  @override
  String get android_permission_call_log => 'Anrufliste';

  @override
  String get android_permission_sms => 'Nachrichten';

  @override
  String get android_permission_contacts => 'Kontakte';

  @override
  String get android_permission_calendar => 'Kalender';

  @override
  String get android_permission_activity_recognition => 'Aktivitätserkennung';

  @override
  String get android_permission_sensors => 'Gerätesensoren';

  @override
  String get android_permission_sensors_body => 'Körpersensoren';

  @override
  String get android_permission_nearby_devices => 'Geräte in der Nähe';
}
