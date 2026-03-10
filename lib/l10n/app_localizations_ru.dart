// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get locale_desc => 'Русский';

  @override
  String get locale_system => 'Как в системе';

  @override
  String get btn_auth => 'Повторная аутентификация';

  @override
  String get btn_dev_settings => 'Настройки разработчика';

  @override
  String get btn_switch_on => 'Вкл.';

  @override
  String get btn_switch_off => 'Выкл.';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'Устаревшая версия Windows';

  @override
  String get status_unsupported =>
      'Подсистема Windows под Android не поддерживается';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => 'Неавторизованный';

  @override
  String get status_unauthorized_desc =>
      'Авторизация для отладки была отклонена или отозвана; нажмите первую кнопку, выберите \'всегда разрешать\' и нажмите \'разрешить\'; если не отображается всплывающее окно, откройте настройки разработчика и отключите и снова включите \'отладку USB\'';

  @override
  String get status_missing => 'Подсистема Windows под Android не установлена';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'Connecting';

  @override
  String get status_unknown_desc =>
      'Ожидание соединения с подсистема Windows под Android';

  @override
  String get status_starting => 'Запуск';

  @override
  String get status_starting_desc =>
      'Подсистема Windows под Android запускается, подождите...';

  @override
  String get status_arrested => 'Удержано';

  @override
  String get status_arrested_desc => 'Подсистема Windows под Android выключена';

  @override
  String get status_offline => 'Не в сети';

  @override
  String get status_offline_desc =>
      'Не удалось установить соединение с WSA: либо режим разработчика и отладка по USB отключены, либо указан неверный порт';

  @override
  String get status_disconnected => 'Отсоединен';

  @override
  String get status_disconnected_desc =>
      'Соединение с подсистемой Windows под Android не удалось установить по неизвестным причинам';

  @override
  String get status_connected => 'Подключено';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa =>
      'Менеджер пакетов для подсистемы Windows под Android';

  @override
  String get screen_settings => 'Настройки';

  @override
  String get wsa_manage => 'Управление системой Android';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'Порт';

  @override
  String get settings_ip => 'IP-адрес';

  @override
  String get settings_autostart =>
      'Автоматически запускать подсистему Windows под Android перед установкой';

  @override
  String settings_timeout(String seconds) {
    return 'Тайм-аут ($seconds секунд)';
  }

  @override
  String get settings_language => 'Язык';

  @override
  String get settings_option_generic_system => 'Как в системе';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => 'Тема интерфейса';

  @override
  String get theme_mode_dark => 'Темная';

  @override
  String get theme_mode_light => 'Светлая';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => 'Форма адаптивных значков';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => 'Кружок';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => 'Вы хотите установить это приложение?';

  @override
  String installer_info_version(String appVersion) {
    return 'Версия: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'Версия: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'Имя пакета: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Установка приложения $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'Приложение $appTitle было успешно установлено';
  }

  @override
  String installer_fail(String appTitle) {
    return 'Приложение $appTitle не было установлено';
  }

  @override
  String get installer_error_nomsg =>
      'Установка не удалась, но ошибок не было обнаружено';

  @override
  String get installer_error_timeout =>
      'Установка превысила время ожидания, клиент перестал ждать, но она может продолжаться в фоновом режиме...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'Требуется ручная очистка файлов в каталоге «$tempDir»';
  }

  @override
  String get installer_btn_starting => 'Запуск...';

  @override
  String get installer_btn_loading => 'Загрузка...';

  @override
  String get installer_btn_cancel => 'Отмена';

  @override
  String get installer_btn_install => 'Установить';

  @override
  String get installer_btn_reinstall => 'Переустановить';

  @override
  String get installer_btn_update => 'Обновить';

  @override
  String get installer_btn_downgrade => 'Понизить версию (не безопасно)';

  @override
  String get installer_btn_dismiss => 'Отклонить';

  @override
  String get installer_btn_open => 'Открыть приложение';

  @override
  String get installer_btn_checkbox_shortcut =>
      'Создать ярлык на рабочем столе';

  @override
  String get android_permission_none => 'Разрешения не требуются';

  @override
  String get android_permission_admin =>
      'Управлять устройством как администратор';

  @override
  String get android_permission_admin_brick =>
      'Удаленно отключить или перезагрузить устройство';

  @override
  String get android_permission_admin_lock => 'Удаленно блокировать устройство';

  @override
  String get android_permission_storage => 'Файлы и медиаконтент';

  @override
  String get android_permission_microphone => 'Микрофон';

  @override
  String get android_permission_camera => 'Камера';

  @override
  String get android_permission_location => 'Местоположение';

  @override
  String get android_permission_phone => 'Телефон';

  @override
  String get android_permission_call_log => 'Список вызовов';

  @override
  String get android_permission_sms => 'Сообщения';

  @override
  String get android_permission_contacts => 'Контакты';

  @override
  String get android_permission_calendar => 'Календарь';

  @override
  String get android_permission_activity_recognition => 'Физическая активность';

  @override
  String get android_permission_sensors => 'Датчики устройства';

  @override
  String get android_permission_sensors_body => 'Датчики на теле';

  @override
  String get android_permission_nearby_devices => 'Устройства поблизости';

  @override
  String get screen_uninstall => 'Удалить';

  @override
  String get scan_system => 'Сканировать систему';

  @override
  String get scanning => 'Сканирование...';

  @override
  String get backup_registry => 'Резервная копия реестра';

  @override
  String get execute_cleanup => 'Выполнить очистку';

  @override
  String get scanning_wsa_env => 'Глубокое сканирование среды WSA...';

  @override
  String get click_scan_to_find_ghost_apps =>
      'Нажмите \'Сканировать систему\', чтобы найти оставшиеся или скрытые приложения.';

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
  String get btn_refresh_status => 'Обновить статус';

  @override
  String get tooltip_refresh_status => 'Проверить статус WSA сейчас';

  @override
  String get btn_launch_wsa => 'Запустить WSA';
}
