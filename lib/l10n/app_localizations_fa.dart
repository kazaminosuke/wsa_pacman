// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get locale_desc => 'فارسی';

  @override
  String get locale_system => 'سیستم';

  @override
  String get btn_boot => 'روشن کردن';

  @override
  String get btn_auth => 'تأیید دوباره';

  @override
  String get btn_dev_settings => 'گزینه‌های توسعه‌دهنده';

  @override
  String get btn_switch_on => 'روشن';

  @override
  String get btn_switch_off => 'خاموش';

  @override
  String get status_subtext_winver_10 => 'ویندوز 10';

  @override
  String get status_subtext_winver_older => 'نسخه قدیمی ویندوز';

  @override
  String get status_unsupported => 'WSA نصب نشده';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion شناسایی شد و یافت نشد. این برنامه به WSA وابسته است که به طور رسمی فقط  در ویندوز 11 پشتیبانی می شود';
  }

  @override
  String get status_unauthorized => 'غیر مجاز';

  @override
  String get status_unauthorized_desc =>
      'تأیید توسعه دهنده رد شده یا لغو شده است؛ لطفا دکمه اول را کلیک کنید، «همیشه مجاز» را انتخاب کرده و روی «مجاز» کلیک کنید؛ اگر پنجره پاپ آپ نشان ندهد، گزینه های توسعه دهنده را باز کرده و غیر فعال کردن و دوباره فعال کردن \'دیباگ USB\'';

  @override
  String get status_missing => 'WSA نصب نشده';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'Connecting';

  @override
  String get status_unknown_desc => 'در انتظار برقراری اتصال WSA...';

  @override
  String get status_starting => 'شروع ...';

  @override
  String get status_starting_desc =>
      'WSA در حال شروع است، لطفا منتظر بمانید...';

  @override
  String get status_arrested => 'دستگیر شد';

  @override
  String get status_arrested_desc => 'WSA خاموش شد';

  @override
  String get status_offline => 'آفلاین';

  @override
  String get status_offline_desc =>
      'اتصال با WSA امکان‌پذیر نیست: یا حالت برنامه‌نویس و اشکال‌زدایی USB غیرفعال هستند یا پورت اشتباهی مشخص شده است.';

  @override
  String get status_disconnected => 'قطع شده';

  @override
  String get status_disconnected_desc =>
      'اتصال WSA به دلایل نامعلومی برقرار نشد';

  @override
  String get status_connected => 'وصل شده';

  @override
  String get status_connected_desc =>
      'با موفقیت به WSA متصل شد، سیستم ها کار میکند';

  @override
  String get screen_wsa => 'مدیریت بسته WSA';

  @override
  String get screen_settings => 'تنظیمان';

  @override
  String get wsa_manage => 'مدیریت اندروید';

  @override
  String get wsa_manage_app => 'مدیریت برنامه ها';

  @override
  String get wsa_manage_settings => 'مدیریت تنظیمات';

  @override
  String get settings_port => 'پورت WSA';

  @override
  String get settings_ip => 'آدری آی پی WSA';

  @override
  String get settings_autostart =>
      'قبل از نصب WSA را به صورت خودکار راه اندازی شود';

  @override
  String settings_timeout(String seconds) {
    return 'زمان مجاز ($seconds ثانیه)';
  }

  @override
  String get settings_language => 'زبان';

  @override
  String get settings_option_generic_system => 'سیستم';

  @override
  String get settings_option_generic_disabled => 'غیرفعال';

  @override
  String get theme_mode => 'نوع زمینه';

  @override
  String get theme_mode_dark => 'تاریک';

  @override
  String get theme_mode_light => 'روشن';

  @override
  String get theme_mica => 'شفافیت پنجره ها';

  @override
  String get theme_mica_full => 'کامل';

  @override
  String get theme_mica_partial => 'جزئي';

  @override
  String get theme_icon_adaptive => 'سازگارسازی آیکون';

  @override
  String get theme_icon_adaptive_squircle => 'مربع';

  @override
  String get theme_icon_adaptive_circle => 'دایره';

  @override
  String get theme_icon_adaptive_rounded_square => 'گوشه های کرد';

  @override
  String get installer_message => 'آیا از نصب این برنامه اطمینان دارید؟';

  @override
  String installer_info_version(String appVersion) {
    return 'تسخه: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'نسخه: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'بسته: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'در حال نصب $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'برنامه $appTitle نصب شد';
  }

  @override
  String installer_fail(String appTitle) {
    return 'برنامه $appTitle نصب نشد.';
  }

  @override
  String get installer_error_nomsg => 'نصب انجام نشد، اما خطایی هم رخ نداد';

  @override
  String get installer_error_timeout =>
      'زمان نصب تمام شد، مشتری نیازی به صبر ندارد، اما فرایند هنوز ممکن است در پسزمینه داشته باشد...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'شاید نیاز به پاک کردن دستی فایل‌ها در پوشه ‌«$tempDir» باشد';
  }

  @override
  String get installer_btn_starting => 'شروع...';

  @override
  String get installer_btn_loading => 'بارگذاری...';

  @override
  String get installer_btn_cancel => 'لغو';

  @override
  String get installer_btn_install => 'نصب';

  @override
  String get installer_btn_reinstall => 'نصب مجدد';

  @override
  String get installer_btn_update => 'بروزرسانی';

  @override
  String get installer_btn_downgrade => 'Downgrade (امن نیست)';

  @override
  String get installer_btn_dismiss => 'رد کردن';

  @override
  String get installer_btn_open => 'باز کردن';

  @override
  String get installer_btn_checkbox_shortcut => 'ساخت میانبر در دسکتاپ';

  @override
  String get android_permission_none => 'هیچ مجوزی لازم نیست';

  @override
  String get android_permission_admin => 'مدیریت دستگاه';

  @override
  String get android_permission_admin_brick =>
      'غیرفعال یا بازنشانی دستگاه از راه دور';

  @override
  String get android_permission_admin_lock => 'قفل دستگاه از راه دور';

  @override
  String get android_permission_storage => 'فایل ها و رسانه ها';

  @override
  String get android_permission_microphone => 'میکروفون';

  @override
  String get android_permission_camera => 'دوربین';

  @override
  String get android_permission_location => 'موقعیت مکانی';

  @override
  String get android_permission_phone => 'تلفن';

  @override
  String get android_permission_call_log => 'تماس ها';

  @override
  String get android_permission_sms => 'پیام ها';

  @override
  String get android_permission_contacts => 'مخاطبین';

  @override
  String get android_permission_calendar => 'تقویم';

  @override
  String get android_permission_activity_recognition => 'فعالیت های بدنی';

  @override
  String get android_permission_sensors => 'سنسور دستگاه';

  @override
  String get android_permission_sensors_body => 'سنسور بدن';

  @override
  String get android_permission_nearby_devices => 'پیدا کردن دستگاه های نزدیک';
}
