#!/usr/bin/env python3
"""
Enhanced ADB Root Module Packager
Creates the Magisk module zip file with proper structure
"""

import zipfile
import os
import sys

def create_magisk_module():
    """Create the Magisk module zip file"""
    
    # Module configuration
    module_name = "adb_root_enhanced"
    module_version = "v2.0"
    zip_filename = f"{module_name}-{module_version}.zip"
    
    # Files to include in the module
    files_to_include = [
        'META-INF/com/google/android/update-binary',
        'META-INF/com/google/android/updater-script',
        'system/bin/adbd',
        'module.prop',
        'sepolicy.rule',
        'README.md',
        'TECHNICAL_DOCS.md'
    ]
    
    print(f"Creating Magisk module: {zip_filename}")
    
    try:
        with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as zipf:
            for file_path in files_to_include:
                if os.path.exists(file_path):
                    # Add file to zip with proper path
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
    success = create_magisk_module()
    sys.exit(0 if success else 1)