// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get locale_desc => '中文 (简体)';

  @override
  String get locale_system => '系统';

  @override
  String get btn_boot => '启动';

  @override
  String get btn_auth => '重新认证';

  @override
  String get btn_dev_settings => '开发者选项';

  @override
  String get btn_switch_on => '打开';

  @override
  String get btn_switch_off => '关闭';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => '旧 Windows 版本';

  @override
  String get status_unsupported => 'WSA 未安装';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => '未授权';

  @override
  String get status_unauthorized_desc =>
      '调试授权被拒绝或撤销；点击第一个按钮，选择“始终允许”，然后点击“允许”；如果没有弹出窗口，请打开开发者选项并禁用和重新启用“USB调试”';

  @override
  String get status_missing => 'WSA 未安装';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => '正在连接';

  @override
  String get status_unknown_desc => '正在等待建立 WSA 连接...';

  @override
  String get status_starting => '正在启动';

  @override
  String get status_starting_desc => 'WSA 正在启动，请稍候...';

  @override
  String get status_arrested => '已停滞';

  @override
  String get status_arrested_desc => 'WSA 已关闭';

  @override
  String get status_offline => '离线';

  @override
  String get status_offline_desc => '无法与 WSA 建立连接：开发者模式和 USB 调试被禁用或指定了错误的端口';

  @override
  String get status_disconnected => '已断开连接';

  @override
  String get status_disconnected_desc => '由于未知原因，无法建立 WSA 连接';

  @override
  String get status_connected => '已连接';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'WSA 包管理器';

  @override
  String get screen_settings => '设置';

  @override
  String get wsa_manage => 'Android 管理';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'WSA 端口';

  @override
  String get settings_ip => 'WSA IP 地址';

  @override
  String get settings_autostart => '在安装之前自动启动 WSA';

  @override
  String settings_timeout(String seconds) {
    return '超时 ($seconds 秒)';
  }

  @override
  String get settings_language => '语言';

  @override
  String get settings_option_generic_system => '系统';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => '主题模式';

  @override
  String get theme_mode_dark => '深色模式';

  @override
  String get theme_mode_light => '浅色模式';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => '自适应图标形状';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => '圆形';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => '您要安装此应用程序吗？';

  @override
  String installer_info_version(String appVersion) {
    return '版本：$appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return '版本：$appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return '包名：$appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return '正在安装 $appTitle 应用程序...';
  }

  @override
  String installer_installed(String appTitle) {
    return '应用程序 $appTitle 已成功安装';
  }

  @override
  String installer_fail(String appTitle) {
    return '应用程序 $appTitle 未安装';
  }

  @override
  String get installer_error_nomsg => '安装失败，但没有抛出错误';

  @override
  String get installer_error_timeout => '安装已超时，客户端已停止等待，但可能仍在后台执行...';

  @override
  String installer_warning_dirty(String tempDir) {
    return '目录「$tempDir」需要手动清理文件';
  }

  @override
  String get installer_btn_starting => '正在启动...';

  @override
  String get installer_btn_loading => '加载中...';

  @override
  String get installer_btn_cancel => '取消';

  @override
  String get installer_btn_install => '安装';

  @override
  String get installer_btn_reinstall => '重新安装';

  @override
  String get installer_btn_update => '更新';

  @override
  String get installer_btn_downgrade => '降级（不安全）';

  @override
  String get installer_btn_dismiss => '完成';

  @override
  String get installer_btn_open => '打开应用程序';

  @override
  String get installer_btn_checkbox_shortcut => '创建桌面快捷方式';

  @override
  String get android_permission_none => '不需要任何权限';

  @override
  String get android_permission_admin => '以管理员身份管理设备';

  @override
  String get android_permission_admin_brick => '远程禁用或重置设备';

  @override
  String get android_permission_admin_lock => '远程锁定设备';

  @override
  String get android_permission_storage => '文件和媒体';

  @override
  String get android_permission_microphone => '麦克风';

  @override
  String get android_permission_camera => '相机';

  @override
  String get android_permission_location => '位置';

  @override
  String get android_permission_phone => '电话';

  @override
  String get android_permission_call_log => '通话记录';

  @override
  String get android_permission_sms => '信息';

  @override
  String get android_permission_contacts => '联系人';

  @override
  String get android_permission_calendar => '日历';

  @override
  String get android_permission_activity_recognition => '体育活动';

  @override
  String get android_permission_sensors => '设备传感器';

  @override
  String get android_permission_sensors_body => '身体传感器';

  @override
  String get android_permission_nearby_devices => '查找附近的设备';

  @override
  String get screen_uninstall => '卸载';

  @override
  String get scan_system => '扫描系统';

  @override
  String get scanning => '正在扫描...';

  @override
  String get backup_registry => '备份注册表';

  @override
  String get execute_cleanup => '执行清理';

  @override
  String get scanning_wsa_env => '深度扫描 WSA 环境...';

  @override
  String get click_scan_to_find_ghost_apps => '点击“扫描系统”以查找残留或隐藏的应用程序。';

  @override
  String get type_registry_only => '仅注册表';

  @override
  String get type_orphaned_shortcut => '孤立快捷方式';

  @override
  String get type_hidden_adb_app => '隐藏 ADB 应用程序';

  @override
  String get cleanup_complete => 'Cleanup Complete';

  @override
  String cleanup_success_desc(int count) {
    return 'Completely deleted $count apps and unnecessary data.';
  }

  @override
  String get auto_backup_registry => '卸载前自动备份注册表';

  @override
  String get backup_cancelled => '备份已取消';

  @override
  String get backup_success => '备份已成功保存';

  @override
  String get btn_restart_wsa => '重启 WSA';

  @override
  String get settings_auto_backup_dir => '自动备份目录';

  @override
  String get tooltip_reset_desktop => '重置为默认桌面';

  @override
  String get btn_browse => '浏览...';

  @override
  String get settings_theme_color => '主题颜色';

  @override
  String get settings_theme_color_system => '系统 (Windows)';

  @override
  String get settings_theme_color_default => '默认';

  @override
  String get settings_custom_color => '创建自定义颜色:';

  @override
  String get btn_apply => '应用';

  @override
  String get dialog_backup_dir_title => '选择一个文件夹来保存自动备份';

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

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get locale_desc => '中文 (繁體)';

  @override
  String get locale_system => '系統';

  @override
  String get btn_boot => '啟動';

  @override
  String get btn_auth => '重新驗證';

  @override
  String get btn_dev_settings => '開發者選項';

  @override
  String get btn_switch_on => '開';

  @override
  String get btn_switch_off => '關';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => '舊 Windows 版本';

  @override
  String get status_unsupported => '尚未安裝 WSA ';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.';
  }

  @override
  String get status_unauthorized => '未授權';

  @override
  String get status_unauthorized_desc =>
      '調試授權被拒絕或撤銷；按一下第一個按鈕，選擇“總是允許”，然後點擊“允許”；如果沒有彈出窗口，請打開開發人員選項並禁用和重新啟用“USB調試”';

  @override
  String get status_missing => '未安裝 Android 子系統';

  @override
  String get status_missing_desc =>
      'WSA could not be found on your system.\nSince the official Microsoft WSA has been discontinued, we recommend installing the community-driven \'WSABuilds\'.';

  @override
  String get btn_wsabuilds => 'Open WSABuilds (GitHub)';

  @override
  String get status_unknown => '正在連接';

  @override
  String get status_unknown_desc => '正在等待建立 WSA 連接...';

  @override
  String get status_starting => '正在啟動';

  @override
  String get status_starting_desc => 'WSA 正在啟動，請稍候...';

  @override
  String get status_arrested => '已停滯';

  @override
  String get status_arrested_desc => 'WSA 已關閉';

  @override
  String get status_offline => '離線';

  @override
  String get status_offline_desc =>
      '無法與 Android 子系統建立連接：可能的原因是未開啟開發者模式或 USB 調試被關閉或被指定了錯誤的端口。';

  @override
  String get status_disconnected => '已斷開連接';

  @override
  String get status_disconnected_desc => '由於未知原因，無法建立 WSA 連線';

  @override
  String get status_connected => '已連接';

  @override
  String get status_connected_desc =>
      'Successfully connected to WSA. All systems are operational and ready.';

  @override
  String get screen_wsa => 'WSA 包管理器';

  @override
  String get screen_settings => '設定';

  @override
  String get wsa_manage => 'Android 管理';

  @override
  String get wsa_manage_app => 'Manage Applications';

  @override
  String get wsa_manage_settings => 'Manage Settings';

  @override
  String get settings_port => 'WSA 端口';

  @override
  String get settings_ip => 'WSA 的 IP 位址';

  @override
  String get settings_autostart => '在安裝之前自動啟動 WSA';

  @override
  String settings_timeout(String seconds) {
    return '逾時 ($seconds 秒)';
  }

  @override
  String get settings_language => '語言';

  @override
  String get settings_option_generic_system => '系統';

  @override
  String get settings_option_generic_disabled => 'Disabled';

  @override
  String get theme_mode => '主題模式';

  @override
  String get theme_mode_dark => '深色模式';

  @override
  String get theme_mode_light => '淺色模式';

  @override
  String get theme_mica => 'Mica Effect (Window Transparency)';

  @override
  String get theme_mica_full => 'Full';

  @override
  String get theme_mica_partial => 'Partial';

  @override
  String get theme_icon_adaptive => '自適應圖標形狀';

  @override
  String get theme_icon_adaptive_squircle => 'Squircle (Rounded Corner)';

  @override
  String get theme_icon_adaptive_circle => '圓形';

  @override
  String get theme_icon_adaptive_rounded_square => 'Rounded Square';

  @override
  String get installer_message => '您要安裝此應用程式嗎？';

  @override
  String installer_info_version(String appVersion) {
    return '版本：$appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return '版本：$appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return '包名：$appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return '正在安裝 $appTitle 應用程式...';
  }

  @override
  String installer_installed(String appTitle) {
    return '應用程式 $appTitle 已成功安裝';
  }

  @override
  String installer_fail(String appTitle) {
    return '應用程式 $appTitle 未安裝';
  }

  @override
  String get installer_error_nomsg => '安裝失敗，但未拋出錯誤';

  @override
  String get installer_error_timeout => '安裝已超時，客戶端已停止等待，但可能仍在背景執行...';

  @override
  String installer_warning_dirty(String tempDir) {
    return '目錄『$tempDir』需要手動清理文件';
  }

  @override
  String get installer_btn_starting => 'Android 子系統啟動中...';

  @override
  String get installer_btn_loading => '應用程式加載中...';

  @override
  String get installer_btn_cancel => '取消';

  @override
  String get installer_btn_install => '安裝';

  @override
  String get installer_btn_reinstall => '重新安裝';

  @override
  String get installer_btn_update => '更新';

  @override
  String get installer_btn_downgrade => '降級（不安全）';

  @override
  String get installer_btn_dismiss => '完成';

  @override
  String get installer_btn_open => '開啟應用程式';

  @override
  String get installer_btn_checkbox_shortcut => '建立桌面快捷方式';

  @override
  String get android_permission_none => '不需要任何權限';

  @override
  String get android_permission_admin => '以管理員身份管理裝置';

  @override
  String get android_permission_admin_brick => '遠程停用或重設裝置';

  @override
  String get android_permission_admin_lock => '遠程鎖定裝置';

  @override
  String get android_permission_storage => '多媒體檔案';

  @override
  String get android_permission_microphone => '麥克風';

  @override
  String get android_permission_camera => '相機';

  @override
  String get android_permission_location => '位置';

  @override
  String get android_permission_phone => '電話';

  @override
  String get android_permission_call_log => '通訊記錄';

  @override
  String get android_permission_sms => '訊息';

  @override
  String get android_permission_contacts => '聯絡人';

  @override
  String get android_permission_calendar => '日曆';

  @override
  String get android_permission_activity_recognition => '體育活動';

  @override
  String get android_permission_sensors => '裝置傳感器';

  @override
  String get android_permission_sensors_body => '身體傳感器';

  @override
  String get android_permission_nearby_devices => '查找附近的裝置';

  @override
  String get screen_uninstall => '解除安裝';

  @override
  String get scan_system => '掃描系統';

  @override
  String get scanning => '正在掃描...';

  @override
  String get backup_registry => '備份註冊表';

  @override
  String get execute_cleanup => '執行清理';

  @override
  String get scanning_wsa_env => '深度掃描 WSA 環境...';

  @override
  String get click_scan_to_find_ghost_apps => '點擊「掃描系統」以查找殘留或隱藏的應用程式。';

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
