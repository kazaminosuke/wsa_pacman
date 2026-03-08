// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get locale_desc => 'English';

  @override
  String get locale_system => 'System';

  @override
  String get btn_boot => 'Turn on';

  @override
  String get btn_auth => 'Reauthenticate';

  @override
  String get btn_dev_settings => 'Developer options';

  @override
  String get btn_switch_on => 'On';

  @override
  String get btn_switch_off => 'Off';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'Older Windows Version';

  @override
  String get status_unsupported => 'WSA not installed';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => 'Unauthorized';

  @override
  String get status_unauthorized_desc =>
      'Debugging authorization was dismissed or revoked; press the first button, select \'always allow\', then click on \'allow\'; If no popup appears, open developer options and disable and re-enable \'USB debugging\'';

  @override
  String get status_missing => 'WSA not installed';

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
  String get status_starting => 'Starting';

  @override
  String get status_starting_desc => 'WSA is starting, please stand by...';

  @override
  String get status_arrested => 'Arrested';

  @override
  String get status_arrested_desc => 'WSA is turned off';

  @override
  String get status_offline => 'Offline';

  @override
  String get status_offline_desc =>
      'Could not establish a connection with WSA: either developer mode and USB debugging are disabled or a wrong port is specified';

  @override
  String get status_disconnected => 'Disconnected';

  @override
  String get status_disconnected_desc =>
      'A WSA connection could not be enstablished for unknown reasons';

  @override
  String get status_connected => 'Connected';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'WSA Package Manager';

  @override
  String get screen_settings => 'Settings';

  @override
  String get wsa_manage => 'Android Management';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'WSA Port';

  @override
  String get settings_ip => 'WSA IP address';

  @override
  String get settings_autostart => 'Autostart WSA before installation';

  @override
  String settings_timeout(String seconds) {
    return 'Timeout ($seconds seconds)';
  }

  @override
  String get settings_language => 'Language';

  @override
  String get settings_option_generic_system => 'System';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => 'Theme mode';

  @override
  String get theme_mode_dark => 'Dark';

  @override
  String get theme_mode_light => 'Light';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => 'Adaptive icons Shape';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => 'Circle';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => 'Do you want to install this application?';

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
    return 'Package: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Installing application $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'The application $appTitle was successfully installed';
  }

  @override
  String installer_fail(String appTitle) {
    return 'The application $appTitle was not installed';
  }

  @override
  String get installer_error_nomsg =>
      'The installation has failed, but no error was thrown';

  @override
  String get installer_error_timeout =>
      'Installation timed out, client has stopped waiting, but it may still be in progress in the background...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'A manual file cleanup is needed in directory “$tempDir”';
  }

  @override
  String get installer_btn_starting => 'Starting...';

  @override
  String get installer_btn_loading => 'Loading...';

  @override
  String get installer_btn_cancel => 'Cancel';

  @override
  String get installer_btn_install => 'Install';

  @override
  String get installer_btn_reinstall => 'Reinstall';

  @override
  String get installer_btn_update => 'Update';

  @override
  String get installer_btn_downgrade => 'Downgrade (unsafe)';

  @override
  String get installer_btn_dismiss => 'Dismiss';

  @override
  String get installer_btn_open => 'Open app';

  @override
  String get installer_btn_checkbox_shortcut => 'Create desktop shortcut';

  @override
  String get android_permission_none => 'No permissions required';

  @override
  String get android_permission_admin => 'Manage device as administrator';

  @override
  String get android_permission_admin_brick =>
      'Remotely disable or reset device';

  @override
  String get android_permission_admin_lock => 'Remotely lock device';

  @override
  String get android_permission_storage => 'Files and media';

  @override
  String get android_permission_microphone => 'Microphone';

  @override
  String get android_permission_camera => 'Camera';

  @override
  String get android_permission_location => 'Location';

  @override
  String get android_permission_phone => 'Phone';

  @override
  String get android_permission_call_log => 'Call logs';

  @override
  String get android_permission_sms => 'Messages';

  @override
  String get android_permission_contacts => 'Contacts';

  @override
  String get android_permission_calendar => 'Calendar';

  @override
  String get android_permission_activity_recognition => 'Physical activity';

  @override
  String get android_permission_sensors => 'Device sensors';

  @override
  String get android_permission_sensors_body => 'Body sensors';

  @override
  String get android_permission_nearby_devices => 'Locate nearby devices';

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
}
