# wsa_pacman

**⚠️ 重要なお知らせ:** MicrosoftによるWindows Subsystem for Android (WSA) の公式サポートは終了しました。現在は有志によるプロジェクト [WSABuilds](https://github.com/MustardChef/WSABuilds) への移行が強く推奨されています。WSA PacManはWSABuilds環境にも完全に対応しています。

![Installer](README/screenshots/installer.png?raw=true "Installer")

Windows Subsystem for Android (WSA) 用のGUIパッケージマネージャー兼インストーラーです。

現在、.apk、.xapk、.mapk、.apkm、.apks ファイルのダブルクリックによるGUIインストールに対応しています。アプリ情報（パッケージ名、アイコン、バージョン、権限）を表示し、通常のインストールに加えてアップグレードやダウングレードも可能です。

さらに、Androidの設定を開くボタンや、「アプリの管理」設定画面を開くボタンも備えており、そこからアプリのアンインストール、無効化、権限の許可/取り消しを行うことができます。

## 新機能
* **モダンアプリマネージャー:** ゴーストアプリ、レジストリの残骸、ADB上にのみ存在するパッケージを安全に検出し、完全に削除する「ディープクリーン」機能を搭載しました。
* **WSABuildsへの統合案内:** 開発が終了した公式WSAがシステムに検出されない場合、有志による「WSABuilds」リポジトリへ自動的に案内します。
* **カスタムテーマカラー:** スライダーを使って好きなアクセントカラーを選択でき、次回起動時にもその色が完全に復元されます。

## 設定項目
* WSAの自動起動 (オン/オフ)
* Androidのポート (デフォルト: 58526)
* 言語 (全オプション対応)
* テーマモード (システム、ダーク、ライト)
* ウィンドウの透明度 / Mica (フル、一部、無効)
* アダプティブアイコンの形状 (Squircle、円形、角丸四角形、無効)
* カスタムアクセントカラー (ローカルに保存)

<details><summary><ruby><p></ruby>

## よくある質問 (FAQ)
</p></summary>

  **Q:** WSA PacManが常にオフライン状態になっています。なぜですか？

  **A:** まず大前提として、WSAがインストールされていることを確認してください。「Windows Subsystem for Android&#8482; 設定」アプリを開き、開発者タブで「開発者モード」のスイッチがオンになっていることを確認します。さらに開発者向け設定の管理から「USBデバッグ」オプションが有効になっているか確認してください。

  これらを試しても解決しない場合は、[こちらのリンクの手順](https://github.com/alesimula/wsa_pacman/issues/99#issuecomment-1288141314)を試し、「常に許可する」オプションにチェックを入れてください。
  ##
  
  **Q:** 古いバージョンのWindows（Windows 10など）でもWSA PacManを使えますか？

  **A:** WSAは公式にはWindows 11のみのサポートであり、過去のWindows 10向け移植プロジェクトはすでに開発が終了しています。
  しかし現在、有志による **[WSABuilds](https://github.com/MustardChef/WSABuilds)** プロジェクトがWindows 10向けのビルドも提供しています。そちらのWindows 10版をインストールすれば、WSA PacManも問題なく利用可能です。
  ##

  **Q:** Playストアはインストールできますか？

  **A:** PlayストアはWSAで公式にはサポートされておらず、現在のところ非公式のWSAビルドを使用した場合のみインストール可能です。非公式のPlayストアクライアントである[Aurora Store](https://auroraoss.com/)のインストールをおすすめしますが、どうしてもPlayストアやその他のGoogleアプリが必要な場合は、[こちらのプロジェクト](https://github.com/LSPosed/MagiskOnWSALocal)を確認してください。（注: WSABuildsを利用すれば、Google Playサポートが統合されたWSAを簡単に導入できます）。

</details>

<details><summary><ruby><p></ruby>
  
## その他のスクリーンショット
  </p></summary>

  ![Installing](README/screenshots/installing.png?raw=true "Installing")
  ![Installed](README/screenshots/installed.png?raw=true "Installed")
  ![Downgrade](README/screenshots/downgrade.png?raw=true "Downgrade")
  ![Main screen](README/screenshots/main_screen.png?raw=true "Main screen")
  ![Settings](README/screenshots/settings_screen.png?raw=true "Settings")
</details>