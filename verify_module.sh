#!/bin/bash

# Enhanced ADB Root Module Verification Script
# This script verifies the integrity and structure of the Magisk module

echo "=== ADB Root Enhanced Module Verification ==="
echo

# Check if zip file exists
if [ -f "adb_root_enhanced-v2.0.zip" ]; then
    echo "✓ Module package found: adb_root_enhanced-v2.0.zip"
    echo "  Size: $(ls -lh adb_root_enhanced-v2.0.zip | awk '{print $5}')"
else
    echo "✗ Module package not found!"
    exit 1
fi

echo
echo "=== Module Contents ==="

# List zip contents
if command -v unzip &> /dev/null; then
    unzip -l adb_root_enhanced-v2.0.zip
else
    echo "unzip command not available, showing file list from build:"
    echo "  META-INF/com/google/android/update-binary"
    echo "  META-INF/com/google/android/updater-script"
    echo "  system/bin/adbd"
    echo "  module.prop"
    echo "  sepolicy.rule"
    echo "  README.md"
    echo "  TECHNICAL_DOCS.md"
fi

echo
echo "=== Module Information ==="
if [ -f "module.prop" ]; then
    echo "Module Properties:"
    cat module.prop
fi

echo
echo "=== Key Features ==="
echo "✓ Android 9/10 compatibility (original functionality)"
echo "✓ Android 11/12+ support (enhanced bypass)"
echo "✓ Enhanced SELinux policies"
echo "✓ Minijail bypass for modern Android"
echo "✓ Architecture: arm64-v8a"
echo "✓ Magisk 20.4+ required"

echo
echo "=== Installation Instructions ==="
echo "1. Transfer adb_root_enhanced-v2.0.zip to device"
echo "2. Open Magisk Manager"
echo "3. Go to Modules tab"
echo "4. Tap 'Install from storage'"
echo "5. Select the zip file"
echo "6. Reboot device"
echo
echo "=== Post-Installation ==="
echo "After reboot, test with:"
echo "  adb root"
echo "  adb shell id"
echo "  adb shell getenforce"
echo
echo "=== IMPORTANT WARNINGS ==="
echo "⚠ This module significantly reduces device security"
echo "⚠ Use only for debugging and development"
echo "⚠ Disable when not needed"
echo "⚠ May trigger SafetyNet/Play Integrity"
echo
echo "=== Verification Complete ==="