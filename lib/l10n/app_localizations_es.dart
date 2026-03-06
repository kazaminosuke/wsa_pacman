// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get locale_desc => 'Español';

  @override
  String get locale_system => 'Sistema';

  @override
  String get btn_boot => 'Encender';

  @override
  String get btn_auth => 'Reautenticar';

  @override
  String get btn_dev_settings => 'Opciones de desarrollador';

  @override
  String get btn_switch_on => 'On';

  @override
  String get btn_switch_off => 'Off';

  @override
  String get status_subtext_winver_10 => 'Windows 10 detectado';

  @override
  String get status_subtext_winver_older =>
      'Versión anterior de Windows detectada';

  @override
  String get status_unsupported => 'WSA no instalado';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => 'No autorizado';

  @override
  String get status_unauthorized_desc =>
      'La autorización de depuración se ha negado o revocado; presione el primer botón, seleccione \'siempre permitir\' y luego haga clic en \'permitir\'; Si no aparece una ventana emergente, abra las opciones de desarrollador y desactive y vuelva a activar \'depuración USB\'';

  @override
  String get status_missing => 'WSA no instalado';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'Conectando';

  @override
  String get status_unknown_desc =>
      'Esperando a que se establezca la conexión con WSA...';

  @override
  String get status_starting => 'Iniciando';

  @override
  String get status_starting_desc =>
      'WSA se está iniciando, por favor espere...';

  @override
  String get status_arrested => 'Arrestado';

  @override
  String get status_arrested_desc => 'WSA esta apagado';

  @override
  String get status_offline => 'Desconectado';

  @override
  String get status_offline_desc =>
      'No se pudo establecer una conexión con WSA: el modo desarrollador y la depuración USB están deshabilitados o se especifica un puerto incorrecto';

  @override
  String get status_disconnected => 'Desconectado';

  @override
  String get status_disconnected_desc =>
      'No se pudo establecer una conexión a WSA por razones desconocidas';

  @override
  String get status_connected => 'Conectado';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'Gestor de paquetes WSA';

  @override
  String get screen_settings => 'Configuración';

  @override
  String get wsa_manage => 'Gestión de Android';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'Puerto WSA';

  @override
  String get settings_ip => 'Dirección IP de WSA';

  @override
  String get settings_autostart =>
      'Inicio automático de WSA antes de la instalación';

  @override
  String settings_timeout(String seconds) {
    return 'Tiempo de espera ($seconds segundos)';
  }

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_option_generic_system => 'Sistema';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => 'Modo de tema';

  @override
  String get theme_mode_dark => 'Oscuro';

  @override
  String get theme_mode_light => 'Claro';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => 'Forma de iconos adaptativos';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => 'Circulo';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => '¿Quieres instalar esta aplicación?';

  @override
  String installer_info_version(String appVersion) {
    return 'Versión: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'Versión: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'Paquete: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Instalación de la aplicación $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'La aplicación $appTitle se instaló correctamente';
  }

  @override
  String installer_fail(String appTitle) {
    return 'Aplicación $appTitle noinstalada';
  }

  @override
  String get installer_error_nomsg =>
      'La instalación ha fallado, pero no se ha producido ningún error';

  @override
  String get installer_error_timeout =>
      'Instalación ha excedido el tiempo, el cliente ha dejado de esperar, pero puede seguir en proceso en segundo plano...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'Se requiere una limpieza manual de archivos en el directorio “$tempDir”';
  }

  @override
  String get installer_btn_starting => 'Iniciando...';

  @override
  String get installer_btn_loading => 'Loading...';

  @override
  String get installer_btn_cancel => 'Cancelar';

  @override
  String get installer_btn_install => 'Instalar';

  @override
  String get installer_btn_reinstall => 'Reinstalar';

  @override
  String get installer_btn_update => 'Actualizar';

  @override
  String get installer_btn_downgrade => 'Degradar (inseguro)';

  @override
  String get installer_btn_dismiss => 'Terminar';

  @override
  String get installer_btn_open => 'Abrir la app';

  @override
  String get installer_btn_checkbox_shortcut =>
      'Crear acceso directo del escritorio';

  @override
  String get android_permission_none => 'Sin permisos necesarios';

  @override
  String get android_permission_admin =>
      'Gestionar dispositivo como administrador';

  @override
  String get android_permission_admin_brick =>
      'Deshabilitar o restablecer el dispositivo';

  @override
  String get android_permission_admin_lock =>
      'Bloquear dispositivo de forma remota';

  @override
  String get android_permission_storage => 'Archivos y multimedia';

  @override
  String get android_permission_microphone => 'Micrófono';

  @override
  String get android_permission_camera => 'Cámara';

  @override
  String get android_permission_location => 'Localización';

  @override
  String get android_permission_phone => 'Teléfono';

  @override
  String get android_permission_call_log => 'Registros de llamadas';

  @override
  String get android_permission_sms => 'Mensajes';

  @override
  String get android_permission_contacts => 'Contactos';

  @override
  String get android_permission_calendar => 'Calendario';

  @override
  String get android_permission_activity_recognition => 'Actividad física';

  @override
  String get android_permission_sensors => 'Sensores del dispositivo';

  @override
  String get android_permission_sensors_body => 'Sensores del cuerpo';

  @override
  String get android_permission_nearby_devices =>
      'Buscar dispositivos cercanos';

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
}
