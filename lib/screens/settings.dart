// ignore_for_file: curly_braces_in_flow_control_structures, constant_identifier_names, non_constant_identifier_names, deprecated_member_use, avoid_print, unused_local_variable
// lib/screens/settings.dart の一番上付近
import 'dart:io'; // ★これを追加

import 'dart:async';
import 'dart:developer';

import 'package:jovial_svg/jovial_svg.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as fsi;
import 'package:protobuf/protobuf.dart';
import 'package:wsa_pacman/global_state.dart';
import 'package:wsa_pacman/utils/env.dart';
import 'package:wsa_pacman/proto/options.pb.dart';
import 'package:wsa_pacman/utils/locale_utils.dart';
import 'package:wsa_pacman/widget/adaptive_icon.dart';
import 'package:wsa_pacman/widget/fluent_card.dart';
import 'package:wsa_pacman/widget/fluent_combo_box.dart';
import 'package:wsa_pacman/widget/fluent_expander.dart';
import 'package:wsa_pacman/widget/fluent_text_box.dart';
import 'package:wsa_pacman/widget/smooth_list_view.dart';
import 'package:wsa_pacman/windows/win_info.dart';
import 'package:flex_color_picker/flex_color_picker.dart' as flex;
import 'package:flutter/material.dart' as mat;

import '/utils/string_utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

const List<String> accentColorNames = [
  'System',
  'Yellow',
  'Orange',
  'Red',
  'Magenta',
  'Purple',
  'Blue',
  'Teal',
  'Green',
];

class LateUpdater<E> {
  static const SETTINGS_UPDATE_TIMER = Duration(seconds: 3);
  E initialValue;
  Timer? timer;
  Function(E value) callback;

  LateUpdater(this.initialValue, this.callback);
  void update(E newValue) {
    initialValue = newValue;
    timer?.cancel();
    timer = Timer(SETTINGS_UPDATE_TIMER, () {
      if (initialValue == newValue) callback(initialValue);
    });
  }

  void cancel() => timer?.cancel();

  void instant(E newValue) {
    timer?.cancel();
    callback(newValue);
  }
}

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key, this.controller});
  final ScrollController? controller;

  @override
  State<StatefulWidget> createState() => ScreenSettingsState();
}

class ScreenSettingsState extends State<ScreenSettings> {
  static const SETTINGS_UPDATE_TIMER = Duration(seconds: 3);

  late final androidPortUpdater = LateUpdater<int>(GState.androidPort.$, (value) {
    GState.androidPort
      ..update((p0) => value)
      ..persist();
    log("AGGIORNATO: ${GState.androidPort.$}");
  });

  // ★ 追加：カスタムカラーピッカー用のRGB変数（初期値はきれいなブルー）
// ★ 追加：カスタムカラーピッカー用の変数（初期値はきれいなブルー）
  Color _customColor = const Color.fromRGBO(0, 120, 215, 1.0);

  ScreenSettingsState();
  late Future<ScalableImageWidget> _exBackground;
  late Future<ScalableImageWidget> _exForeground;
  late Future<ScalableImageWidget> _exLegacyIcon;

  static Future<ScalableImageWidget> _loadIcon(String asset) async {
    var scalable = ScalableImage.fromSIAsset(rootBundle, asset);
    return ScalableImageWidget(si: await scalable);
  }

  @override
  void initState() {
    super.initState();
    _exBackground = _loadIcon("assets/icons/missing_icon_background.si");
    _exForeground = _loadIcon("assets/icons/missing_icon_foreground.si");
    _exLegacyIcon = _loadIcon("assets/icons/missing_icon_legacy.si");
  }

  @override
  void dispose() {
    androidPortUpdater.cancel();
    super.dispose();
  }

