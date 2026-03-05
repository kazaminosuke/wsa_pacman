// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get locale_desc => 'Tiếng Việt';

  @override
  String get locale_system => 'Hệ thống';

  @override
  String get btn_boot => 'Chế độ';

  @override
  String get btn_auth => 'Đăng nhập lại';

  @override
  String get btn_dev_settings => 'Tùy chọn nhà phát triển';

  @override
  String get btn_switch_on => 'Bật';

  @override
  String get btn_switch_off => 'Tắt';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'Phiên bản Windows cũ hơn';

  @override
  String get status_unsupported => 'WSA chưa được cài đặt';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion phát hiện và không tìm thấy WSA; ứng dụng này phụ thuộc vào WSA, chỉ được hỗ trợ chính thức trên Windows 11';
  }

  @override
  String get status_unauthorized => 'Không được phép';

  @override
  String get status_unauthorized_desc =>
      'Đã từ chối hoặc thu hồi quyền xác minh gỡ lỗi; nhấn vào nút đầu tiên, chọn \'luôn cho phép\', sau đó nhấp vào \'cho phép\'; Nếu không có cửa sổ xuất hiện, mở tùy chọn nhà phát triển và vô hiệu hóa rồi bật lại \'gỡ lỗi USB\'';

  @override
  String get status_missing => 'WSA chưa được cài đặt';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => 'Đang kết nối';

  @override
  String get status_unknown_desc => 'Đang đợi kết nối WSA được thiết lập...';

  @override
  String get status_starting => 'Bắt đầu';

  @override
  String get status_starting_desc => 'WSA đang bắt đầu, vui lòng chờ...';

  @override
  String get status_arrested => 'Tắt';

  @override
  String get status_arrested_desc => 'WSA đã bị tắt';

  @override
  String get status_offline => 'Ngoại tuyến';

  @override
  String get status_offline_desc =>
      'Không thể thiết lập kết nối với WSA: Chế độ nhà phát triển và gỡ lỗi USB đã bị tắt hoặc sai cổng (Port) được chỉ định';

  @override
  String get status_disconnected => 'Đã ngắt kết nối';

  @override
  String get status_disconnected_desc =>
      'Kết nối WSA không thể được thiết lập vì những lý do không xác định';

  @override
  String get status_connected => 'Đã kết nối';

  @override
  String get status_connected_desc =>
      'Kết nối thành công với WSA, tất cả các hệ thống đều hoạt động';

  @override
  String get screen_wsa => 'Trình Quản Lý Cài Đặt - WSA';

  @override
  String get screen_settings => 'Cài Đặt';

  @override
  String get wsa_manage => 'Quản Lý Android';

  @override
  String get wsa_manage_app => 'Quản lý ứng dụng';

  @override
  String get wsa_manage_settings => 'Quản lý cài đặt';

  @override
  String get settings_port => 'Cổng WSA (Port)';

  @override
  String get settings_ip => 'Địa chỉ IP WSA';

  @override
  String get settings_autostart => 'Tự động khởi động WSA trước khi cài đặt';

  @override
  String settings_timeout(String seconds) {
    return 'Thời gian chờ ($seconds giây)';
  }

  @override
  String get settings_language => 'Ngôn ngữ';

  @override
  String get settings_option_generic_system => 'Hệ thống';

  @override
  String get settings_option_generic_disabled => 'Vô hiệu hóa';

  @override
  String get theme_mode => 'Giao diện';

  @override
  String get theme_mode_dark => 'Tối';

  @override
  String get theme_mode_light => 'Sáng';

  @override
  String get theme_mica => 'Độ trong suốt của cửa sổ';

  @override
  String get theme_mica_full => 'Tất cả';

  @override
  String get theme_mica_partial => 'Một phần nào đó';

  @override
  String get theme_icon_adaptive => 'Biểu tượng icon';

  @override
  String get theme_icon_adaptive_squircle => 'Hình vuông';

  @override
  String get theme_icon_adaptive_circle => 'Vòng tròn';

  @override
  String get theme_icon_adaptive_rounded_square => 'Hình vuông (góc tròn)';

  @override
  String get installer_message => 'Bạn có muốn cài đặt ứng dụng này không?';

  @override
  String installer_info_version(String appVersion) {
    return 'Phiên bản: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'Phiên bản: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'Gói: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Cài đặt ứng dụng $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'Ứng dụng $appTitle đã được cài đặt thành công';
  }

  @override
  String installer_fail(String appTitle) {
    return 'Ứng dụng $appTitle chưa được cài đặt';
  }

  @override
  String get installer_error_nomsg =>
      'Cài đặt không thành công, nhưng không có lỗi nào được đưa ra';

  @override
  String get installer_error_timeout =>
      'Quá thời gian cài đặt, khách hàng đã ngừng chờ, nhưng nó có thể vẫn đang tiếp diễn ở nền...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'Cần thực hiện việc dọn dẹp tập tin thủ công trong thư mục “$tempDir”';
  }

  @override
  String get installer_btn_starting => 'Đang bắt đầu...';

  @override
  String get installer_btn_loading => 'Đang tải...';

  @override
  String get installer_btn_cancel => 'Hủy bỏ';

  @override
  String get installer_btn_install => 'Cài đặt';

  @override
  String get installer_btn_reinstall => 'Cài đặt lại';

  @override
  String get installer_btn_update => 'Cập nhật';

  @override
  String get installer_btn_downgrade => 'Hạ cấp (không an toàn)';

  @override
  String get installer_btn_dismiss => 'Bỏ qua';

  @override
  String get installer_btn_open => 'Chạy ứng dụng';

  @override
  String get installer_btn_checkbox_shortcut => 'Tạo lối tắt trên màn hình';

  @override
  String get android_permission_none => 'Không cần quyền';

  @override
  String get android_permission_admin =>
      'Quản lý thiết bị với tư cách Quản Trị Viên';

  @override
  String get android_permission_admin_brick =>
      'Vô hiệu hóa hoặc đặt lại thiết bị từ xa';

  @override
  String get android_permission_admin_lock => 'Khóa thiết bị từ xa';

  @override
  String get android_permission_storage => 'Tập tin và phương tiện';

  @override
  String get android_permission_microphone => 'Microphone';

  @override
  String get android_permission_camera => 'Máy ảnh';

  @override
  String get android_permission_location => 'Vị trí';

  @override
  String get android_permission_phone => 'Điện thoại';

  @override
  String get android_permission_call_log => 'Nhật ký cuộc gọi';

  @override
  String get android_permission_sms => 'Tin nhắn';

  @override
  String get android_permission_contacts => 'Danh bạn';

  @override
  String get android_permission_calendar => 'Lịch';

  @override
  String get android_permission_activity_recognition => 'Hoạt động thể chất';

  @override
  String get android_permission_sensors => 'Cảm biến thiết bị';

  @override
  String get android_permission_sensors_body => 'Cảm biến cơ thể';

  @override
  String get android_permission_nearby_devices =>
      'Xác định vị trí các thiết bị lân cận';

  @override
  String get screen_uninstall => 'Gỡ cài đặt';

  @override
  String get scan_system => 'Quét hệ thống';

  @override
  String get scanning => 'Đang quét...';

  @override
  String get backup_registry => 'Sao lưu Registry';

  @override
  String get execute_cleanup => 'Thực hiện dọn dẹp';

  @override
  String get scanning_wsa_env => 'Đang quét môi trường WSA một cách sâu...';

  @override
  String get click_scan_to_find_ghost_apps =>
      'Nhấp vào \'Quét hệ thống\' để tìm các ứng dụng còn sót lại hoặc bị ẩn.';

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
