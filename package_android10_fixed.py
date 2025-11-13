#!/usr/bin/env python3
"""
Fixed Android 10 Compatible ADB Root Module
Creates a properly structured Magisk module for Android 10
"""

import zipfile
import os
import sys

def create_fixed_android10_module():
    """Create properly structured Android 10 compatible Magisk module"""
    
    module_name = "adb_root_android10_fixed"
    module_version = "v2.0-fix"
    zip_filename = f"{module_name}-{module_version}.zip"
    
    print(f"Creating fixed Android 10 compatible module: {zip_filename}")
    
    # Create the proper module structure
    files_to_package = [
        ('META-INF/com/google/android/update-binary-android10', 'META-INF/com/google/android/update-binary'),
        ('META-INF/com/google/android/updater-script', 'META-INF/com/google/android/updater-script'),
        ('module_android10.prop', 'module.prop'),
        ('sepolicy_android10.rule', 'sepolicy.rule')
    ]
    
    try:
        with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as zipf:
            for source_path, dest_path in files_to_package:
                if os.path.exists(source_path):
                    zipf.write(source_path, dest_path)
                    print(f"Added: {source_path} -> {dest_path}")
                else:
                    print(f"Warning: Source file not found: {source_path}")
                    return False
        
        print(f"✓ Successfully created: {zip_filename}")
        print(f"Module size: {os.path.getsize(zip_filename)} bytes")
        
        # Verify the zip contents
        with zipfile.ZipFile(zip_filename, 'r') as zipf:
            print("\nVerifying zip contents:")
            for info in zipf.infolist():
                print(f"  {info.filename} ({info.file_size} bytes)")
                
        print("\n✓ Module structure verified")
        return True
        
    except Exception as e:
        print(f"Error creating zip file: {e}")
        return False

if __name__ == "__main__":
    success = create_fixed_android10_module()
    sys.exit(0 if success else 1)