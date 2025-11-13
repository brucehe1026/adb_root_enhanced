# ADB Root Enhanced v2.0 Release Assets

Generated on: 2025-11-13 20:25:00

## 📦 Module Files

| Module | Size | Description | Target |
|--------|------|-------------|--------|
| `adb_root_android9-v2.0-android9.zip` | 4.2K | Binary replacement approach | Android 9 (API 28) |
| `adb_root_android10-v2.0-android10.zip` | 4.1K | SELinux-only enhancement (preserves daemon) | Android 10 (API 29) |
| `adb_root_android11-v2.0-android11.zip` | 4.3K | Enhanced binary with minijail bypass | Android 11 (API 30) |
| `adb_root_android12-v2.0-android12.zip` | 4.4K | Comprehensive security bypass | Android 12+ (API 31+) |
| `adb_root_universal-v2.0-universal.zip` | 5.2K | Auto-detection with intelligent strategy selection | All Android versions |

## 🎯 Download Recommendations

### For Most Users
**Use**: `adb_root_universal-v2.0-universal.zip`
- Auto-detects Android version
- Applies optimal strategy
- Safest choice for unknown devices

### For Known Android Versions
- **Android 9**: Use `adb_root_android9-v2.0-android9.zip`
- **Android 10**: Use `adb_root_android10-v2.0-android10.zip` (fixes ADB issues)
- **Android 11**: Use `adb_root_android11-v2.0-android11.zip`
- **Android 12+**: Use `adb_root_android12-v2.0-android12.zip`

## 🔧 Installation Steps

1. **Download** appropriate module
2. **Install via Magisk Manager** (Modules → Install from storage)
3. **Reboot device**
4. **Test functionality**:
   ```bash
   adb devices    # Check device detection
   adb root       # Enable root access
   adb shell id   # Verify root identity
   ```

## ⚠️ Important Notes

- **Android 10**: Always use specific module to avoid ADB detection failure
- **Android 11+**: Experimental support, feedback welcome
- **Backup First**: Always backup before installing modules
- **Test Compatibility**: Run `test_adb_root_compatibility.sh` first

## 📋 File Verification

Check file integrity using provided checksums:
- `checksums_sha256.txt` - SHA256 checksums
- `checksums_md5.txt` - MD5 checksums

---

**Repository**: https://github.com/brucehe1026/adb_root_enhanced  
**Issues**: https://github.com/brucehe1026/adb_root_enhanced/issues