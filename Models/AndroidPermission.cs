namespace WsaPacman.Models;

/// <summary>権限のグループ分け（Flutter版 permissions.dart の AndroidPermission enum 踏襲）。</summary>
public enum AndroidPermission
{
    None,
    AdminBrick,
    AdminLock,
    Admin,
    Storage,
    Microphone,
    Camera,
    Location,
    Phone,
    CallLog,
    Sms,
    Contacts,
    Calendar,
    ActivityRecognition,
    SensorsBody,
    Sensors,
    NearbyDevices,
}

/// <summary>Android権限名 → グループの対応表（permissions.dart の _permissions マップ踏襲）。</summary>
public static class AndroidPermissionMap
{
    public static IReadOnlyList<AndroidPermission> FromNames(IEnumerable<string> names)
    {
        var found = new HashSet<AndroidPermission>();
        foreach (var name in names)
        {
            if (Map.TryGetValue(name, out var permission)) found.Add(permission);
        }
        if (found.Count == 0) found.Add(AndroidPermission.None);
        return found.OrderBy(p => (int)p).ToList();
    }

    private static readonly Dictionary<string, AndroidPermission> Map = new()
    {
        ["android.permission.BRICK"] = AndroidPermission.AdminBrick,
        ["android.permission.LOCK_DEVICE"] = AndroidPermission.AdminLock,
        ["android.permission.BIND_DEVICE_ADMIN"] = AndroidPermission.Admin,
        ["android.permission.MANAGE_DEVICE_ADMINS"] = AndroidPermission.Admin,
        ["android.permission.RESET_PASSWORD"] = AndroidPermission.Admin,
        ["android.permission.READ_CONTACTS"] = AndroidPermission.Contacts,
        ["android.permission.WRITE_CONTACTS"] = AndroidPermission.Contacts,
        ["android.permission.READ_CALENDAR"] = AndroidPermission.Calendar,
        ["android.permission.WRITE_CALENDAR"] = AndroidPermission.Calendar,
        ["android.permission.ACCESS_MESSAGES_ON_ICC"] = AndroidPermission.Sms,
        ["android.permission.SEND_SMS"] = AndroidPermission.Sms,
        ["android.permission.RECEIVE_SMS"] = AndroidPermission.Sms,
        ["android.permission.READ_SMS"] = AndroidPermission.Sms,
        ["android.permission.RECEIVE_WAP_PUSH"] = AndroidPermission.Sms,
        ["android.permission.RECEIVE_MMS"] = AndroidPermission.Sms,
        ["android.permission.BIND_CELL_BROADCAST_SERVICE"] = AndroidPermission.Sms,
        ["android.permission.READ_CELL_BROADCASTS"] = AndroidPermission.Sms,
        ["android.permission.WRITE_SMS"] = AndroidPermission.Sms,
        ["android.permission.SEND_RESPOND_VIA_MESSAGE"] = AndroidPermission.Sms,
        ["android.permission.SEND_SMS_NO_CONFIRMATION"] = AndroidPermission.Sms,
        ["android.permission.CARRIER_FILTER_SMS"] = AndroidPermission.Sms,
        ["android.permission.RECEIVE_EMERGENCY_BROADCAST"] = AndroidPermission.Sms,
        ["android.permission.MODIFY_CELL_BROADCASTS"] = AndroidPermission.Sms,
        ["android.permission.READ_EXTERNAL_STORAGE"] = AndroidPermission.Storage,
        ["android.permission.WRITE_EXTERNAL_STORAGE"] = AndroidPermission.Storage,
        ["android.permission.ACCESS_MEDIA_LOCATION"] = AndroidPermission.Storage,
        ["android.permission.WRITE_OBB"] = AndroidPermission.Storage,
        ["android.permission.MANAGE_EXTERNAL_STORAGE"] = AndroidPermission.Storage,
        ["android.permission.MANAGE_MEDIA"] = AndroidPermission.Storage,
        ["android.permission.WRITE_MEDIA_STORAGE"] = AndroidPermission.Storage,
        ["android.permission.MANAGE_DOCUMENTS"] = AndroidPermission.Storage,
        ["android.permission.ACCESS_FINE_LOCATION"] = AndroidPermission.Location,
        ["android.permission.ACCESS_COARSE_LOCATION"] = AndroidPermission.Location,
        ["android.permission.ACCESS_BACKGROUND_LOCATION"] = AndroidPermission.Location,
        ["android.permission.ACCESS_LOCATION_EXTRA_COMMANDS"] = AndroidPermission.Location,
        ["android.permission.INSTALL_LOCATION_PROVIDER"] = AndroidPermission.Location,
        ["android.permission.INSTALL_LOCATION_TIME_ZONE_PROVIDER_SERVICE"] = AndroidPermission.Location,
        ["android.permission.BIND_TIME_ZONE_PROVIDER_SERVICE"] = AndroidPermission.Location,
        ["android.permission.LOCATION_HARDWARE"] = AndroidPermission.Location,
        ["android.permission.ACCESS_IMS_CALL_SERVICE"] = AndroidPermission.CallLog,
        ["android.permission.PERFORM_IMS_SINGLE_REGISTRATION"] = AndroidPermission.CallLog,
        ["android.permission.READ_CALL_LOG"] = AndroidPermission.CallLog,
        ["android.permission.WRITE_CALL_LOG"] = AndroidPermission.CallLog,
        ["android.permission.PROCESS_OUTGOING_CALLS"] = AndroidPermission.CallLog,
        ["android.permission.READ_PHONE_STATE"] = AndroidPermission.Phone,
        ["android.permission.READ_PHONE_NUMBERS"] = AndroidPermission.Phone,
        ["android.permission.CALL_PHONE"] = AndroidPermission.Phone,
        ["com.android.voicemail.permission.ADD_VOICEMAIL"] = AndroidPermission.Phone,
        ["android.permission.USE_SIP"] = AndroidPermission.Phone,
        ["android.permission.ANSWER_PHONE_CALLS"] = AndroidPermission.Phone,
        ["android.permission.MANAGE_OWN_CALLS"] = AndroidPermission.Phone,
        ["android.permission.CALL_COMPANION_APP"] = AndroidPermission.Phone,
        ["android.permission.EXEMPT_FROM_AUDIO_RECORD_RESTRICTIONS"] = AndroidPermission.Phone,
        ["android.permission.ACCEPT_HANDOVER"] = AndroidPermission.Phone,
        ["com.android.voicemail.permission.WRITE_VOICEMAIL"] = AndroidPermission.Phone,
        ["com.android.voicemail.permission.READ_VOICEMAIL"] = AndroidPermission.Phone,
        ["android.permission.RECORD_AUDIO"] = AndroidPermission.Microphone,
        ["android.permission.RECORD_BACKGROUND_AUDIO"] = AndroidPermission.Microphone,
        ["android.permission.ACTIVITY_RECOGNITION"] = AndroidPermission.ActivityRecognition,
        ["android.permission.CAMERA"] = AndroidPermission.Camera,
        ["android.permission.BACKGROUND_CAMERA"] = AndroidPermission.Camera,
        ["android.permission.SYSTEM_CAMERA"] = AndroidPermission.Camera,
        ["android.permission.CAMERA_OPEN_CLOSE_LISTENER"] = AndroidPermission.Camera,
        ["android.permission.HIGH_SAMPLING_RATE_SENSORS"] = AndroidPermission.Sensors,
        ["android.permission.BODY_SENSORS"] = AndroidPermission.SensorsBody,
        ["android.permission.USE_FINGERPRINT"] = AndroidPermission.Sensors,
        ["android.permission.USE_BIOMETRIC"] = AndroidPermission.Sensors,
    };
}
