// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get locale_desc => 'Bahasa Indonesia';

  @override
  String get locale_system => 'Sistem';

  @override
  String get btn_boot => 'Nyalakan';

  @override
  String get btn_auth => 'Otentikasi ulang';

  @override
  String get btn_dev_settings => 'Opsi pengembang';

  @override
  String get btn_switch_on => 'Nyala';

  @override
  String get btn_switch_off => 'Mati';

  @override
  String get status_subtext_winver_10 => 'Windows 10';

  @override
  String get status_subtext_winver_older => 'Versi Lama Windows';

  @override
  String get status_unsupported => 'WSA belum terinstal';

  @override
  String status_unsupported_desc(String windowsVersion) {
    return '$windowsVersion terdeteksi dan WSA tidak ditemukan; aplikasi ini tergantung pada WSA, yang hanya didukung secara resmi di Windows 11';
  }

  @override
  String get status_unauthorized => 'Tidak sah';

  @override
  String get status_unauthorized_desc =>
      'Otorisasi debugging ditolak atau dicabut; tekan tombol pertama, pilih \'selalu izinkan\' lalu klik \'izinkan\'; Jika tidak muncul pop-up, buka opsi pengembang dan nonaktifkan dan aktifkan kembali \'debugging USB\'';

  @override
  String get status_missing => 'WSA tidak ditemukan';

  @override
  String get status_missing_desc =>
      'WSA tidak ditemukan; aplikasi ini bergantung pada WSA, silakan instal Subsistem Windows untuk Android (atau Amazon Appstore) dari Microsoft Store';

  @override
  String get status_unknown => 'Menghubungkan';

  @override
  String get status_unknown_desc => 'Menunggu koneksi WSA dibuat...';

  @override
  String get status_starting => 'Memulai';

  @override
  String get status_starting_desc => 'WSA dimulai, harap bersiap-siap...';

  @override
  String get status_arrested => 'Ditangkap';

  @override
  String get status_arrested_desc => 'WSA dimatikan';

  @override
  String get status_offline => 'Luring';

  @override
  String get status_offline_desc =>
      'Tidak dapat membuat koneksi dengan WSA: mode pengembang dan debugging USB dinonaktifkan atau port yang salah ditentukan';

  @override
  String get status_disconnected => 'Terputus';

  @override
  String get status_disconnected_desc =>
      'Koneksi WSA tidak dapat dibuat karena alasan yang tidak diketahui';

  @override
  String get status_connected => 'Terhubung';

  @override
  String get status_connected_desc =>
      'Berhasil terhubung ke WSA, semua sistem berjalan';

  @override
  String get screen_wsa => 'Manajer Paket WSA';

  @override
  String get screen_settings => 'Pengaturan';

  @override
  String get wsa_manage => 'Manajemen Android';

  @override
  String get wsa_manage_app => 'Kelola Aplikasi';

  @override
  String get wsa_manage_settings => 'Kelola Pengaturan';

  @override
  String get settings_port => 'Port WSA';

  @override
  String get settings_ip => 'Alamat IP WSA';

  @override
  String get settings_autostart => 'Otomatis mulai WSA sebelum instalasi';

  @override
  String settings_timeout(String seconds) {
    return 'Batas waktu ($seconds detik)';
  }

  @override
  String get settings_language => 'Bahasa';

  @override
  String get settings_option_generic_system => 'Sistem';

  @override
  String get settings_option_generic_disabled => 'Dimatikan';

  @override
  String get theme_mode => 'Mode tema';

  @override
  String get theme_mode_dark => 'Gelap';

  @override
  String get theme_mode_light => 'Terang';

  @override
  String get theme_mica => 'Transparan Windows';

  @override
  String get theme_mica_full => 'Penuh';

  @override
  String get theme_mica_partial => 'Sebagian';

  @override
  String get theme_icon_adaptive => 'Ikon adaptif Bentuk';

  @override
  String get theme_icon_adaptive_squircle => 'Kerucut';

  @override
  String get theme_icon_adaptive_circle => 'Lingkaran';

  @override
  String get theme_icon_adaptive_rounded_square => 'Persegi Bulat';

  @override
  String get installer_message => 'Apakah Anda ingin menginstal aplikasi ini?';

  @override
  String installer_info_version(String appVersion) {
    return 'Versi: $appVersion';
  }

  @override
  String installer_info_version_change(
      String appVersionOld, String appVersionNew) {
    return 'Versi: $appVersionOld => $appVersionNew';
  }

  @override
  String installer_info_package(String appPackage) {
    return 'Paket: $appPackage';
  }

  @override
  String installer_installing(String appTitle) {
    return 'Menginstal aplikasi $appTitle...';
  }

  @override
  String installer_installed(String appTitle) {
    return 'Aplikasi $appTitle berhasil diinstal';
  }

  @override
  String installer_fail(String appTitle) {
    return 'Aplikasi $appTitle tidak dipasang';
  }

  @override
  String get installer_error_nomsg =>
      'Instalasi telah gagal, tetapi tidak ada kesalahan yang terjadi';

  @override
  String get installer_error_timeout =>
      'Pemasangan kehabisan waktu, klien sudah tidak menunggu lagi, tapi masih mungkin berjalan di latar belakang...';

  @override
  String installer_warning_dirty(String tempDir) {
    return 'Dibutuhkan pembersihan file manual di direktori “$tempDir”';
  }

  @override
  String get installer_btn_starting => 'Memulai...';

  @override
  String get installer_btn_loading => 'Memuat...';

  @override
  String get installer_btn_cancel => 'Batal';

  @override
  String get installer_btn_install => 'Instal';

  @override
  String get installer_btn_reinstall => 'Instal ulang';

  @override
  String get installer_btn_update => 'Perbarui';

  @override
  String get installer_btn_downgrade => 'Turunkan versi (tidak aman)';

  @override
  String get installer_btn_dismiss => 'Memberhentikan';

  @override
  String get installer_btn_open => 'Buka aplikasi';

  @override
  String get installer_btn_checkbox_shortcut => 'Buat pintasan desktop';

  @override
  String get android_permission_none => 'Tidak diperlukan izin';

  @override
  String get android_permission_admin => 'Atur perangkat sebagai administrator';

  @override
  String get android_permission_admin_brick =>
      'Nonaktifkan atau setel ulang perangkat dari jarak jauh';

  @override
  String get android_permission_admin_lock =>
      'Mengunci perangkat dari jarak jauh';

  @override
  String get android_permission_storage => 'File dan media';

  @override
  String get android_permission_microphone => 'Mikropon';

  @override
  String get android_permission_camera => 'Kamera';

  @override
  String get android_permission_location => 'Lokasi';

  @override
  String get android_permission_phone => 'Telepon';

  @override
  String get android_permission_call_log => 'Log panggilan';

  @override
  String get android_permission_sms => 'Pesan';

  @override
  String get android_permission_contacts => 'Kontak';

  @override
  String get android_permission_calendar => 'Kalender';

  @override
  String get android_permission_activity_recognition => 'Aktivitas fisik';

  @override
  String get android_permission_sensors => 'Sensor perangkat';

  @override
  String get android_permission_sensors_body => 'Sensor tubuh';

  @override
  String get android_permission_nearby_devices => 'Temukan perangkat terdekat';
}
