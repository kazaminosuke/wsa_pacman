// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get locale_desc => 'Français';

  @override
  String get locale_system => 'Système';

  @override
  String get btn_boot => 'Démarrer';

  @override
  String get btn_auth => 'Réauthentifier';

  @override
  String get btn_dev_settings => 'Options de développeur';

  @override
  String get btn_switch_on => 'On';

  @override
  String get btn_switch_off => 'Off';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'Version antérieure de Windows';

  @override
  String get status_unsupported => 'WSA pas installé';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion détectée et WSA non trouvé; cette application dépend de WSA, qui n\'est officiellement pris en charge que sur Windows 11';
  }

  @override
  String get status_unauthorized => 'Non autorisé';

  @override
  String get status_unauthorized_desc =>
      'L\'autorisation de débogage a été refusée ou révoquée; appuyez sur le premier bouton, sélectionnez \'toujours autoriser\' et cliquez sur \'autoriser\'; Si aucune fenêtre contextuelle n\'apparaît, ouvrez les options de développeur et désactivez et réactivez le débogage USB';

  @override
  String get status_missing => 'WSA pas installé';

  @override
  String get status_missing_desc =>
      'WSA non trouvé; cette application dépend de WSA, veuillez installer Windows Subsystem pour Android (ou l\'Amazon Appstore) à partir du Microsoft Store';

  @override
  String get status_unknown => 'Connecting';

  @override
  String get status_unknown_desc =>
      'Attente de l\'établissement d\'une connexion à WSA...';

  @override
  String get status_starting => 'Démarrage';

  @override
  String get status_starting_desc => 'WSA démarre, veuillez patienter...';

  @override
  String get status_arrested => 'Arrêté';

  @override
  String get status_arrested_desc => 'WSA est éteint';

  @override
  String get status_offline => 'Hors-ligne';

  @override
  String get status_offline_desc =>
      'Impossible d\'établir une connexion avec WSA: le mode développeur et le débogage USB sont désactivés, ou un port incorrect a été spécifié';

  @override
  String get status_disconnected => 'Déconnecté';

  @override
  String get status_disconnected_desc =>
      'Une connexion au WSA n\'a pas pu être établie pour des raisons inconnues';

  @override
  String get status_connected => 'Connecté';

  @override
  String get status_connected_desc =>
      'Connecté avec succès à WSA, tout est prêt';

  @override
  String get screen_wsa => 'Gestionnaire de paquets WSA';

  @override
  String get screen_settings => 'Paramètres';

  @override
  String get wsa_manage => 'Gestion Android';

  @override
  String get wsa_manage_app => 'Gérer des applications';

  @override
  String get wsa_manage_settings => 'Gestion des paramètres';

  @override
  String get settings_port => 'Port WSA';

  @override
  String get settings_ip => 'Adresse IP WSA';

  @override
  String get settings_autostart =>
      'Démarrage automatique de WSA avant l\'installation';

  @override
  String settings_timeout(String seconds) {
    return 'Délai ($seconds secondes)';
  }

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_option_generic_system => 'Système';

  @override
  String get settings_option_generic_disabled => 'Désactivée';

  @override
  String get theme_mode => 'Mode thème';

  @override
  String get theme_mode_dark => 'Sombre';

  @override
  String get theme_mode_light => 'Clair';

  @override
  String get theme_mica => 'Transparence de la fenêtre';

  @override
  String get theme_mica_full => 'Totale';

  @override
  String get theme_mica_partial => 'Partielle';

  @override
  String get theme_icon_adaptive => 'Forme adaptative des icones';

  @override
  String get theme_icon_adaptive_squircle => 'Supercercle';

  @override
  String get theme_icon_adaptive_circle => 'Cercle';

  @override
  String get theme_icon_adaptive_rounded_square => 'Carré arrondi';

  @override
  String get installer_message => 'Voulez-vous installer cette application ?';

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
    return 'Paquet: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Installation de l\'application $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'L\'application $appTitle a été installée avec succès';
  }

  @override
  String installer_fail(String appTitle) {
    return 'The application $appTitle n\'a pas été installée';
  }

  @override
  String get installer_error_nomsg =>
      'L\'installation a échoué, mais aucune erreur n\'a été renvoyée';

  @override
  String get installer_error_timeout =>
      'Installation expirée, le client a arrêté d\'attendre, mais le processus peut encore être en cours en arrière-plan...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'Un nettoyage manuel des fichiers est nécessaire dans le répertoire “$tempDir”';
  }

  @override
  String get installer_btn_starting => 'Démarrage...';

  @override
  String get installer_btn_loading => 'Chargement...';

  @override
  String get installer_btn_cancel => 'Annuler';

  @override
  String get installer_btn_install => 'Installer';

  @override
  String get installer_btn_reinstall => 'Réinstaller';

  @override
  String get installer_btn_update => 'Mettre à jour';

  @override
  String get installer_btn_downgrade => 'Rétrograder (non sécuritaire)';

  @override
  String get installer_btn_dismiss => 'Ignorer';

  @override
  String get installer_btn_open => 'Ouvrir l\'app';

  @override
  String get installer_btn_checkbox_shortcut =>
      'Créer un raccourci sur le bureau';

  @override
  String get android_permission_none => 'Aucune autorisation requise';

  @override
  String get android_permission_admin =>
      'Gérer appareil en tant qu\'administrateur';

  @override
  String get android_permission_admin_brick =>
      'Désactiver ou réinitialiser l\'appareil';

  @override
  String get android_permission_admin_lock =>
      'Verrouiller l\'appareil à distance';

  @override
  String get android_permission_storage => 'Fichiers et contenus multimédias';

  @override
  String get android_permission_microphone => 'Microphone';

  @override
  String get android_permission_camera => 'Caméra';

  @override
  String get android_permission_location => 'Localisation';

  @override
  String get android_permission_phone => 'Téléphone';

  @override
  String get android_permission_call_log => 'Journaux d\'appels';

  @override
  String get android_permission_sms => 'Messages';

  @override
  String get android_permission_contacts => 'Contacts';

  @override
  String get android_permission_calendar => 'Calendrier';

  @override
  String get android_permission_activity_recognition => 'Activité physique';

  @override
  String get android_permission_sensors => 'Capteurs de l\'appareil';

  @override
  String get android_permission_sensors_body => 'Capteurs corporels';

  @override
  String get android_permission_nearby_devices =>
      'Localiser appareils à proximité';
}
