#!/usr/bin/env python3
"""
arb_to_resw.py
Flutter の .arb ファイルを WinUI 3 の .resw (XML) に変換するスクリプト。

使い方:
    python arb_to_resw.py <input_dir> <output_dir>

    input_dir  : .arb ファイルが入ったフォルダ（例: lib/l10n）
    output_dir : .resw を出力するフォルダ（例: Strings）

出力先:
    <output_dir>/<locale>/Resources.resw
    例: Strings/ja/Resources.resw
        Strings/en/Resources.resw

注意:
    - @キーで始まるメタデータキーは無視します。
    - {placeholder} 形式のプレースホルダーはそのまま保持します。
      （WinUI 3 側で string.Format や独自の置換処理で使ってください）
    - @@locale キーから言語コードを取得します。
      ファイル名（例: ja.arb）からも取得できます。
"""

import json
import os
import sys
import xml.etree.ElementTree as ET
from xml.dom import minidom


def arb_to_resw(arb_path: str, output_dir: str) -> None:
    with open(arb_path, encoding="utf-8") as f:
        data = json.load(f)

    # 言語コードの取得（@@locale → ファイル名の順で試みる）
    locale = data.get("@@locale") or os.path.splitext(os.path.basename(arb_path))[0]

    # XML ルート要素
    root = ET.Element("root")

    # resheader（WinUI 3 の resw に必要なお決まりのヘッダ）
    headers = [
        ("resmimetype", "text/microsoft-resx"),
        ("version", "2.0"),
    ]
    for name, val in headers:
        header = ET.SubElement(root, "resheader", name=name)
        value_el = ET.SubElement(header, "value")
        value_el.text = val

    # キーと値の変換
    for key, value in data.items():
        # @キー（メタデータ）は除外
        if key.startswith("@"):
            continue
        # 文字列以外の値（辞書など）は除外
        if not isinstance(value, str):
            continue

        data_el = ET.SubElement(root, "data", name=key)
        data_el.set("xml:space", "preserve")
        value_el = ET.SubElement(data_el, "value")
        value_el.text = value

    # 整形して出力
    xml_str = minidom.parseString(ET.tostring(root, encoding="unicode")).toprettyxml(
        indent="  "
    )
    # minidom が追加する <?xml ...?> 宣言を WinUI 3 向けに差し替え
    xml_str = '<?xml version="1.0" encoding="utf-8"?>\n' + "\n".join(
        xml_str.splitlines()[1:]
    )

    locale_dir = os.path.join(output_dir, locale)
    os.makedirs(locale_dir, exist_ok=True)
    out_path = os.path.join(locale_dir, "Resources.resw")
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(xml_str)

    print(f"✅ {locale:10s} → {out_path}")


def main() -> None:
    if len(sys.argv) != 3:
        print("使い方: python arb_to_resw.py <input_dir> <output_dir>")
        sys.exit(1)

    input_dir = sys.argv[1]
    output_dir = sys.argv[2]

    arb_files = [f for f in os.listdir(input_dir) if f.endswith(".arb")]
    if not arb_files:
        print(f"❌ .arb ファイルが見つかりません: {input_dir}")
        sys.exit(1)

    print(f"📂 入力: {input_dir}")
    print(f"📂 出力: {output_dir}")
    print(f"🔄 {len(arb_files)} 件のファイルを変換します...\n")

    for arb_file in sorted(arb_files):
        arb_to_resw(os.path.join(input_dir, arb_file), output_dir)

    print(f"\n✨ 完了！{len(arb_files)} 件のファイルを変換しました。")


if __name__ == "__main__":
    main()
