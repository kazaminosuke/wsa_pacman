// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get locale_desc => 'Português (Brasil)';

  @override
  String get locale_system => 'Sistema';

  @override
  String get btn_boot => 'Ativar';

  @override
  String get btn_auth => 'Reautenticar';

  @override
  String get btn_dev_settings => 'Opções de desenvolvedor';

  @override
  String get btn_switch_on => 'Lig';

  @override
  String get btn_switch_off => 'Desl';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'Versão antiga do Windows';

  @override
  String get status_unsupported => 'WSA não instalado';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => 'Não autorizado';

  @override
  String get status_unauthorized_desc =>
      'A autorização de depuração foi negada ou revogada; pressione o primeiro botão, selecione \'permitir sempre\' e clique em \'permitir\'; se nenhuma janela pop-up aparecer, abra as opções de desenvolvedor e desabilite e reabilite o \'depuração USB\'';

  @override
  String get status_missing => 'WSA não instalado';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'Connecting';

  @override
  String get status_unknown_desc =>
      'Aguardando que uma conexão WSA seja estabelecida...';

  @override
  String get status_starting => 'Iniciando';

  @override
  String get status_starting_desc => 'WSA iniciando, aguarde...';

  @override
  String get status_arrested => 'Suspenso';

  @override
  String get status_arrested_desc => 'WSA está desativado';

  @override
  String get status_offline => 'Offline';

  @override
  String get status_offline_desc =>
      'Não foi estabelecer uma conexão com o WSA. O modo de desenvolvedor e a depuração USB estão desabilitados ou uma porta errada foi especificada';

  @override
  String get status_disconnected => 'Desconectado';

  @override
  String get status_disconnected_desc =>
      'Uma conexão WSA não pôde ser estabelecido por razões desconhecidas';

  @override
  String get status_connected => 'Conectado';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'Gerenciador de pacotes WSA ';

  @override
  String get screen_settings => 'Configurações';

  @override
  String get wsa_manage => 'Gerenciamento do Android';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'Porta da WSA';

  @override
  String get settings_ip => 'Endereço IP do WSA';

  @override
  String get settings_autostart => 'Iniciar WSA antes da instalação';

  @override
  String settings_timeout(String seconds) {
    return 'Tempo limite ($seconds segundos)';
  }

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_option_generic_system => 'Sistema';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => 'Tema';

  @override
  String get theme_mode_dark => 'Escuro';

  @override
  String get theme_mode_light => 'Claro';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => 'Forma de ícones adaptáveis';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => 'Círculo';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => 'Deseja instalar este aplicativo?';

  @override
  String installer_info_version(String appVersion) {
    return 'Versão: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'Versão: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'Pacote: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Instalando aplicativo $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'O aplicativo $appTitle foi instalado com sucesso';
  }

  @override
  String installer_fail(String appTitle) {
    return 'O aplicativo $appTitle não foi instalado';
  }

  @override
  String get installer_error_nomsg =>
      'A instalação falhou, mas nenhum erro foi emitido';

  @override
  String get installer_error_timeout =>
      'A instalação excedeu o tempo limite, o cliente parou de esperar, mas pode ainda estar em progresso em segundo plano...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'É necessário uma limpeza manual de arquivos no diretório “$tempDir”';
  }

  @override
  String get installer_btn_starting => 'Iniciando...';

  @override
  String get installer_btn_loading => 'Carregando...';

  @override
  String get installer_btn_cancel => 'Cancelar';

  @override
  String get installer_btn_install => 'Instalar';

  @override
  String get installer_btn_reinstall => 'Reinstalar';

  @override
  String get installer_btn_update => 'Atualizar';

  @override
  String get installer_btn_downgrade => 'Downgrade (não seguro)';

  @override
  String get installer_btn_dismiss => 'Dispensar';

  @override
  String get installer_btn_open => 'Abrir aplicativo';

  @override
  String get installer_btn_checkbox_shortcut =>
      'Criar ícone na Área de Trabalho';

  @override
  String get android_permission_none => 'Nenhuma permissão necessária';

  @override
  String get android_permission_admin =>
      'Gerenciar dispositivo como administrador';

  @override
  String get android_permission_admin_brick =>
      'Desativar ou redefinir dispositivo remotamente';

  @override
  String get android_permission_admin_lock =>
      'Bloquear dispositivo remotamente';

  @override
  String get android_permission_storage => 'Arquivos e mídia';

  @override
  String get android_permission_microphone => 'Microfone';

  @override
  String get android_permission_camera => 'Câmera';

  @override
  String get android_permission_location => 'Local';

  @override
  String get android_permission_phone => 'Telefone';

  @override
  String get android_permission_call_log => 'Registro de chamadas';

  @override
  String get android_permission_sms => 'Mensagens';

  @override
  String get android_permission_contacts => 'Contatos';

  @override
  String get android_permission_calendar => 'Calendário';

  @override
  String get android_permission_activity_recognition => 'Atividade física';

  @override
  String get android_permission_sensors => 'Sensores do dispositivo';

  @override
  String get android_permission_sensors_body => 'Sensores corporais';

  @override
  String get android_permission_nearby_devices =>
      'Localizar dispositivos próximos';

  @override
  String get screen_uninstall => 'Desinstalar';

  @override
  String get scan_system => 'Escanear sistema';

  @override
  String get scanning => 'Escaneando...';

  @override
  String get backup_registry => 'Backup do registro';

  @override
  String get execute_cleanup => 'Executar limpeza';

  @override
  String get scanning_wsa_env => 'Escaneando ambiente WSA profundamente...';

  @override
  String get click_scan_to_find_ghost_apps =>
      'Clique em \'Escanear sistema\' para encontrar aplicativos remanescentes ou ocultos.';

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
}
