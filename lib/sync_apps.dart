import 'dart:io';

Future<void> runSyncApps() async {
  // WsaClient.exe のパスが含まれるか、LocalState フォルダのアプリアイコンを持つレジストリエントリを検索
  const script = '''
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8;
\$apps = Get-ItemProperty "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*" -ErrorAction SilentlyContinue |
        Where-Object { 
          (\$_.UninstallString -match "MicrosoftCorporationII\\.WindowsSubsystemForAndroid_8wekyb3d8bbwe\\\\WsaClient\\.exe") -or 
          (\$_.QuietUninstallString -match "MicrosoftCorporationII\\.WindowsSubsystemForAndroid_8wekyb3d8bbwe\\\\WsaClient\\.exe") -or 
          (\$_.ModifyPath -match "MicrosoftCorporationII\\.WindowsSubsystemForAndroid_8wekyb3d8bbwe\\\\WsaClient\\.exe") -or
          (\$_.DisplayIcon -match "MicrosoftCorporationII\\.WindowsSubsystemForAndroid_8wekyb3d8bbwe\\\\LocalState")
        } |
        Select-Object PSChildName

if (\$apps) {
    # If there is only one result, PS returns an object instead of array, so we ensure an array
    @(\$apps) | ForEach-Object { \$_.PSChildName }
}
''';

  try {
    final process =
        await Process.run('powershell', ['-NoProfile', '-Command', script]);
    if (process.exitCode == 0 && process.stdout.toString().trim().isNotEmpty) {
      final lines = process.stdout.toString().split('\n');
      final execPath = Platform.resolvedExecutable;

      for (String line in lines) {
        final package = line.trim();
        if (package.isNotEmpty) {
          // write the UninstallString to this package
          await Process.run(
            'reg',
            [
              'add',
              'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\$package',
              '/v',
              'UninstallString',
              '/t',
              'REG_SZ',
              '/d',
              '"$execPath" --uninstall $package',
              '/f'
            ],
            runInShell: true,
          );

          await Process.run(
            'reg',
            [
              'add',
              'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\$package',
              '/v',
              'QuietUninstallString',
              '/t',
              'REG_SZ',
              '/d',
              '"$execPath" --uninstall $package',
              '/f'
            ],
            runInShell: true,
          );
        }
      }
    }
  } catch (e) {
    // Ignore error silently in sync mode
  }
}
