// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get locale_desc => '日本語';

  @override
  String get locale_system => 'システム';

  @override
  String get btn_boot => 'オンにする';

  @override
  String get btn_auth => '再認証';

  @override
  String get btn_dev_settings => '開発者オプション';

  @override
  String get btn_switch_on => 'オン';

  @override
  String get btn_switch_off => 'オフ';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => '古い Windows のバージョン';

  @override
  String get status_unsupported => 'WSA がインストールされていません。';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion を使用しています。Windows にWSA がインストールされていません。このアプリケーションを使用するには WSA が必要で、Windows 11 のみ正式にサポートされています。';
  }

  @override
  String get status_unauthorized => '未認証';

  @override
  String get status_unauthorized_desc =>
      'デバッグ認証は拒否されたか、取り消されました。最初のボタンを押し、「常に許可」を選択し、「許可」をクリックしてください。ポップアップが表示されない場合は、開発者オプションを開き、「USBデバッグ」を無効にして再度有効にしてください。';

  @override
  String get status_missing => 'WSA がインストールされていません。';

  @override
  String get status_missing_desc =>
      'WSAがシステムに見つかりません。\nMicrosoft公式のWSAは提供が終了したため、有志による『WSABuilds』からの導入をおすすめします。';

  @override
  String get btn_wsabuilds => 'WSABuilds を開く (GitHub)';

  @override
  String get status_unknown => '接続中';

  @override
  String get status_unknown_desc => 'WSA との接続が確立されるのを待っています...';

  @override
  String get status_starting => '起動中';

  @override
  String get status_starting_desc => 'WSA が起動しています。しばらくお待ちください...';

  @override
  String get status_arrested => '停止中';

  @override
  String get status_arrested_desc => 'WSA が停止しています。';

  @override
  String get status_offline => 'オフライン';

  @override
  String get status_offline_desc =>
      'WSA との接続を確立できませんでした: 開発者モードや USB デバッグが無効になっているか、間違ったポートが指定されている可能性があります。';

  @override
  String get status_disconnected => '切断';

  @override
  String get status_disconnected_desc => 'WSA との接続が不明な理由で確立できませんでした。';

  @override
  String get status_connected => '接続完了';

  @override
  String get status_connected_desc => 'WSA との接続ができました。現在、待機中です。';

  @override
  String get screen_wsa => 'WSA Package Manager';

  @override
  String get screen_settings => '設定';

  @override
  String get wsa_manage => 'Android の管理';

  @override
  String get wsa_manage_app => 'WSA のアプリケーション設定を開く';

  @override
  String get wsa_manage_settings => 'WSA の設定を開く';

  @override
  String get settings_port => 'WSA ポート';

  @override
  String get settings_ip => 'WSA IP アドレス';

  @override
  String get settings_autostart => 'インストール前に WSA を自動起動する';

  @override
  String settings_timeout(String seconds) {
    return 'タイムアウト ($seconds 秒)';
  }

  @override
  String get settings_language => '言語';

  @override
  String get settings_option_generic_system => 'システム';

  @override
  String get settings_option_generic_disabled => '非アクティブ';

  @override
  String get theme_mode => 'テーマモード';

  @override
  String get theme_mode_dark => 'ダーク';

  @override
  String get theme_mode_light => 'ライト';

  @override
  String get theme_mica => 'ウィンドウの透明度';

  @override
  String get theme_mica_full => '全体';

  @override
  String get theme_mica_partial => '一部';

  @override
  String get theme_icon_adaptive => 'アダプティブアイコンのスタイル';

  @override
  String get theme_icon_adaptive_squircle => '半円';

  @override
  String get theme_icon_adaptive_circle => '円';

  @override
  String get theme_icon_adaptive_rounded_square => '丸み正方形';

  @override
  String get installer_message => 'このアプリケーションをインストールしますか?';

  @override
  String installer_info_version(String appVersion) {
    return 'バージョン: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'バージョン: $appVersionOld ⇒ $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'パッケージ: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'アプリ「$appTitle」をインストールしています...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'アプリ「$appTitle」がインストールされました。';
  }

  @override
  String installer_fail(String appTitle) {
    return 'アプリ「$appTitle」をインストールできませんでした。';
  }

  @override
  String get installer_error_nomsg => 'インストールに失敗しました。';

  @override
  String get installer_error_timeout =>
      'インストールがタイムアウトしました。クライアントはもう待っていませんが、バックグラウンドではまだ実行されている可能性があります...';

  @override
  String installer_warning_dirty(String tempDir) {
    return '「$tempDir」ディレクトリでの手動ファイルクリーンアップが必要です';
  }

  @override
  String get installer_btn_starting => '起動中です...';

  @override
  String get installer_btn_loading => '読み込んでいます...';

  @override
  String get installer_btn_cancel => 'キャンセル';

  @override
  String get installer_btn_install => 'インストール';

  @override
  String get installer_btn_reinstall => '再インストール';

  @override
  String get installer_btn_update => 'アップデート';

  @override
  String get installer_btn_downgrade => 'ダウングレード(非推奨)';

  @override
  String get installer_btn_dismiss => '閉じる';

  @override
  String get installer_btn_open => 'アプリを開く';

  @override
  String get installer_btn_checkbox_shortcut => 'デスクトップにショートカットを作成する';

  @override
  String get android_permission_none => '権限は必要ありません';

  @override
  String get android_permission_admin => '管理者としてデバイスを管理';

  @override
  String get android_permission_admin_brick => 'デバイスをリモートで無効にする';

  @override
  String get android_permission_admin_lock => 'デバイスをリモートでロックする';

  @override
  String get android_permission_storage => 'ファイルとメディア';

  @override
  String get android_permission_microphone => 'マイク';

  @override
  String get android_permission_camera => 'カメラ';

  @override
  String get android_permission_location => '位置情報';

  @override
  String get android_permission_phone => '電話';

  @override
  String get android_permission_call_log => '通話ログ';

  @override
  String get android_permission_sms => 'メッセージ';

  @override
  String get android_permission_contacts => '連絡先';

  @override
  String get android_permission_calendar => 'カレンダー';

  @override
  String get android_permission_activity_recognition => '身体活動';

  @override
  String get android_permission_sensors => 'デバイスセンサー';

  @override
  String get android_permission_sensors_body => 'ボディセンサー';

  @override
  String get android_permission_nearby_devices => '近くのデバイスを探す';
}
