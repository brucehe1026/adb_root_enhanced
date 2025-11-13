#!/system/bin/sh
# ADB Root Compatibility Test Script
# Helps determine the best module for your device

echo "=== ADB Root Compatibility Test ==="
echo

# Get device information
echo "📱 Device Information:"
echo "Manufacturer: $(getprop ro.product.manufacturer)"
echo "Model: $(getprop ro.product.model)"
echo "Android Version: $(getprop ro.build.version.release)"
echo "API Level: $(getprop ro.build.version.sdk)"
echo "Build Number: $(getprop ro.build.display.id)"
echo

# Check current ADB status
echo "🔍 Current ADB Status:"
if [ -f /system/bin/adbd ]; then
    echo "✓ ADB daemon binary exists"
    ls -la /system/bin/adbd | awk '{print "  Size: " $5 " bytes, Permissions: " $1}'
else
    echo "✗ ADB daemon binary missing"
fi

# Check SELinux status
echo
echo "🔒 SELinux Status:"
SELINUX_STATUS=$(getenforce)
echo "Current Mode: $SELINUX_STATUS"

# Check if adbd is running
echo
echo "⚙️ ADB Daemon Status:"
if pgrep -x adbd > /dev/null; then
    echo "✓ ADB daemon is running"
    echo "  Process ID: $(pgrep -x adbd)"
else
    echo "✗ ADB daemon not running"
fi

# Check build properties
echo
echo "🔧 Build Configuration:"
echo "ro.debuggable: $(getprop ro.debuggable)"
echo "ro.secure: $(getprop ro.secure)"
echo "ro.build.type: $(getprop ro.build.type)"

# Recommend module based on Android version
echo
echo "📋 Module Recommendation:"
API_LEVEL=$(getprop ro.build.version.sdk)

case $API_LEVEL in
    28)
        echo "✅ Android 9 (API 28) detected"
        echo "📦 Recommended: adb_root_android9-v2.0-android9.zip"
        echo "💡 Strategy: Binary replacement (proven method)"
        ;;
    29)
        echo "⚠️ Android 10 (API 29) detected"
        echo "📦 Recommended: adb_root_android10-v2.0-android10.zip"
        echo "💡 Strategy: SELinux-only enhancement (preserves daemon)"
        echo "⚠️ Important: Avoid binary replacement to prevent ADB detection issues"
        ;;
    30)
        echo "🧪 Android 11 (API 30) detected"
        echo "📦 Recommended: adb_root_android11-v2.0-android11.zip"
        echo "💡 Strategy: Enhanced binary + minijail bypass"
        echo "⚠️ Experimental: Requires testing"
        ;;
    31|32|33)
        echo "🧪 Android 12+ (API $API_LEVEL) detected"
        echo "📦 Recommended: adb_root_android12-v2.0-android12.zip"
        echo "💡 Strategy: Comprehensive security bypass"
        echo "⚠️ Experimental: Requires testing"
        ;;
    *)
        echo "❓ Unknown Android version (API $API_LEVEL)"
        echo "📦 Recommended: adb_root_universal-v2.0-universal.zip"
        echo "💡 Strategy: Auto-detection and smart selection"
        echo "⚠️ Will attempt to detect and apply best method"
        ;;
esac

# Check for potential issues
echo
echo "🔍 Potential Issue Analysis:"

# Check if system is read-only
if [ "$(mount | grep ' /system ' | grep -c 'ro,')" -gt 0 ]; then
    echo "⚠️ System partition is read-only - Magisk module required"
else
    echo "✓ System partition is writable"
fi

# Check Magisk status
if [ -d /data/adb/magisk ]; then
    echo "✓ Magisk detected"
    if [ -f /data/adb/magisk/util_functions.sh ]; then
        echo "✓ Magisk utilities available"
    else
        echo "⚠️ Magisk utilities missing"
    fi
else
    echo "⚠️ Magisk not detected - module installation not possible"
fi

# Additional compatibility checks
echo
echo "🔍 Additional Compatibility Checks:"

# Check for Treble support
if [ -f /system/etc/vintf/manifest.xml ]; then
    echo "✓ Treble-enabled device"
else
    echo "⚠️ Non-Treble device (older Android)"
fi

# Check architecture
ARCH=$(getprop ro.product.cpu.abi)
echo "Architecture: $ARCH"

# Check for APEX support (Android 10+)
if [ -d /apex ]; then
    echo "✓ APEX support detected (Android 10+)"
else
    echo "ℹ️ No APEX support (Android 9 or older)"
fi

echo
echo "=== Test Summary ==="
echo "This analysis helps determine the most suitable ADB Root module."
echo "For best results, use the recommended module for your Android version."
echo
echo "Next steps:"
echo "1. Download the recommended module"
echo "2. Install via Magisk Manager"
echo "3. Reboot device"
echo "4. Test with: adb devices && adb root"
echo
echo "If you encounter issues, try the Universal module or report feedback."