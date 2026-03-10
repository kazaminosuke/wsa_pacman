// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get locale_desc => 'Italiano';

  @override
  String get locale_system => 'Sistema';

  @override
  String get btn_boot => 'Avvia';

  @override
  String get btn_auth => 'Riautentica';

  @override
  String get btn_dev_settings => 'Opzioni sviluppatore';

  @override
  String get btn_switch_on => 'On';

  @override
  String get btn_switch_off => 'Off';

  @override
  String get status_subtext_winver_10 => 'rilevato Windows 10';

  @override
  String get status_subtext_winver_older =>
      'rilevata una vecchia versione di Windows';

  @override
  String get status_unsupported => 'WSA non installato';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => 'Non autorizzato';

  @override
  String get status_unauthorized_desc =>
      'L\'autorizzazione per il debug è stata negata o revocata; premere il primo pulsante, selezionare \'consenti sempre\' e quindi fare clic su \'consenti\'; Se non compare alcuna finestra pop-up, aprire le opzioni sviluppatore e disattivare e riattivare l\'opzione \'Debug USB\'';

  @override
  String get status_missing => 'WSA non installato';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'Connessione';

  @override
  String get status_unknown_desc => 'In attesa di una connessione con WSA...';

  @override
  String get status_starting => 'Avvio';

  @override
  String get status_starting_desc =>
      'WSA è in fase di avvio, per favore attendi...';

  @override
  String get status_arrested => 'Arrestato';

  @override
  String get status_arrested_desc => 'WSA è spento';

  @override
  String get status_offline => 'Offline';

  @override
  String get status_offline_desc =>
      'Non è stato possibile connettersi a WSA: controlla che la modalità sviluppatore e il debug USB siano attivi, e di aver specificato la porta corretta';

  @override
  String get status_disconnected => 'Disconnesso';

  @override
  String get status_disconnected_desc =>
      'Non è stato possibile connettersi a WSA per ragioni sconosciute';

  @override
  String get status_connected => 'Connesso';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'WSA Package Manager';

  @override
  String get screen_settings => 'Impostazioni';

  @override
  String get wsa_manage => 'Gestione Android';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'Porta WSA';

  @override
  String get settings_ip => 'Indirizzo IP WSA';

  @override
  String get settings_autostart =>
      'Avvia WSA automaticamente prima di un\'installazione';

  @override
  String settings_timeout(String seconds) {
    return 'Timeout ($seconds secondi)';
  }

  @override
  String get settings_language => 'Lingua';

  @override
  String get settings_option_generic_system => 'Sistema';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => 'Modalità tema';

  @override
  String get theme_mode_dark => 'Scuro';

  @override
  String get theme_mode_light => 'Chiaro';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => 'Forma icone adattive';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => 'Cerchio';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => 'Vuoi installare questa applicazione?';

  @override
  String installer_info_version(String appVersion) {
    return 'Versione: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'Versione: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'Pacchetto: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Installazione di $appTitle in corso...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'Applicazione $appTitle installata correttamente';
  }

  @override
  String installer_fail(String appTitle) {
    return 'L\'applicazione $appTitle non è stata installata';
  }

  @override
  String get installer_error_nomsg =>
      'Installazione fallita senza lanciare alcun errore';

  @override
  String get installer_error_timeout =>
      'L\'installazione ha superato il tempo limite, il client ha smesso di attendere, ma potrebbe essere ancora in esecuzione in background...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'È necessaria una pulizia manuale dei file della directory “$tempDir”';
  }

  @override
  String get installer_btn_starting => 'Avvio...';

  @override
  String get installer_btn_loading => 'Caricamento...';

  @override
  String get installer_btn_cancel => 'Annulla';

  @override
  String get installer_btn_install => 'Installa';

  @override
  String get installer_btn_reinstall => 'Reinstalla';

  @override
  String get installer_btn_update => 'Aggiorna';

  @override
  String get installer_btn_downgrade => 'Downgrade (non sicuro)';

  @override
  String get installer_btn_dismiss => 'Termina';

  @override
  String get installer_btn_open => 'Apri l\'app';

  @override
  String get installer_btn_checkbox_shortcut => 'Aggiungi icona sul desktop';

  @override
  String get android_permission_none => 'Nessun permesso necessario';

  @override
  String get android_permission_admin =>
      'Gestisci dispositivo come amministratore';

  @override
  String get android_permission_admin_brick =>
      'Disabilita o ripristina dispositivo a distanza';

  @override
  String get android_permission_admin_lock => 'Blocca dispositivo a distanza';

  @override
  String get android_permission_storage => 'File e contenuti multimediali';

  @override
  String get android_permission_microphone => 'Microfono';

  @override
  String get android_permission_camera => 'Camera';

  @override
  String get android_permission_location => 'Posizione';

  @override
  String get android_permission_phone => 'Telefono';

  @override
  String get android_permission_call_log => 'Registri chiamate';

  @override
  String get android_permission_sms => 'Messaggi';

  @override
  String get android_permission_contacts => 'Contatti';

  @override
  String get android_permission_calendar => 'Calendario';

  @override
  String get android_permission_activity_recognition => 'Attività fisica';

  @override
  String get android_permission_sensors => 'Sensori del dispositivo';

  @override
  String get android_permission_sensors_body => 'Sensori corporei';

  @override
  String get android_permission_nearby_devices =>
      'Localizza dispositivi vicini';

  @override
  String get screen_uninstall => 'Uninstall';

  @override
  String get scan_system => 'Scan System';

  @override
  String get scanning => 'Scanning...';

  @override
  String get backup_registry => 'Backup Registry';

  @override
  String get execute_cleanup => 'Execute Cleanup';

  @override
  String get scanning_wsa_env => 'Scanning WSA environment deeply...';

  @override
  String get click_scan_to_find_ghost_apps =>
      'Click \'Scan System\' to find remnant or hidden apps.';

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
  String get btn_refresh_status => 'Aggiorna stato';

  @override
  String get tooltip_refresh_status => 'Ricontrolla lo stato WSA adesso';
}