  static List<Widget> optionsListDeferred<E extends ProtobufEnum, V>(
          List<E> values,
          String Function(E)? title,
          V Function(E e) getter,
          bool Function(V v) checked,
          Function(E e, V v) updater) =>
      List.generate(values.length, (index) {
        final modeOpt = values[index];
        final mode = getter(modeOpt);
        return Padding(
          padding: index != values.length - 1
              ? const EdgeInsets.only(bottom: 8.0)
              : EdgeInsets.zero,
          child: Row(
            children: [
              Checkbox(
                checked: checked(mode),
                onChanged: (bool? value) {
                  if (value == true) {
                    updater(modeOpt, mode);
                  }
                },
              ),
              const SizedBox(width: 8),
              Text(title != null
                  ? title(modeOpt)
                  : modeOpt.toString().normalized),
            ],
          ),
        );
      });

  static List<Widget> optionsList<E extends ProtobufEnum>(
          List<E> values,
          String Function(E)? title,
          bool Function(E e) checked,
          Function(E e) updater) =>
      optionsListDeferred<E, E>(
          values, title, (e) => e, checked, (e, v) => updater(e));

  static final _localeItems = <NamedLocale>[LocaleUtils.SYSTEM_LOCALE]
      .followedBy(LocaleUtils.supportedLocales)
      .map((l) => ComboBoxItem(value: l, child: Text(l.name)))
      .toList();

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    final localeLang = GState.locale.of(context);
    final lang = AppLocalizations.of(context)!;

