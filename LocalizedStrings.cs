using System.Reflection;
using System.Resources;
using WsaPacman.Models;

namespace WsaPacman;

public sealed class LocalizedStrings
{
    public static readonly LocalizedStrings Instance = new();

    private static readonly ResourceManager Rm = new(
        "WsaPacman.Resources.Resources", Assembly.GetExecutingAssembly());

    private static string Get(string key) => Rm.GetString(key) ?? key;

    /// <summary>サービス層がリソースキー文字列で返す文言（WsaStatusSnapshot等）を解決する。</summary>
    public string this[string key] => Get(key);

    // Screen titles
    public string screen_wsa => Get("screen_wsa");
    public string screen_settings => Get("screen_settings");
    public string screen_uninstall => Get("screen_uninstall");

    // WSA management labels
    public string wsa_manage => Get("wsa_manage");
    public string wsa_manage_app => Get("wsa_manage_app");
    public string wsa_manage_settings => Get("wsa_manage_settings");

    // Connection status titles
    public string status_missing => Get("status_missing");
    public string status_missing_desc => Get("status_missing_desc");
    public string status_unknown => Get("status_unknown");
    public string status_unknown_desc => Get("status_unknown_desc");
    public string status_starting => Get("status_starting");
    public string status_starting_desc => Get("status_starting_desc");
    public string status_arrested => Get("status_arrested");
    public string status_arrested_desc => Get("status_arrested_desc");
    public string status_offline => Get("status_offline");
    public string status_offline_desc => Get("status_offline_desc");
    public string status_disconnected => Get("status_disconnected");
    public string status_disconnected_desc => Get("status_disconnected_desc");
    public string status_connected => Get("status_connected");
    public string status_connected_desc => Get("status_connected_desc");
    public string status_unauthorized => Get("status_unauthorized");
    public string status_unauthorized_desc => Get("status_unauthorized_desc");
    public string status_unsupported => Get("status_unsupported");
    public string status_unsupported_desc => Get("status_unsupported_desc");

    // Buttons
    public string btn_wsabuilds => Get("btn_wsabuilds");
    public string btn_launch_wsa => Get("btn_launch_wsa");
    public string btn_restart_wsa => Get("btn_restart_wsa");
    public string btn_dev_settings => Get("btn_dev_settings");
    public string btn_refresh_status => Get("btn_refresh_status");
    public string btn_auth => Get("btn_auth");
    public string btn_switch_on => Get("btn_switch_on");
    public string btn_switch_off => Get("btn_switch_off");
    public string btn_apply => Get("btn_apply");
    public string btn_browse => Get("btn_browse");

    // Tooltips
    public string tooltip_refresh_status => Get("tooltip_refresh_status");
    public string tooltip_reset_desktop => Get("tooltip_reset_desktop");

    // Uninstall/App Manager
    public string scan_system => Get("scan_system");
    public string scanning => Get("scanning");
    public string backup_registry => Get("backup_registry");
    public string execute_cleanup => Get("execute_cleanup");
    public string click_scan_to_find_ghost_apps => Get("click_scan_to_find_ghost_apps");
    public string cleanup_complete => Get("cleanup_complete");
    public string backup_cancelled => Get("backup_cancelled");
    public string backup_success => Get("backup_success");
    public string auto_backup_registry => Get("auto_backup_registry");
    public string cleanup_success_desc(int count) =>
        Get("cleanup_success_desc").Replace("{count}", count.ToString());

    // Settings
    public string settings_port => Get("settings_port");
    public string settings_autostart => Get("settings_autostart");
    public string settings_language => Get("settings_language");
    public string settings_option_generic_system => Get("settings_option_generic_system");
    public string settings_option_generic_disabled => Get("settings_option_generic_disabled");
    public string settings_auto_backup_dir => Get("settings_auto_backup_dir");
    public string settings_theme_color => Get("settings_theme_color");
    public string settings_theme_color_system => Get("settings_theme_color_system");
    public string settings_theme_color_default => Get("settings_theme_color_default");
    public string settings_custom_color => Get("settings_custom_color");
    public string settings_timeout(string seconds) =>
        Get("settings_timeout").Replace("{seconds}", seconds);

    // Theme
    public string theme_mode => Get("theme_mode");
    public string theme_mode_dark => Get("theme_mode_dark");
    public string theme_mode_light => Get("theme_mode_light");
    public string theme_mica => Get("theme_mica");
    public string theme_mica_full => Get("theme_mica_full");
    public string theme_mica_partial => Get("theme_mica_partial");
    public string theme_icon_adaptive => Get("theme_icon_adaptive");
    public string theme_icon_adaptive_squircle => Get("theme_icon_adaptive_squircle");
    public string theme_icon_adaptive_circle => Get("theme_icon_adaptive_circle");
    public string theme_icon_adaptive_rounded_square => Get("theme_icon_adaptive_rounded_square");

