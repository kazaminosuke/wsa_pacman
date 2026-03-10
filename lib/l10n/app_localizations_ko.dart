// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get locale_desc => '한국어';

  @override
  String get locale_system => '시스템';

  @override
  String get btn_auth => '다시 인증';

  @override
  String get btn_dev_settings => '개발자 옵션';

  @override
  String get btn_switch_on => '켬';

  @override
  String get btn_switch_off => '끔';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => '구형 Windows';

  @override
  String get status_unsupported => 'WSA가 설치되지 않음';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => '인증되지 않음';

  @override
  String get status_unauthorized_desc =>
      '디버깅 인증이 거부되었거나 취소되었습니다. 첫 번째 버튼을 누르고 \'항상 허용\'을 선택하고 \'허용\'을 클릭하세요. 팝업이 나타나지 않으면 개발자 옵션을 열고 USB 디버깅을 비활성화하고 재활성화하세요.';

  @override
  String get status_missing => 'WSA가 설치되지 않음';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => '연결 중';

  @override
  String get status_unknown_desc => 'WSA에 연결되기를 기다리고 있습니다...';

  @override
  String get status_starting => '시작 중';

  @override
  String get status_starting_desc => 'WSA를 시작하고 있습니다, 잠시 기다려주십시오...';

  @override
  String get status_arrested => '정지됨';

  @override
  String get status_arrested_desc => 'WSA가 꺼졌습니다';

  @override
  String get status_offline => '오프라인';

  @override
  String get status_offline_desc =>
      'WSA에 연결할 수 없습니다: 개발자 모드 및 USB 디버깅이 꺼져 있거나 포트가 잘못 지정되었습니다';

  @override
  String get status_disconnected => '연결 끊김';

  @override
  String get status_disconnected_desc => '알 수 없는 이유로 WSA에 연결할 수 없습니다';

  @override
  String get status_connected => '연결됨';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'WSA 패키지 관리자';

  @override
  String get screen_settings => '설정';

  @override
  String get wsa_manage => 'Android 관리';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'WSA 포트';

  @override
  String get settings_ip => 'WSA IP 주소';

  @override
  String get settings_autostart => '설치 전 WSA 자동 실행';

  @override
  String settings_timeout(String seconds) {
    return '시간 초과 ($seconds 초)';
  }

  @override
  String get settings_language => '언어';

  @override
  String get settings_option_generic_system => '시스템';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => '테마';

  @override
  String get theme_mode_dark => '어둡게';

  @override
  String get theme_mode_light => '밝게';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => '적응형 아이콘 모양';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => '원형';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => '이 애플리케이션을 설치하시겠습니까?';

  @override
  String installer_info_version(String appVersion) {
    return '버전: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return '버전: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return '패키지: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return '$appTitle 앱을 설치하고 있습니다...';
  }

  @override
  String installer_installed(String appTitle) {
    return '$appTitle 앱이 성공적으로 설치되었습니다';
  }

  @override
  String installer_fail(String appTitle) {
    return '$appTitle 앱이 설치되지 않았습니다';
  }

  @override
  String get installer_error_nomsg => '설치에 실패하였으나, 오류를 확인할 수 없습니다';

  @override
  String get installer_error_timeout =>
      '설치가 시간 초과되었습니다. 클라이언트는 더 이상 기다리지 않지만 백그라운드에서는 아직 진행 중일 수 있습니다...';

  @override
  String installer_warning_dirty(String tempDir) {
    return '디렉터리 “$tempDir” 에서 수동 파일 정리가 필요합니다';
  }

  @override
  String get installer_btn_starting => '시작하는 중...';

  @override
  String get installer_btn_loading => '불러오는 중...';

  @override
  String get installer_btn_cancel => '취소';

  @override
  String get installer_btn_install => '설치';

  @override
  String get installer_btn_reinstall => '재설치';

  @override
  String get installer_btn_update => '업데이트';

  @override
  String get installer_btn_downgrade => '다운그레이드 (불안정)';

  @override
  String get installer_btn_dismiss => '다시는 알리지 않음';

  @override
  String get installer_btn_open => '앱 열기';

  @override
  String get installer_btn_checkbox_shortcut => '바탕화면 바로가기 생성';

  @override
  String get android_permission_none => '권한 필요 없음';

  @override
  String get android_permission_admin => '관리자 권한으로 기기 관리';

  @override
  String get android_permission_admin_brick => '기기 원격 비활성화 및 초기화';

  @override
  String get android_permission_admin_lock => '기기 원격 잠금';

  @override
  String get android_permission_storage => '파일 및 미디어';

  @override
  String get android_permission_microphone => '마이크';

  @override
  String get android_permission_camera => '카메라';

  @override
  String get android_permission_location => '위치';

  @override
  String get android_permission_phone => '전화';

  @override
  String get android_permission_call_log => '통화 기록';

  @override
  String get android_permission_sms => '메시지';

  @override
  String get android_permission_contacts => '주소록';

  @override
  String get android_permission_calendar => '일정';

  @override
  String get android_permission_activity_recognition => '신체 활동';

  @override
  String get android_permission_sensors => '기기 센서';

  @override
  String get android_permission_sensors_body => '신체 센서';

  @override
  String get android_permission_nearby_devices => '근처 장치 찾기';

  @override
  String get screen_uninstall => '제거';

  @override
  String get scan_system => '시스템 검색';

  @override
  String get scanning => '검색 중...';

  @override
  String get backup_registry => '레지스트리 백업';

  @override
  String get execute_cleanup => '정리 실행';

  @override
  String get scanning_wsa_env => 'WSA 환경을 깊이 검색 중...';

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
  String get btn_refresh_status => '상태 새로 고침';

  @override
  String get tooltip_refresh_status => 'WSA 상태를 지금 다시 확인';

  @override
  String get btn_launch_wsa => 'WSA 시작';
}