    final tooltipThemeData = TooltipThemeData(decoration: () {
      const radius = BorderRadius.zero;
      final shadow = [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(1, 1),
          blurRadius: 10.0,
        ),
      ];
      final border = Border.all(color: Colors.grey[100], width: 0.5);
      if (theme.brightness == Brightness.light) {
        return BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: border,
          boxShadow: shadow,
        );
      } else {
        return BoxDecoration(
          color: Colors.grey,
          borderRadius: radius,
          border: border,
          boxShadow: shadow,
        );
      }
    }());

    const empty = SizedBox.shrink();
    const smallSpacer = SizedBox(height: 5.0);
    const spacer = SizedBox(height: 10.0);

    final themeMode = GState.theme.of(context).mode;
    final iconShape = GState.iconShape.of(context);
    final mica = GState.mica.of(context);
    final legacyIcons = GState.legacyIcons.of(context);
    final autostartWSA = GState.autostartWSA.of(context);
    final installTimeout = GState.installTimeout.of(context);

    final OFF = lang.btn_switch_off;
    final ON = lang.btn_switch_on;

    final exampleIcon = FutureBuilder(
        future: legacyIcons
            ? _exLegacyIcon
            : (() async => AdaptiveIcon(
                background: await _exBackground,
                foreground: await _exForeground,
                radius: iconShape.radius))(),
        builder: (context, AsyncSnapshot<Widget> snapshot) =>
            snapshot.data ?? empty);

    return ScaffoldPage(
      header: PageHeader(title: Text(lang.screen_settings)),
      content: SmoothListView(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        children: [
          spacer,
          FluentCard(
            leading: const Icon(fsi.FluentIcons.wifi_1_24_regular, size: 24),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(lang.settings_port,
                  style: const TextStyle(fontSize: 15)),
            ),
            trailing: SizedBox(
                width: 300,
                height: 32,
                child: FluentTextBox(
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        var androidPortVal = (newValue.text.isNumeric())
                            ? (newValue.text.length > 5 ||
                                    (newValue.text.isEmpty
                                            ? 58526
                                            : int.parse(newValue.text)) <=
                                        65535
                                ? newValue
                                : TextEditingValue(
                                    text: "65535",
                                    selection: newValue.selection))
                            : (oldValue.text.isNumeric()
                                ? oldValue
                                : TextEditingValue.empty);
                        GState.androidPortPending.$ =
                            androidPortVal.text.isEmpty
                                ? 58526.toString()
                                : androidPortVal.text;
                        return androidPortVal;
                      })
                    ],
                    maxLength: 5,
                    maxLines: 1,
                    maxLengthEnforced: true,
                    controller: TextEditingController.fromValue(
                        TextEditingValue(text: GState.androidPortPending.$)),
                    autofocus: false,
                    onChanged: (value) => androidPortUpdater
                        .update(value.isEmpty ? 58526 : int.parse(value)),
                    enableSuggestions: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    prefix: const Padding(
                        padding: EdgeInsetsDirectional.only(start: 10),
                        child: Text("127.0.0.1 :")),
                    suffix: IconButton(
                      iconButtonMode: IconButtonMode.small,
                      icon: const Icon(FluentIcons.reset),
                      onPressed: () {
                        GState.androidPortPending
                            .update((_) => 58526.toString());
                        androidPortUpdater.instant(58526);
                        setState(() {});
                      },
                    ))),
          ),
          smallSpacer,
          FluentCard(
            leading: const Icon(fsi.FluentIcons.power_24_regular, size: 24),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(lang.settings_autostart,
                  style: const TextStyle(fontSize: 15)),
            ),
            trailing: Row(children: [
              ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 28.5),
                  child: Text(autostartWSA ? ON : OFF)),
              ToggleSwitch(
                  checked: autostartWSA,
                  onChanged: (v) => GState.autostartWSA
                    ..$ = v
                    ..persist())
            ]),
          ),
          smallSpacer,
          // レジストリ自動バックアップの設定（カード型でおしゃれに）
          FluentCard(
            leading: const Icon(fsi.FluentIcons.save_24_regular, size: 24),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(lang.auto_backup_registry,
                  style: const TextStyle(fontSize: 15)),
            ),
            trailing: ToggleSwitch(
              checked: GState.autoBackupRegistry.of(context),
              onChanged: (v) => GState.autoBackupRegistry.$ = v,
            ),
          ),
          const SizedBox(height: 5.0), // 下の項目との隙間
          smallSpacer,
          FluentCard(
            leading: const Icon(fsi.FluentIcons.timer_24_regular, size: 24),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                  lang.settings_timeout(
                      installTimeout == 0 ? '∞' : '$installTimeout'),
                  style: const TextStyle(fontSize: 15)),
            ),
            trailing: SizedBox(
                width: 300,
                height: 32,
                child: FluentCard(
                    isInner: true,
                    content: Slider(
                      min: 0,
                      max: 105,
                      value: (installTimeout == 0
                              ? 105
                              : installTimeout < 15
                                  ? 15
                                  : installTimeout > 105
                                      ? 105
                                      : installTimeout)
                          .toDouble(),
                      divisions: 7,
                      label: installTimeout == 0 ? '∞' : '$installTimeout',
                      style: SliderThemeData(
                        labelBackgroundColor:
                            theme.accentColor, // ★透明からテーマカラーに修正済み！
                      ),
                      onChanged: (l) {
                        l = (l == 0)
                            ? 15
                            : (l == 105)
                                ? 0
                                : l;
                        GState.installTimeout
                          ..$ = l.toInt()
                          ..persist();
                      },
                    ))),
          ),
          smallSpacer,
          FluentCard(
            leading: const Icon(fsi.FluentIcons.translate_24_regular, size: 24),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(lang.settings_language,
                  style: const TextStyle(fontSize: 15)),
            ),
            trailing: SizedBox(
                width: 300,
                height: 32,
                child: FluentCombobox<NamedLocale>(
                  allowUnknown: true,
                  onTap: () {},
                  placeholder: Text(localeLang.name),
                  isExpanded: true,
                  value: localeLang,
                  onChanged: (l) {
                    if (l != null)
                      GState.locale
                        ..$ = l
                        ..persist();
                  },
                  items: _localeItems,
                )),
          ),
          smallSpacer,
          ExpanderWin11(
            leading:
                const Icon(fsi.FluentIcons.weather_moon_24_regular, size: 23),
            header: Text(lang.theme_mode),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: optionsListDeferred<Options_Theme, ThemeMode>(
                    Options_Theme.values,
                    (e) => e.description(lang),
                    (e) => e.mode,
                    (v) => themeMode == v,
                    (e, v) => GState.theme
                      ..update((p0) => e)
                      ..persist())),
            direction: ExpanderDirection.down,
            initiallyExpanded: false,
          ),
          smallSpacer,