    // Installer
    public string installer_message => Get("installer_message");
    public string installer_error_timeout => Get("installer_error_timeout");
    public string installer_error_nomsg => Get("installer_error_nomsg");
    public string installer_error_boot_timeout => Get("installer_error_boot_timeout");
    public string installer_btn_cancel => Get("installer_btn_cancel");
    public string installer_btn_install => Get("installer_btn_install");
    public string installer_btn_reinstall => Get("installer_btn_reinstall");
    public string installer_btn_update => Get("installer_btn_update");
    public string installer_btn_downgrade => Get("installer_btn_downgrade");
    public string installer_btn_dismiss => Get("installer_btn_dismiss");
    public string installer_btn_open => Get("installer_btn_open");
    public string installer_btn_starting => Get("installer_btn_starting");
    public string installer_btn_loading => Get("installer_btn_loading");
    public string installer_btn_checkbox_shortcut => Get("installer_btn_checkbox_shortcut");
    public string installer_info_version(string version) =>
        Get("installer_info_version").Replace("{appVersion}", version);
    public string installer_info_package(string pkg) =>
        Get("installer_info_package").Replace("{appPackage}", pkg);
    public string installer_installing(string title) =>
        Get("installer_installing").Replace("{appTitle}", title);
    public string installer_installed(string title) =>
        Get("installer_installed").Replace("{appTitle}", title);
    public string installer_fail(string title) =>
        Get("installer_fail").Replace("{appTitle}", title);

    // Android permissions (Installer permission list)
    public string android_permission_none => Get("android_permission_none");
    public string android_permission_admin_brick => Get("android_permission_admin_brick");
    public string android_permission_admin_lock => Get("android_permission_admin_lock");
    public string android_permission_admin => Get("android_permission_admin");
    public string android_permission_storage => Get("android_permission_storage");
    public string android_permission_microphone => Get("android_permission_microphone");
    public string android_permission_camera => Get("android_permission_camera");
    public string android_permission_location => Get("android_permission_location");
    public string android_permission_phone => Get("android_permission_phone");
    public string android_permission_call_log => Get("android_permission_call_log");
    public string android_permission_sms => Get("android_permission_sms");
    public string android_permission_contacts => Get("android_permission_contacts");
    public string android_permission_calendar => Get("android_permission_calendar");
    public string android_permission_activity_recognition => Get("android_permission_activity_recognition");
    public string android_permission_sensors_body => Get("android_permission_sensors_body");
    public string android_permission_sensors => Get("android_permission_sensors");
    public string android_permission_nearby_devices => Get("android_permission_nearby_devices");

    public string PermissionDescription(AndroidPermission permission) => permission switch
    {
        AndroidPermission.AdminBrick => android_permission_admin_brick,
        AndroidPermission.AdminLock => android_permission_admin_lock,
        AndroidPermission.Admin => android_permission_admin,
        AndroidPermission.Storage => android_permission_storage,
        AndroidPermission.Microphone => android_permission_microphone,
        AndroidPermission.Camera => android_permission_camera,
        AndroidPermission.Location => android_permission_location,
        AndroidPermission.Phone => android_permission_phone,
        AndroidPermission.CallLog => android_permission_call_log,
        AndroidPermission.Sms => android_permission_sms,
        AndroidPermission.Contacts => android_permission_contacts,
        AndroidPermission.Calendar => android_permission_calendar,
        AndroidPermission.ActivityRecognition => android_permission_activity_recognition,
        AndroidPermission.SensorsBody => android_permission_sensors_body,
        AndroidPermission.Sensors => android_permission_sensors,
        AndroidPermission.NearbyDevices => android_permission_nearby_devices,
        _ => android_permission_none,
    };

    // Uninstaller
    public string uninstaller_status_starting_wsa => Get("uninstaller_status_starting_wsa");
    public string uninstaller_status_success => Get("uninstaller_status_success");
    public string uninstaller_status_errors => Get("uninstaller_status_errors");
    public string uninstaller_btn_yes => Get("uninstaller_btn_yes");
    public string uninstaller_status_uninstalling(string name) =>
        Get("uninstaller_status_uninstalling").Replace("{appName}", name);
    public string uninstaller_status_error_msg(string error) =>
        Get("uninstaller_status_error_msg").Replace("{error}", error);
    public string uninstaller_confirm(string name) =>
        Get("uninstaller_confirm").Replace("{appName}", name);
}
