// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get locale_desc => 'עברית';

  @override
  String get locale_system => 'מערכת';

  @override
  String get btn_auth => 'אימות מחדש';

  @override
  String get btn_dev_settings => 'אפשרויות מפתח';

  @override
  String get btn_switch_on => 'פועל';

  @override
  String get btn_switch_off => 'כבוי';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'גרסת Windows ישנה יותר';

  @override
  String get status_unsupported => 'WSA לא מותקן';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => 'לא מאושר';

  @override
  String get status_unauthorized_desc =>
      'האימות לפיתוח נדחה או בוטל; לחץ על הכפתור הראשון, בחר תמיד מאשר ולחץ על מאשר; אם לא מופיע חלון קופץ, פתח אפשרויות מפתח וכבה ואפס הפעלה של ניפוי USB';

  @override
  String get status_missing => 'WSA לא מותקן';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'מתחבר';

  @override
  String get status_unknown_desc => 'ממתין ליצירת חיבור עם WSA...';

  @override
  String get status_starting => 'מפעיל';

  @override
  String get status_starting_desc => 'מפעיל את WSA, אנא המתן...';

  @override
  String get status_arrested => 'נעצר';

  @override
  String get status_arrested_desc => 'WSA כבוי';

  @override
  String get status_offline => 'Offline';

  @override
  String get status_offline_desc =>
      'לא ניתן להתחבר אל WSA: מצב מפתח ואיתור באגים ב-USB מושבתים או שצויין Port שגוי';

  @override
  String get status_disconnected => 'מנותק';

  @override
  String get status_disconnected_desc =>
      'לא ניתן היה ליצור חיבור עם WSA מסיבה לא ידועה';

  @override
  String get status_connected => 'מחובר';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'WSA PacMan - מנהל חבילות ל-WSA';

  @override
  String get screen_settings => 'הגדרות';

  @override
  String get wsa_manage => 'ניהול הגדרות האנדרואיד';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'WSA Port';

  @override
  String get settings_ip => 'כתובת ה-IP של ה-WSA';

  @override
  String get settings_autostart => 'הפעל אוטומטית את WSA לפני ההתקנה';

  @override
  String settings_timeout(String seconds) {
    return 'זמן מינימלי ($seconds שניות)';
  }

  @override
  String get settings_language => 'שפה';

  @override
  String get settings_option_generic_system => 'מערכת';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => 'ערכת נושא';

  @override
  String get theme_mode_dark => 'כהה';

  @override
  String get theme_mode_light => 'בהיר';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => 'צורת אייקונים מותאמת';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => 'עגול';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => 'האם ברצונך להתקין את היישום הזה?';

  @override
  String installer_info_version(String appVersion) {
    return 'גרסה: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'גרסה ישנה: $appVersionOld גרסה חדשה: $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'חתימה: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'מתקין את האפליקציה $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'האפליקציה $appTitle הותקנה בהצלחה';
  }

  @override
  String installer_fail(String appTitle) {
    return 'האפליקציה $appTitle לא הותקנה';
  }

  @override
  String get installer_error_nomsg => 'ההתקנה נכשלה, אבל לא זוהתה השגיאה.';

  @override
  String get installer_error_timeout =>
      'התקנה עברה את הזמן המוקצב, הלקוח לא מחכה עוד, אבל היא עדיין עשויה להיערך ברקע...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'נדרשת ניקוי ידני של קבצים בספרייה “$tempDir”';
  }

  @override
  String get installer_btn_starting => 'WSA מפעיל את...';

  @override
  String get installer_btn_loading => 'טוען...';

  @override
  String get installer_btn_cancel => 'ביטול';

  @override
  String get installer_btn_install => 'התקן';

  @override
  String get installer_btn_reinstall => 'התקן מחדש';

  @override
  String get installer_btn_update => 'עדכון';

  @override
  String get installer_btn_downgrade => 'שדרוג גרסה לאחור (לא בטוח)';

  @override
  String get installer_btn_dismiss => 'סגור';

  @override
  String get installer_btn_open => 'פתח אפליקציה';

  @override
  String get installer_btn_checkbox_shortcut => 'צור קיצור דרך בשולחן העבודה';

  @override
  String get android_permission_none => 'אין צורך בהרשאות';

  @override
  String get android_permission_admin => 'נהל את המכשיר כמנהל';

  @override
  String get android_permission_admin_brick => 'השבת או אפס את המכשיר מרחוק';

  @override
  String get android_permission_admin_lock => 'נעל את המכשיר מרחוק';

  @override
  String get android_permission_storage => 'קבצים ומדיה';

  @override
  String get android_permission_microphone => 'מיקרופון';

  @override
  String get android_permission_camera => 'מצלמה';

  @override
  String get android_permission_location => 'מיקום';

  @override
  String get android_permission_phone => 'טלפון';

  @override
  String get android_permission_call_log => 'יומן שיחות';

  @override
  String get android_permission_sms => 'הודעות';

  @override
  String get android_permission_contacts => 'אנשי קשר';

  @override
  String get android_permission_calendar => 'לוח שנה';

  @override
  String get android_permission_activity_recognition => 'פעילות גופנית';

  @override
  String get android_permission_sensors => 'חיישני מכשיר';

  @override
  String get android_permission_sensors_body => 'חיישני גוף';

  @override
  String get android_permission_nearby_devices => 'אתר מכשירים קרובים';

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
  String get btn_refresh_status => 'רענון סטטוס';

  @override
  String get tooltip_refresh_status => 'בדוק מחדש את סטטוס WSA עכשיו';

  @override
  String get btn_launch_wsa => 'הפעל WSA';
}
