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
    return '$windowsVersion detectado e WSA não encontrado. Este aplicativo depende do WSA, que é suportado oficialmente no Windows 11';
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
      'Conectado com sucesso no WSA, todos os sistemas ativos';

  @override
  String get screen_wsa => 'Gerenciador de pacotes WSA ';

  @override
  String get screen_settings => 'Configurações';

  @override
  String get wsa_manage => 'Gerenciamento do Android';

  @override
  String get wsa_manage_app => 'Gerenciar aplicativos';

  @override
  String get wsa_manage_settings => 'Gerenciar configurações';

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
  String get settings_option_generic_disabled => 'Desativado';

  @override
  String get theme_mode => 'Tema';

  @override
  String get theme_mode_dark => 'Escuro';

  @override
  String get theme_mode_light => 'Claro';

  @override
  String get theme_mica => 'Transparência da janela';

  @override
  String get theme_mica_full => 'Cheia';

  @override
  String get theme_mica_partial => 'Parcial';

  @override
  String get theme_icon_adaptive => 'Forma de ícones adaptáveis';

  @override
  String get theme_icon_adaptive_squircle => 'Quadrado-círculo';

  @override
  String get theme_icon_adaptive_circle => 'Círculo';

  @override
  String get theme_icon_adaptive_rounded_square => 'Quadrado arredondado';

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
}
