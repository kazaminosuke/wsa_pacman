# wsa_pacman

**⚠️ Important Notice:** Microsoft has officially ended support for the Windows Subsystem for Android (WSA). It is highly recommended to transition to the community-driven [WSABuilds](https://github.com/MustardChef/WSABuilds) project. WSA PacMan fully supports and integrates with WSABuilds.

![Installer](README/screenshots/installer.png?raw=true "Installer")

A GUI package manager and package installer for Windows Subsystem for Android (WSA).

Currently provides a double-click GUI installer for .apk, .xapk, .mapk, .apkm, and .apks files that shows app information (package, icon, version and permissions), allows normal installations as well as upgrades and downgrades.

The app additionally provides a button to open Android settings and one to open the "Manage Applications" Android settings page, from which you can uninstall or disable applications and grant or revoke permissions.

## New Features
* **Modern App Manager:** A new Deep Clean feature to safely detect and completely remove ghost apps, registry remnants, and ADB-only packages.
* **WSABuilds Integration:** Automatically guides you to the community-driven WSABuilds repository if the discontinued official WSA is not detected on your system.
* **Custom Theme Colors:** Pick any accent color you like using a slider, and the app will remember your choice perfectly on the next startup.

## Settings
* Autostart WSA (on/off)
* Android port (Default: 58526)
* Language (All options)
* Theme mode (System, Dark, Light)
* Window transparency / mica (Full, Partial, Disabled)
* Adaptive icon shape (Squircle, Circle, Rounded square, Disabled)
* Custom Accent Color (Saved locally)

<details><summary><ruby><p></ruby>

## FAQ 
</p></summary>

  **Q:** WSA PacMan is always showing the Offline status, why is that?

  **A:** First things first make sure WSA is installed (duh); Open the 'Windows Subsystem for Android&#8482; Settings' app, in the Developer tab and make sure the 'Developer mode' switch is enabled; inside manage developer settings, make sure the 'USB debugging' option is enabled.

  Should all of the above fail, [try following this procedure](https://github.com/alesimula/wsa_pacman/issues/99#issuecomment-1288141314); make sure to check the 'always allow' option.
  ##
  
  **Q:** Can I use WSA PacMan on older versions of Windows (eg. Windows 10)?

  **A:** WSA was only ***officially*** supported on Windows 11, and older Windows 10 porting projects have been discontinued.
  However, the active community-driven **[WSABuilds](https://github.com/MustardChef/WSABuilds)** project now provides dedicated builds for Windows 10. Simply install their Windows 10 version, and WSA PacMan will work perfectly alongside it.
  ##

  **Q:** Can i install the Play Store?

  **A:** The play store is not _officially_ supported on WSA, and at the moment it is only possible to install it using an unofficial WSA build. I recommend installing the [Aurora Store](https://auroraoss.com/) instead, which is an unofficial Play Store client; but if you really want the Play Store and other Google apps, [check out this project](https://github.com/LSPosed/MagiskOnWSALocal). (Note: You can easily get integrated Google Play support by using WSABuilds).

</details>

<details><summary><ruby><p></ruby>
  
## More screenshots
  </p></summary>

  ![Installing](README/screenshots/installing.png?raw=true "Installing")
  ![Installed](README/screenshots/installed.png?raw=true "Installed")
  ![Downgrade](README/screenshots/downgrade.png?raw=true "Downgrade")
  ![Main screen](README/screenshots/main_screen.png?raw=true "Main screen")
  ![Settings](README/screenshots/settings_screen.png?raw=true "Settings")
</details>