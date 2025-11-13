#!/usr/bin/env python3
"""
Android 10 Compatible ADB Root Module Packager
Creates a Magisk module that works properly on Android 10
"""

import zipfile
import os
import sys

def create_android10_compatible_module():
    """Create Android 10 compatible Magisk module"""
    
    # Module configuration
    module_name = "adb_root_android10_compatible"
    module_version = "v2.0-android10"
    zip_filename = f"{module_name}-{module_version}.zip"
    
    print(f"Creating Android 10 compatible module: {zip_filename}")
    
    # Files to include in the module (Android 10 compatible)
    files_to_include = [
        'META-INF/com/google/android/update-binary-fixed',  # Fixed installer
        'META-INF/com/google/android/updater-script',
        'module_android10.prop',  # Android 10 specific config
        'sepolicy_android10.rule',  # Minimal SELinux policy
        'README.md',
        'TECHNICAL_DOCS.md'
    ]
    
    try:
        with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as zipf:
            for file_path in files_to_include:
                if os.path.exists(file_path):
                    # Use appropriate name in zip
                    if file_path == 'module_android10.prop':
                        zipf.write(file_path, 'module.prop')
                    elif file_path == 'sepolicy_android10.rule':
                        zipf.write(file_path, 'sepolicy.rule')
                    elif file_path == 'update-binary-fixed':
                        zipf.write(file_path, 'META-INF/com/google/android/update-binary')
                    else:
                        zipf.write(file_path, file_path)
                    print(f"Added: {file_path}")
                else:
                    print(f"Warning: File not found: {file_path}")
        
        print(f"✓ Successfully created: {zip_filename}")
        print(f"Module size: {os.path.getsize(zip_filename)} bytes")
        
        # Verify the zip contents
        with zipfile.ZipFile(zip_filename, 'r') as zipf:
            print("\nZip contents:")
            for info in zipf.infolist():
                print(f"  {info.filename} ({info.file_size} bytes)")
        
        return True
        
    except Exception as e:
        print(f"Error creating zip file: {e}")
        return False

if __name__ == "__main__":
    success = create_android10_compatible_module()
    sys.exit(0 if success else 1)