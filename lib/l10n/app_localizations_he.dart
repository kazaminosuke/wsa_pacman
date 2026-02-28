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
  String get btn_boot => 'הפעל';

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
    return 'זוהתה מערכת הפעלה $windowsVersion WSA ולא נמצא; תוכנה זו תלויה ב WSA, אשר נתמך רשמית רק ב-Windows 11.';
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
  String get status_connected_desc => 'מחובר בהצלחה ל-WSA, כל המערכות עוברות.';

  @override
  String get screen_wsa => 'WSA PacMan - מנהל חבילות ל-WSA';

  @override
  String get screen_settings => 'הגדרות';

  @override
  String get wsa_manage => 'ניהול הגדרות האנדרואיד';

  @override
  String get wsa_manage_app => 'נהל אפליקציות';

  @override
  String get wsa_manage_settings => 'נהל הגדרות';

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
  String get settings_option_generic_disabled => 'כבוי';

  @override
  String get theme_mode => 'ערכת נושא';

  @override
  String get theme_mode_dark => 'כהה';

  @override
  String get theme_mode_light => 'בהיר';

  @override
  String get theme_mica => 'שקיפות חלון';

  @override
  String get theme_mica_full => 'מלא';

  @override
  String get theme_mica_partial => 'חלקי';

  @override
  String get theme_icon_adaptive => 'צורת אייקונים מותאמת';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (צורה בין ריבוע לעיגול)';

  @override
  String get theme_icon_adaptive_circle => 'עגול';

  @override
  String get theme_icon_adaptive_rounded_square => 'ריבוע עם פינות מעוגלות';

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
}
