import json
import os

locale_dir = os.path.join(os.path.dirname(__file__), 'locale')

# Based on the improved JA variants, we will inject these base English improvements to ALL files 
# since most foreign translations were just copies of English or robotic.
# This prevents broken apps and unifies the design intent.

updates = {
    "status_unsupported_desc": "{windowsVersion} detected but WSA was not found. This application depends on WSA, which is officially supported only on Windows 11.",
    "status_connected_desc": "Successfully connected to WSA. All systems are operational and ready.",
    "wsa_manage_app": "Manage Applications",
    "wsa_manage_settings": "Manage Settings",
    "settings_option_generic_disabled": "Disabled",
    "theme_mica": "Mica Effect (Window Transparency)",
    "theme_mica_full": "Full",
    "theme_mica_partial": "Partial",
    "theme_icon_adaptive_squircle": "Squircle (Rounded Corner)",
    "theme_icon_adaptive_rounded_square": "Rounded Square"
}

for filename in os.listdir(locale_dir):
    if filename.endswith(".arb") and filename != "ja.arb":
        filepath = os.path.join(locale_dir, filename)
        
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            modified = False
            for key, new_val in updates.items():
                if key in data and data[key] != new_val:
                    data[key] = new_val
                    modified = True
            
            if modified:
                with open(filepath, 'w', encoding='utf-8') as f:
                    # To keep it pretty like default arb files
                    json.dump(data, f, ensure_ascii=False, indent=4)
                print(f"Updated {filename}")
                
        except Exception as e:
            print(f"Failed processing {filename}: {e}")

print("Done patching ARB files.")
