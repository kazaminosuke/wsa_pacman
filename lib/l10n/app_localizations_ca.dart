// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get locale_desc => 'Català';

  @override
  String get locale_system => 'Sistema';

  @override
  String get btn_boot => 'Engegar';

  @override
  String get btn_auth => 'Torna a autenticar';

  @override
  String get btn_dev_settings => 'Opcions de desenvolupador';

  @override
  String get btn_switch_on => 'Encès';

  @override
  String get btn_switch_off => 'Apagat';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'Versions de Windows més antigues';

  @override
  String get status_unsupported => 'WSA no està suportat';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return 'Estàs executant $windowsVersion però no s\'ha trobat WSA; aquesta aplicació necessita WSA, que sols està suportada en Windows 11';
  }

  @override
  String get status_unauthorized => 'No autoritzat';

  @override
  String get status_unauthorized_desc =>
      'S\'ha denegat o revocat l\'autorització de depuració; prem el primer botó, selecciona \'sempre permet\', després fes clic a \'permet\'; Si no apareix cap finestra emergent, obre les opcions de desenvolupador i desactiva i torna a activar \'depuració USB\'';

  @override
  String get status_missing => 'WSA no està instal·lat';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'Connectant';

  @override
  String get status_unknown_desc =>
      'Esperant a establir la connexió amb WSA...';

  @override
  String get status_starting => 'Iniciant';

  @override
  String get status_starting_desc =>
      'WSA s\'està iniciant, per favor espera...';

  @override
  String get status_arrested => 'Cancel·lat';

  @override
  String get status_arrested_desc => 'WSA està desconnectat';

  @override
  String get status_offline => 'Desconnectat';

  @override
  String get status_offline_desc =>
      'No s\'ha pogut establir una connexió amb WSA: o l\'USB debugging està desconnectat, o ho està el mode de desenvolupador, o el port indicat és incorrecte';

  @override
  String get status_disconnected => 'Desconnectat';

  @override
  String get status_disconnected_desc =>
      'No s\'ha pogut establir una connexió amb WSA per motius desconeguts';

  @override
  String get status_connected => 'Connectat';

  @override
  String get status_connected_desc =>
      'S\'ha connectat a WSA amb èxit, tots els serveis funcionant correctament';

  @override
  String get screen_wsa => 'Administrador de Paquets de WSA';

  @override
  String get screen_settings => 'Configuració';

  @override
  String get wsa_manage => 'Administració d\'Android';

  @override
  String get wsa_manage_app => 'Administrar aplicacions';

  @override
  String get wsa_manage_settings => 'Administrar configuració';

  @override
  String get settings_port => 'Port WSA';

  @override
  String get settings_ip => 'Direcció IP de WSA';

  @override
  String get settings_autostart => 'Iniciar WSA abans d\'instal·lar';

  @override
  String settings_timeout(String seconds) {
    return 'Temps de caducitat ($seconds segons)';
  }

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_option_generic_system => 'Sistema';

  @override
  String get settings_option_generic_disabled => 'Deshabilitat';

  @override
  String get theme_mode => 'Mode del tema';

  @override
  String get theme_mode_dark => 'Obscur';

  @override
  String get theme_mode_light => 'Clar';

  @override
  String get theme_mica => 'Transparència de la finestra';

  @override
  String get theme_mica_full => 'Completa';

  @override
  String get theme_mica_partial => 'Parcial';

  @override
  String get theme_icon_adaptive => 'Forma de les icones adaptives';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle';

  @override
  String get theme_icon_adaptive_circle => 'Cercle';

  @override
  String get theme_icon_adaptive_rounded_square => 'Quadrat rodonejat';

  @override
  String get installer_message => 'Vols instal·lar aquesta aplicació?';

  @override
  String installer_info_version(String appVersion) {
    return 'Versió: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'Versió: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'Paquet: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Instal·lant $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return '$appTitle s\'ha instal·lat correctament';
  }

  @override
  String installer_fail(String appTitle) {
    return '$appTitle no s\'ha pogut instal·lar';
  }

  @override
  String get installer_error_nomsg =>
      'La instal·lació ha fallat, però no s\'ha detectat cap error';

  @override
  String get installer_error_timeout =>
      'S\'ha acabat el temps d\'instal·lació, el client ha deixat d\'esperar, però potser encara està en curs en segon pla...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'Cal realitzar una neteja manual del fitxer al directori “$tempDir”';
  }

  @override
  String get installer_btn_starting => 'Iniciant...';

  @override
  String get installer_btn_loading => 'Carregant...';

  @override
  String get installer_btn_cancel => 'Cancel·lar';

  @override
  String get installer_btn_install => 'Instal·lar';

  @override
  String get installer_btn_reinstall => 'Reinstal·lar';

  @override
  String get installer_btn_update => 'Actualitzar';

  @override
  String get installer_btn_downgrade => 'Baixar versió (insegur)';

  @override
  String get installer_btn_dismiss => 'Tancar';

  @override
  String get installer_btn_open => 'Obri app';

  @override
  String get installer_btn_checkbox_shortcut =>
      'Crea una drecera a l\'escriptori';

  @override
  String get android_permission_none => 'No calen permisos';

  @override
  String get android_permission_admin =>
      'Administrar dispositiu com a administrador';

  @override
  String get android_permission_admin_brick =>
      'Deshabilita o reinicia dispositiu remot';

  @override
  String get android_permission_admin_lock => 'Bloqueja el dispositiu remot';

  @override
  String get android_permission_storage => 'Fitxers i mitjans';

  @override
  String get android_permission_microphone => 'Micròfon';

  @override
  String get android_permission_camera => 'Càmera';

  @override
  String get android_permission_location => 'Ubicació';

  @override
  String get android_permission_phone => 'Telèfon';

  @override
  String get android_permission_call_log => 'Registres de cridades';

  @override
  String get android_permission_sms => 'Missatges';

  @override
  String get android_permission_contacts => 'Contactes';

  @override
  String get android_permission_calendar => 'Calendari';

  @override
  String get android_permission_activity_recognition => 'Activitat física';

  @override
  String get android_permission_sensors => 'Sensors del dispositiu';

  @override
  String get android_permission_sensors_body => 'Sensors corporals';

  @override
  String get android_permission_nearby_devices =>
      'Localitzar dispositius propers';
}
