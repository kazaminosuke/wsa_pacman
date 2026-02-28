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
    return '$windowsVersion 检测到但未找到 WSA； 此应用程序依赖于 WSA，仅在 Windows 11 上正式支持';
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
  String get status_connected_desc => '成功连接到 WSA，所有系统正常运行';

  @override
  String get screen_wsa => 'WSA 包管理器';

  @override
  String get screen_settings => '设置';

  @override
  String get wsa_manage => 'Android 管理';

  @override
  String get wsa_manage_app => '管理应用程序';

  @override
  String get wsa_manage_settings => '管理设置';

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
  String get settings_option_generic_disabled => '已禁用';

  @override
  String get theme_mode => '主题模式';

  @override
  String get theme_mode_dark => '深色模式';

  @override
  String get theme_mode_light => '浅色模式';

  @override
  String get theme_mica => '窗口透明度';

  @override
  String get theme_mica_full => '完整';

  @override
  String get theme_mica_partial => '部分';

  @override
  String get theme_icon_adaptive => '自适应图标形状';

  @override
  String get theme_icon_adaptive_squircle => '超圆角圆形';

  @override
  String get theme_icon_adaptive_circle => '圆形';

  @override
  String get theme_icon_adaptive_rounded_square => '圆角方形';

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
    return '檢測到 $windowsVersion 但未找到 Android 子系統；此應用程式僅在 Windows 11 正式支援。';
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
  String get status_connected_desc => '成功連接到 WSA，所有系統正常執行';

  @override
  String get screen_wsa => 'WSA 包管理器';

  @override
  String get screen_settings => '設定';

  @override
  String get wsa_manage => 'Android 管理';

  @override
  String get wsa_manage_app => '管理應用程式';

  @override
  String get wsa_manage_settings => '管理設定';

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
  String get settings_option_generic_disabled => '已關閉';

  @override
  String get theme_mode => '主題模式';

  @override
  String get theme_mode_dark => '深色模式';

  @override
  String get theme_mode_light => '淺色模式';

  @override
  String get theme_mica => '視窗透明度';

  @override
  String get theme_mica_full => '完整';

  @override
  String get theme_mica_partial => '部分';

  @override
  String get theme_icon_adaptive => '自適應圖標形狀';

  @override
  String get theme_icon_adaptive_squircle => '方圓形';

  @override
  String get theme_icon_adaptive_circle => '圓形';

  @override
  String get theme_icon_adaptive_rounded_square => '圓角方形';

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
}
