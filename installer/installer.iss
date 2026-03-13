; -- installer.iss --
; Generates an installer with Inno Setup.

#define tools_dir_name "embedded-tools"
#define releasedir "..\build\windows\x64\runner\Release\"
#define instbuilddir "..\build\installer"
#define toolsdir "..\"+tools_dir_name

#define vcredist_version "14.31.31103.00"

#define executable "WSA-pacman.exe"
#define app_name "WSA Package Manager"
#define dist_appname "WSA-pacman"
#define reg_appname "wsa-pacman"
#define reg_name_installer "Package installer"

; ★ 関連付ける拡張子を定義（mapk, apkm, apks を追加！）
#define reg_assoc_apk reg_appname + ".apk"
#define reg_assoc_xapk reg_appname + ".xapk"
#define reg_assoc_mapk reg_appname + ".mapk"
#define reg_assoc_apkm reg_appname + ".apkm"
#define reg_assoc_apks reg_appname + ".apks"

#define path_classes "SOFTWARE\Classes\"
#define path_assoc_user "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\"
#define path_assoc_default ".DEFAULT\"+path_assoc_user 

[Setup]
AppVersion=1.6.0
PrivilegesRequired=admin
AppName=WSA PacMan
AppPublisher=kazaminosuke
ArchitecturesInstallIn64BitMode=x64
WizardStyle=modern
DefaultDirName={autopf}\WSA PacMan
DefaultGroupName=WSA PacMan
UninstallDisplayIcon={app}\{#executable}
Compression=lzma2
SolidCompression=yes
ChangesAssociations=yes
ChangesEnvironment=yes
OutputBaseFilename={#dist_appname}-v{#SetupSetting("AppVersion")}-installer
OutputDir={#instbuilddir}

[Tasks]
; ★ インストール時の「関連付けチェックボックス」に追加
Name: fileassoc_apk; Description: "{cm:AssocFileExtension,{#app_name},.apk}";
Name: fileassoc_xapk; Description: "{cm:AssocFileExtension,{#app_name},.xapk}";
Name: fileassoc_mapk; Description: "{cm:AssocFileExtension,{#app_name},.mapk}";
Name: fileassoc_apkm; Description: "{cm:AssocFileExtension,{#app_name},.apkm}";
Name: fileassoc_apks; Description: "{cm:AssocFileExtension,{#app_name},.apks}";

[Registry]
Root: HKA; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: string; ValueName: "WSA_PACMAN_HOME"; ValueData: "{app}"; Flags: createvalueifdoesntexist preservestringtype uninsdeletevalue

; File association: apk
Root: HKA; Subkey: "{#path_classes}\.apk"; ValueData: "{#reg_assoc_apk}"; Flags: uninsdeletevalue; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\.apk\OpenWithProgids"; ValueType: string; ValueName: "{#reg_assoc_apk}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_apk}"; ValueData: "{#reg_name_installer}"; Flags: uninsdeletekey; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_apk}\DefaultIcon"; ValueData: "%WSA_PACMAN_HOME%\{#executable},0"; ValueType: expandsz;  ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_apk}\shell\open\command";  ValueData: """%WSA_PACMAN_HOME%\{#executable}"" ""%1""";  ValueType: expandsz; ValueName: ""
Root: HKU; Subkey: "{#path_assoc_default}\.apk\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_apk
Root: HKCU; Subkey: "{#path_assoc_user}\.apk\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_apk

; File association: xapk
Root: HKA; Subkey: "{#path_classes}\.xapk"; ValueData: "{#reg_assoc_xapk}"; Flags: uninsdeletevalue; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\.xapk\OpenWithProgids"; ValueType: string; ValueName: "{#reg_assoc_xapk}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_xapk}"; ValueData: "{#reg_name_installer}"; Flags: uninsdeletekey; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_xapk}\DefaultIcon"; ValueData: "%WSA_PACMAN_HOME%\{#executable},0"; ValueType: expandsz;  ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_xapk}\shell\open\command";  ValueData: """%WSA_PACMAN_HOME%\{#executable}"" ""%1""";  ValueType: expandsz;  ValueName: ""
Root: HKU; Subkey: "{#path_assoc_default}\.xapk\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_xapk
Root: HKCU; Subkey: "{#path_assoc_user}\.xapk\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_xapk

; ★ 追加: File association: mapk
Root: HKA; Subkey: "{#path_classes}\.mapk"; ValueData: "{#reg_assoc_mapk}"; Flags: uninsdeletevalue; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\.mapk\OpenWithProgids"; ValueType: string; ValueName: "{#reg_assoc_mapk}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_mapk}"; ValueData: "{#reg_name_installer}"; Flags: uninsdeletekey; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_mapk}\DefaultIcon"; ValueData: "%WSA_PACMAN_HOME%\{#executable},0"; ValueType: expandsz;  ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_mapk}\shell\open\command";  ValueData: """%WSA_PACMAN_HOME%\{#executable}"" ""%1""";  ValueType: expandsz;  ValueName: ""
Root: HKU; Subkey: "{#path_assoc_default}\.mapk\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_mapk
Root: HKCU; Subkey: "{#path_assoc_user}\.mapk\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_mapk

; ★ 追加: File association: apkm
Root: HKA; Subkey: "{#path_classes}\.apkm"; ValueData: "{#reg_assoc_apkm}"; Flags: uninsdeletevalue; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\.apkm\OpenWithProgids"; ValueType: string; ValueName: "{#reg_assoc_apkm}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_apkm}"; ValueData: "{#reg_name_installer}"; Flags: uninsdeletekey; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_apkm}\DefaultIcon"; ValueData: "%WSA_PACMAN_HOME%\{#executable},0"; ValueType: expandsz;  ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_apkm}\shell\open\command";  ValueData: """%WSA_PACMAN_HOME%\{#executable}"" ""%1""";  ValueType: expandsz;  ValueName: ""
Root: HKU; Subkey: "{#path_assoc_default}\.apkm\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_apkm
Root: HKCU; Subkey: "{#path_assoc_user}\.apkm\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_apkm

; ★ 追加: File association: apks
Root: HKA; Subkey: "{#path_classes}\.apks"; ValueData: "{#reg_assoc_apks}"; Flags: uninsdeletevalue; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\.apks\OpenWithProgids"; ValueType: string; ValueName: "{#reg_assoc_apks}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_apks}"; ValueData: "{#reg_name_installer}"; Flags: uninsdeletekey; ValueType: string; ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_apks}\DefaultIcon"; ValueData: "%WSA_PACMAN_HOME%\{#executable},0"; ValueType: expandsz;  ValueName: ""
Root: HKA; Subkey: "{#path_classes}\{#reg_assoc_apks}\shell\open\command";  ValueData: """%WSA_PACMAN_HOME%\{#executable}"" ""%1""";  ValueType: expandsz;  ValueName: ""
Root: HKU; Subkey: "{#path_assoc_default}\.apks\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_apks
Root: HKCU; Subkey: "{#path_assoc_user}\.apks\UserChoice"; ValueType: none; Flags: deletekey; Tasks: fileassoc_apks

[Files]
Source: "{#releasedir}\*"; Excludes: "\*.lib,\*.exp,\{#tools_dir_name}"; DestDir: "{app}"; Flags: recursesubdirs
Source: "{#toolsdir}\*"; DestDir: "{app}\{#tools_dir_name}"; Flags: recursesubdirs
Source: ".\redist\VC_redist.x64.exe"; DestDir: {tmp}; Flags: dontcopy

[Run]
Filename: "{tmp}\VC_redist.x64.exe"; StatusMsg: "Installing Visual C++ Redistributable..."; \
  Parameters: "/quiet /norestart /install"; Check: ShouldInstallVCRedist; Flags: waituntilterminated

; ★ 追加: PACMANインストール完了後にバックグラウンドで既存WSAアプリの同期を実行する
Filename: "{app}\{#executable}"; Parameters: "--sync"; Flags: runhidden nowait;

[Icons]
; {group} を {autoprograms} に変更することで、スタートメニュー直下に配置されます！
Name: "{autoprograms}\WSA PacMan"; Filename: "{app}\{#executable}"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\*"
Type: dirifempty; Name: "{app}"

[UninstallRun]
; ※PACMAN本体にレジストリを元に戻す処理（例: --unsync）が実装されている場合
Filename: "{app}\{#executable}"; Parameters: "--unsync"; Flags: runhidden waituntilterminated;

[Code]
function ShouldInstallVCRedist: Boolean;
var 
  Version: String;
begin
  if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64', 'Version', Version) then
  begin 
    Log('VC Redist Version check : found ' + Version);
    //Check if the installed version is lower than the version included in the installer
    Result := (CompareStr(Version, 'v{#vcredist_version}')<0);
  end
  else 
  begin
    // Not even an old version installed
    Result := True;
  end;
  if (Result) then
  begin
    ExtractTemporaryFile('VC_redist.x64.exe');
  end;
end;