// ★修正：テーマカラー設定の多言語化
          ExpanderWin11(
            leading:
                const Icon(fsi.FluentIcons.paint_brush_24_regular, size: 23),
            header: Text(lang.settings_theme_color),
            initiallyExpanded: false,
            direction: ExpanderDirection.down,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final colors = [
                        Colors.blue, // Fallback for system
                        AppTheme.alpineLandingDark,
                        Colors.yellow,
                        Colors.orange,
                        Colors.red,
                        Colors.magenta,
                        Colors.purple,
                        Colors.blue,
                        Colors.teal,
                        Colors.green,
                      ];
                      final colorNames = [
                        lang.settings_theme_color_system,
                        lang.settings_theme_color_default,
                        "Yellow",
                        "Orange",
                        "Red",
                        "Magenta",
                        "Purple",
                        "Blue",
                        "Teal",
                        "Green"
                      ];
                      final color = colors[index];

                      final isSelected = appTheme
                              .getColor(theme.brightness == Brightness.dark)
                              .value ==
                          color.value;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Tooltip(
                          message: colorNames[index],
                          child: IconButton(
                            iconButtonMode: IconButtonMode.large,
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(color),
                              shape: WidgetStateProperty.all(const CircleBorder()),
                            ),
                            onPressed: () => appTheme.setColor(color),
                            icon: isSelected
                                ? Icon(FluentIcons.check_mark,
                                    size: 14, color: color.appBasedOnLuminance())
                                : const SizedBox(width: 14, height: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // ★ ボタン押下時にダイアログを表示する形式に変更
                Button(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        // ダイアログ内での色管理用
                        Color dialogColor = _customColor;
                        return StatefulBuilder(
                          builder: (context, setDialogState) {
                            return ContentDialog(
                              constraints: const BoxConstraints(maxWidth: 450),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    mat.Material(
                                      color: Colors.transparent,
                                      child: flex.ColorPicker(
                                        color: dialogColor,
                                        onColorChanged: (Color color) => setDialogState(() => dialogColor = color),
                                        width: 40,
                                        height: 40,
                                        borderRadius: 4,
                                        padding: const EdgeInsets.all(0), // パディングをゼロに
                                        spacing: 5,
                                        runSpacing: 5,
                                        wheelDiameter: 155,
                                        showMaterialName: false,
                                        showColorName: false,
                                        showColorCode: true,
                                        colorCodeHasColor: true,
                                        pickersEnabled: const <flex.ColorPickerType, bool>{
                                          flex.ColorPickerType.both: true,
                                          flex.ColorPickerType.primary: false,
                                          flex.ColorPickerType.accent: false,
                                          flex.ColorPickerType.bw: false,
                                          flex.ColorPickerType.custom: false,
                                          flex.ColorPickerType.wheel: true,
                                        },
                                        copyPasteBehavior: const flex.ColorPickerCopyPasteBehavior(
                                          longPressMenu: true,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8), // 20から8へ縮小
                                    // RGB 手入力フィールド
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InfoLabel(
                                            label: 'R',
                                            child: NumberBox(
                                              value: dialogColor.red,
                                              min: 0,
                                              max: 255,
                                              onChanged: (v) => setDialogState(() => dialogColor = dialogColor.withRed(v ?? 0)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: InfoLabel(
                                            label: 'G',
                                            child: NumberBox(
                                              value: dialogColor.green,
                                              min: 0,
                                              max: 255,
                                              onChanged: (v) => setDialogState(() => dialogColor = dialogColor.withGreen(v ?? 0)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: InfoLabel(
                                            label: 'B',
                                            child: NumberBox(
                                              value: dialogColor.blue,
                                              min: 0,
                                              max: 255,
                                              onChanged: (v) => setDialogState(() => dialogColor = dialogColor.withBlue(v ?? 0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                Button(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(dialogColor),
                                    foregroundColor: WidgetStateProperty.all(dialogColor.appBasedOnLuminance()),
                                  ),
                                  child: Text(lang.btn_apply),
                                  onPressed: () {
                                    setState(() => _customColor = dialogColor);
                                    appTheme.setColor(dialogColor.appToAccentColor());
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: appTheme.getColor(theme.brightness == Brightness.dark),
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.resources.textFillColorPrimary, width: 1),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(lang.settings_custom_color), // 「カスタムカラー」に変更
                    ],
                  ),
                ),
              ], // ★ココ！ Columnの要素を閉じる
            ), // ★ココ！ Column本体を閉じる
          ), // ★ココ！ ExpanderWin11を閉じる
          smallSpacer,
// 自動バックアップ保存先の指定
          FluentCard(
            leading: const Icon(fsi.FluentIcons.folder_24_regular, size: 23),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(lang.settings_auto_backup_dir), // ←変更
                Text(
                  GState.backupDirectory.of(context),
                  style: FluentTheme.of(context).typography.caption,
                ),
              ],
            ),
            trailing: Row(
              children: [
                if (GState.backupDirectory.of(context) !=
                    '${Env.USER_PROFILE}\\Desktop')
                  Tooltip(
                    message: lang.tooltip_reset_desktop, // ←変更
                    child: IconButton(
                      icon: const Icon(FluentIcons.clear),
                      onPressed: () => GState.backupDirectory.$ =
                          '${Env.USER_PROFILE}\\Desktop',
                    ),
                  ),
                const SizedBox(width: 8),
                // 参照ボタン
                Button(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0)), // 少し大きく
                    shape: WidgetStateProperty.resolveWith((states) {
                      return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(
                          color: FluentTheme.of(context)
                              .inactiveColor
                              .withOpacity(states.contains(WidgetState.hovered)
                                  ? 0.4
                                  : 0.2),
                          width: 1.0,
                        ),
                      );
                    }),
                  ),
                  child: Text(lang.btn_browse,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    // ★修正：PowerShellのダイアログ内も多言語化！
                    final script = '''
                      Add-Type -AssemblyName System.Windows.Forms
                      \$dlg = New-Object System.Windows.Forms.OpenFileDialog
                      \$dlg.Title = "${lang.dialog_backup_dir_title}"
                      \$dlg.FileName = "${lang.dialog_backup_dir_filename}"
                      \$dlg.Filter = "${lang.dialog_backup_dir_filter}"
                      \$dlg.CheckFileExists = \$false
                      \$dlg.CheckPathExists = \$true
                      \$dlg.ValidateNames = \$false
                      if (\$dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                        Write-Output ([System.IO.Path]::GetDirectoryName(\$dlg.FileName))
                      }
                    ''';
                    final process = await Process.run(
                        'powershell', ['-NoProfile', '-Command', script]);
                    final path = process.stdout.toString().trim();
                    if (path.isNotEmpty) {
                      GState.backupDirectory.$ = path;
                    }
                  },
                ),
              ],
            ),
          ),
          smallSpacer,

          if (WinVer.isWindows11OrGreater)
            ExpanderWin11(
              leading: const Icon(fsi.FluentIcons.blur_24_regular, size: 23),
              header: Text(lang.theme_mica),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: optionsList<Options_Mica>(
                      Options_Mica.values,
                      (e) => e.description(lang),
                      (e) => mica == e,
                      (e) => GState.mica
                        ..update((_) => e)
                        ..persist())),
              direction: ExpanderDirection.down,
              initiallyExpanded: false,
            ),
          if (WinVer.isWindows11OrGreater) smallSpacer,
          ExpanderWin11(
            leading: SizedBox(width: 23.00, height: 23.00, child: exampleIcon),
            header: Text(lang.theme_icon_adaptive),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: optionsList<Options_IconShape>(
                    Options_IconShape.values,
                    (e) => e.description(lang),
                    (e) => iconShape == e,
                    (e) => GState.iconShape
                      ..update((_) => e)
                      ..persist())),
            trailing: Row(children: [
              ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 28.5),
                  child: Text(legacyIcons ? OFF : ON)),
              ToggleSwitch(
                  checked: !legacyIcons,
                  onChanged: (v) => GState.legacyIcons
                    ..$ = !v
                    ..persist())
            ]),
            direction: ExpanderDirection.down,
            initiallyExpanded: false,
          )
        ],
      ),
    );
  }
}
