// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kurdish (`ku`).
class AppLocalizationsKu extends AppLocalizations {
  AppLocalizationsKu([String locale = 'ku']) : super(locale);

  @override
  String get locale_desc => 'کوردی';

  @override
  String get locale_system => 'سیستەم';

  @override
  String get btn_boot => 'کارای بکە';

  @override
  String get btn_auth => 'دووبارە سەلماندن';

  @override
  String get btn_dev_settings => 'ھەڵبژاردەکانی پەرەپێدەر';

  @override
  String get btn_switch_on => 'ھەڵبوو';

  @override
  String get btn_switch_off => 'کوژاوە';

  @override
  String get status_subtext_winver_10 => 'ویندۆزی ١٠';

  @override
  String get status_subtext_winver_older => 'وەشانێکی ویندۆزی کۆنتر';

  @override
  String get status_unsupported => 'WSA دانەمەزێندراوە';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion ناسرایەوە و WSA نەدۆزرایەوە؛ ئەم بەرنامەیە لەسەر WSA بەندە، کە بە فەرمی تەنیا لەسەر ویندۆزی ١١ پاڵپشتیی دەکرێت';
  }

  @override
  String get status_unauthorized => 'ڕێگەپێنەدراو';

  @override
  String get status_unauthorized_desc =>
      'Debugging authorization was dismissed or revoked; press the first button, select \'always allow\', then click on \'allow\'; If no popup appears, open developer options and disable and re-enable \'USB debugging\'';

  @override
  String get status_missing => 'WSA دانەبەزێندراوە';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'Connecting';

  @override
  String get status_unknown_desc =>
      'چاوەڕوانی پەیوەندیی WSAین تاکوو جێگیر بێت...';

  @override
  String get status_starting => 'دەستپێکردن';

  @override
  String get status_starting_desc => 'WSA دەست پێ دەکات، تکایە چاوەڕوان بە...';

  @override
  String get status_arrested => 'گیرا';

  @override
  String get status_arrested_desc => 'WSA کوژاوەتەوە';

  @override
  String get status_offline => 'دەرھێڵ';

  @override
  String get status_offline_desc =>
      'نەتواندرا کە پەیوەندییەک جێگیر بکرێت لەگەڵ WSAدا: یان شێوەی پەرەپێدەر و ھەڵەلابردنی یوو ئێس ی ناکاران یان پۆڕتێکی ھەڵە دیاری کراوە';

  @override
  String get status_disconnected => 'ناپەیوەست';

  @override
  String get status_disconnected_desc =>
      'نەتواندرا پەیوەندییەکی WSA جێگیر بکرێت لەبەر ھۆکارێکی نەزاندراو';

  @override
  String get status_connected => 'پەیوەست';

  @override
  String get status_connected_desc => 'بە سەرکەتوویی پەیوەست بوویت بە WSAیەوە!';

  @override
  String get screen_wsa => 'بەڕێوەبەری پاکێجی WSA';

  @override
  String get screen_settings => 'ڕێکخستنەکان';

  @override
  String get wsa_manage => 'بەڕێوەبردنی ئەندرۆید';

  @override
  String get wsa_manage_app => 'بەڕێوەبردنی بەرنامەکان';

  @override
  String get wsa_manage_settings => 'بەڕێوەبرردنی ڕێکخستنەکان';

  @override
  String get settings_port => 'پۆڕتی WSA';

  @override
  String get settings_ip => 'ناونیشانی ئای پیی WSA';

  @override
  String get settings_autostart => 'خۆگەڕانە WSA کارپێبکە پێش دامەزراندن';

  @override
  String settings_timeout(String seconds) {
    return 'کات تەواو بوو ($seconds چرکە)';
  }

  @override
  String get settings_language => 'زمان';

  @override
  String get settings_option_generic_system => 'سیستەم';

  @override
  String get settings_option_generic_disabled => 'ناکارا';

  @override
  String get theme_mode => 'شێوەی ڕووکار';

  @override
  String get theme_mode_dark => 'تاریک';

  @override
  String get theme_mode_light => 'ڕووناک';

  @override
  String get theme_mica => 'ڕووتەنکیی شاشە';

  @override
  String get theme_mica_full => 'تەواو';

  @override
  String get theme_mica_partial => 'نیمچە';

  @override
  String get theme_icon_adaptive => 'قەبارەی ئایکۆنی گونجێنەر';

  @override
  String get theme_icon_adaptive_squircle => 'چوارگۆشە و بازنە';

  @override
  String get theme_icon_adaptive_circle => 'بازنە';

  @override
  String get theme_icon_adaptive_rounded_square => 'چوارگۆشەی خڕ';

  @override
  String get installer_message => 'دەتەوێت ئەم بەرنامەیە داببەزێنیت؟';

  @override
  String installer_info_version(String appVersion) {
    return 'وەشان: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'وەشان: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'پاکێج: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return '$appTitle دادەبەزێت...';
  }

  @override
  String installer_installed(String appTitle) {
    return '$appTitle بە سەرکەوتوویی دابەزێندرا';
  }

  @override
  String installer_fail(String appTitle) {
    return '$appTitle دانەبەزێندرا';
  }

  @override
  String get installer_error_nomsg =>
      'دابەزینەکە شکستی ھێنا، بەڵام ھیچ ھەڵەیەک نەدۆرایەوە';

  @override
  String get installer_error_timeout =>
      'کاتی دابەزین تەواو بوو، ڕاژەخواز وەستا لە چاوەڕوانی، بەڵام لەوانەیە لە پشتەوە ھەر بەردەوام بێت...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'سڕینەوەی فایل پێویستە لە “$tempDir” بە شێوەیەکی دەستی';
  }

  @override
  String get installer_btn_starting => 'دەستپێکردن...';

  @override
  String get installer_btn_loading => 'بارکردن...';

  @override
  String get installer_btn_cancel => 'ھەڵوەشاندنەوە';

  @override
  String get installer_btn_install => 'دابەزاندن';

  @override
  String get installer_btn_reinstall => 'دووبارە دابەزاندن';

  @override
  String get installer_btn_update => 'نوێکردنەوە';

  @override
  String get installer_btn_downgrade => 'کەمکردنەوە (سەلامەت نییە)';

  @override
  String get installer_btn_dismiss => 'ڕەتکردنەوە';

  @override
  String get installer_btn_open => 'بەرنامەکە بکەرەوە';

  @override
  String get installer_btn_checkbox_shortcut =>
      'شۆڕتکەتی سەر دێسکتۆپ دروست بکە';

  @override
  String get android_permission_none => 'ھیچ ڕێپێدانێک پێویست نییە';

  @override
  String get android_permission_admin => 'ئامێرەکە بەڕێوە ببە وەک بەڕێوەبەر';

  @override
  String get android_permission_admin_brick =>
      'لە دوورەوە ئامێرەکە ناکارا بکە یان ڕێکیبخەرەوە';

  @override
  String get android_permission_admin_lock => 'لە دوورەوە ئامێرەکە قفڵ بکە';

  @override
  String get android_permission_storage => 'فایل و میدیاکان';

  @override
  String get android_permission_microphone => 'مایکرۆفۆن';

  @override
  String get android_permission_camera => 'کامێرا';

  @override
  String get android_permission_location => 'ناونیشان';

  @override
  String get android_permission_phone => 'تەلەفون';

  @override
  String get android_permission_call_log => 'تۆماری پەیوەندییەکان';

  @override
  String get android_permission_sms => 'نامەکان';

  @override
  String get android_permission_contacts => 'ھەژماری پەیوەندییەکان';

  @override
  String get android_permission_calendar => 'ڕۆژژمێر';

  @override
  String get android_permission_activity_recognition => 'چالاکیی جەستەیی';

  @override
  String get android_permission_sensors => 'ھەستەوەرەکانی ئامێر';

  @override
  String get android_permission_sensors_body => 'ھەستەوەرەکانی جەستە';

  @override
  String get android_permission_nearby_devices => 'ئامێرە نزیکەکان بدۆزەرەوە';
}
