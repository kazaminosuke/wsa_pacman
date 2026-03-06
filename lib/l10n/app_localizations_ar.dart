// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get locale_desc => 'العربية';

  @override
  String get locale_system => 'النظام';

  @override
  String get btn_boot => 'تشغيل';

  @override
  String get btn_auth => 'إعادة المصادقة';

  @override
  String get btn_dev_settings => 'خيارات المطور';

  @override
  String get btn_switch_on => 'مفعل';

  @override
  String get btn_switch_off => 'مغلق';

  @override
  String get status_subtext_winver_10 => 'ويندوز 10';

  @override
  String get status_subtext_winver_older => 'إصدار ويندوز أقدم';

  @override
  String get status_unsupported => 'حزمة WSA غير مثبتة';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => 'غير مصرح به';

  @override
  String get status_unauthorized_desc =>
      'تم رفض التصريح الإصداري أو الغاءه؛ اضغط على الزر الأول، اختر \'دائما السماح\'، ثم اضغط على \'السماح\'؛ إذا لم يظهر مربع حوار، فتح خيارات المطور وعطل وإعادة تمكين \'تصحيح USB\'';

  @override
  String get status_missing => 'حزمة WSA غير مثبتة';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'جاري الاتصال';

  @override
  String get status_unknown_desc => 'في انتظار الاتصال بWSA';

  @override
  String get status_starting => 'جاري التشغيل';

  @override
  String get status_starting_desc => 'جاري تشغيل WSA, برجاء الانتظار';

  @override
  String get status_arrested => 'غير مفعل';

  @override
  String get status_arrested_desc => 'WSA غير مفعل';

  @override
  String get status_offline => 'غير متصل';

  @override
  String get status_offline_desc =>
      'لم يمكن الاتصال بWSA: يمكن ان يكون وضع المطور غير مفعل, او تم تحديد المخرج الخاطىء';

  @override
  String get status_disconnected => 'لا يمكن الاتصال';

  @override
  String get status_disconnected_desc =>
      'لا يمكن عمل اتصال لWSA لاسباب غير معلومه';

  @override
  String get status_connected => 'متصل';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'مدير حزم الWSA';

  @override
  String get screen_settings => 'الضبط';

  @override
  String get wsa_manage => 'إدارة الاندرويد';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'مدخل الWSA';

  @override
  String get settings_ip => 'عنوان الIP الخاص بWSA';

  @override
  String get settings_autostart => 'تفعبل تلقائي لWSA قبل التثبيت';

  @override
  String settings_timeout(String seconds) {
    return 'مهلة ($seconds ثواني)';
  }

  @override
  String get settings_language => 'اللغة';

  @override
  String get settings_option_generic_system => 'النظام';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => 'وضع السمات';

  @override
  String get theme_mode_dark => 'داكن';

  @override
  String get theme_mode_light => 'ساطع';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => 'ايقونات متكيفة';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => 'دائري';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => 'هل تريد تثبيت هذا التطبيق؟';

  @override
  String installer_info_version(String appVersion) {
    return 'الإصدار: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'الإصدار: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'الحزمة: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'جاري تثبيث $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'تم تثبيت $appTitle بنجاح';
  }

  @override
  String installer_fail(String appTitle) {
    return 'لم يتم تثبيت $appTitle';
  }

  @override
  String get installer_error_nomsg => 'فشل التثبيت, لكن بلا أخطاء';

  @override
  String get installer_error_timeout =>
      'انتهت مهلة التثبيت، لقد توقف العميل عن الانتظار، لكن قد يظل التثبيت قيد التقدم في الخلفية...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'يلزم تنظيف يدوي للملفات في الدليل ‹$tempDir›';
  }

  @override
  String get installer_btn_starting => 'يتم التشغيل...';

  @override
  String get installer_btn_loading => 'تحميل...';

  @override
  String get installer_btn_cancel => 'إلغاء';

  @override
  String get installer_btn_install => 'تثبيت';

  @override
  String get installer_btn_reinstall => 'إعادة التثبيت';

  @override
  String get installer_btn_update => 'تحديث';

  @override
  String get installer_btn_downgrade => 'الرجوع إلى إصدار قديم(غير آمن)';

  @override
  String get installer_btn_dismiss => 'تم';

  @override
  String get installer_btn_open => 'فتح التطبيق';

  @override
  String get installer_btn_checkbox_shortcut => 'عمل اختصار على سطح المكتب';

  @override
  String get android_permission_none => 'لا يطلب اي اذونات';

  @override
  String get android_permission_admin => 'يدير الجهاز كمشرف';

  @override
  String get android_permission_admin_brick =>
      'يلغي تفعيل الجهاز او يعيد ضبطه عن بعد';

  @override
  String get android_permission_admin_lock => 'قفل الجهاز عن بعد';

  @override
  String get android_permission_storage => 'الملفات و الوسائط';

  @override
  String get android_permission_microphone => 'الميكروفون';

  @override
  String get android_permission_camera => 'الكاميرا';

  @override
  String get android_permission_location => 'الموقع';

  @override
  String get android_permission_phone => 'الهاتف';

  @override
  String get android_permission_call_log => 'سجلات المكالمات';

  @override
  String get android_permission_sms => 'الرسائل';

  @override
  String get android_permission_contacts => 'جهات الاتصال';

  @override
  String get android_permission_calendar => 'التقويم';

  @override
  String get android_permission_activity_recognition => 'الانشطة البدنية';

  @override
  String get android_permission_sensors => 'مستشعرات الجهاز';

  @override
  String get android_permission_sensors_body => 'مستشعرات البدن';

  @override
  String get android_permission_nearby_devices => 'تحديد الاجهزة القريبة';

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
