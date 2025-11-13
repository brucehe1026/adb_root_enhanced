# ADB Root Enhanced - GitHub Repository README

[![Version](https://img.shields.io/badge/version-v2.0-blue.svg)](https://github.com/brucehe1026/adb_root_enhanced)
[![Android Support](https://img.shields.io/badge/Android-9%2C10%2C11%2C12%2B-green.svg)](https://github.com/brucehe1026/adb_root_enhanced)
[![Magisk](https://img.shields.io/badge/Magisk-20.4%2B-orange.svg)](https://github.com/topjohnwu/Magisk)
[![License](https://img.shields.io/badge/license-GPL--3.0-yellow.svg)](LICENSE)

Enhanced ADB Root module supporting Android 9, 10, 11, 12+ with version-specific optimizations and intelligent compatibility detection.

> **📋 Project Origin**: This project is an enhanced version based on the original [evdenis/adb_root](https://github.com/evdenis/adb_root) project, extending support to Android 11, 12+ and fixing critical Android 10 compatibility issues.

## 🚀 Features

- **Multi-Version Support**: Android 9, 10, 11, 12+ compatibility
- **Intelligent Detection**: Auto-detects Android version and applies optimal strategy
- **Android 10 Fix**: Resolves ADB daemon detection issues specific to Android 10
- **Minijail Bypass**: Handles Android 11+ sandboxing mechanisms
- **Safe Installation**: Version-specific modules prevent system breakage
- **Comprehensive Testing**: Built-in compatibility verification tools

## 📱 Version-Specific Strategies

| Android Version | API Level | Strategy | Status | Module |
|----------------|-----------|----------|---------|---------|
| Android 9 | 28 | Binary Replacement | ✅ Stable | `adb_root_android9-v2.0-android9.zip` |
| Android 10 | 29 | SELinux-Only Enhancement | ✅ Fixed | `adb_root_android10-v2.0-android10.zip` |
| Android 11 | 30 | Enhanced + Minijail Bypass | 🧪 Experimental | `adb_root_android11-v2.0-android11.zip` |
| Android 12+ | 31+ | Comprehensive Bypass | 🧪 Experimental | `adb_root_android12-v2.0-android12.zip` |
| Unknown | Auto | Smart Detection | ✅ Recommended | `adb_root_universal-v2.0-universal.zip` |

## 🛠️ Installation

### Quick Start (Recommended)

1. **Download the Universal Module** (if unsure about your Android version):
   ```
   adb_root_universal-v2.0-universal.zip
   ```

2. **Install via Magisk Manager**:
   - Open Magisk Manager
   - Go to Modules tab
   - Tap "Install from storage"
   - Select the downloaded ZIP file
   - Reboot your device

3. **Verify Installation**:
   ```bash
   adb devices    # Check device detection
   adb root       # Enable root access
   adb shell id   # Verify root identity
   ```

### Version-Specific Installation

If you know your Android version, use the specific module for optimal results:

#### Android 9
```bash
# Use: adb_root_android9-v2.0-android9.zip
```

#### Android 10
```bash
# Use: adb_root_android10-v2.0-android10.zip
# Important: This preserves original ADB daemon to prevent detection issues
```

#### Android 11+
```bash
# Use: adb_root_android11-v2.0-android11.zip or android12 version
```

## 🔍 Pre-Installation Testing

Run the compatibility test script to check your device:

```bash
# On your device (requires root)
sh test_adb_root_compatibility.sh
```

This will:
- Detect your Android version and device info
- Check current ADB status
- Recommend the best module for your device
- Identify potential compatibility issues

## 📋 Requirements

- **Magisk**: Version 20.4 or higher
- **Android**: Version 9.0 (Pie) or higher
- **Root**: Device must be rooted with Magisk
- **ADB**: ADB tools installed on your computer

## 🐛 Troubleshooting

### "adb devices" Not Detecting Phone (Android 10)
**Solution**: Use Android 10 specific module (`adb_root_android10-v2.0-android10.zip`)
- This preserves original ADB daemon
- Only enhances SELinux policies
- Maintains device connectivity

### "Permission Denied" Errors
**Solution**: Check SELinux status and module compatibility
```bash
# Check SELinux
getenforce

# Verify module installation
ls -la /data/adb/modules/
```

### Installation Failures
**Solution**: Ensure proper Magisk version and module integrity
```bash
# Check Magisk version
magisk --version

# Verify module structure
unzip -l your_module.zip
```

## 📊 Development History

See [DEVELOPMENT_ITERATION_HISTORY.md](DEVELOPMENT_ITERATION_HISTORY.md) for detailed development iterations, bug fixes, and technical evolution.

## 🔧 Advanced Usage

### Module Generation
Generate custom modules for specific Android versions:
```bash
python generate_version_modules.py
```

### Compatibility Analysis
Detailed version compatibility information:
- [ANDROID_VERSION_COMPATIBILITY.md](ANDROID_VERSION_COMPATIBILITY.md)

## 📝 Technical Details

### How It Works

1. **Android 9**: Direct binary replacement with property bypass
2. **Android 10**: SELinux policy enhancement (preserves daemon)
3. **Android 11+**: Enhanced binary with minijail sandbox bypass
4. **Universal**: Auto-detects version and applies optimal strategy

### Key Technical Features

- **Property Bypass**: Bypasses `ro.debuggable` and `ro.secure` checks
- **SELinux Enhancement**: Expands security policies for root transitions
- **Minijail Bypass**: Handles Android 11+ sandboxing mechanisms
- **Daemon Preservation**: Maintains ADB connectivity on Android 10

### Original Project Foundation

This enhanced version builds upon the excellent foundation provided by the original [evdenis/adb_root](https://github.com/evdenis/adb_root) project, which established the core ADB daemon root functionality for Android 9/10. Our enhancements extend this capability to modern Android versions while maintaining the original project's reliability and simplicity.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Testing
Help test on different devices and Android versions:
1. Run compatibility test script
2. Install appropriate module
3. Report results in issues

## 📄 License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

- Use at your own risk
- May void device warranty
- Ensure you have a backup before installation
- Not responsible for any device damage or data loss

## 🙏 Acknowledgments

### Original Project
- **[evdenis/adb_root](https://github.com/evdenis/adb_root)** - The original ADB Root project that this enhanced version is based on. The original project provided Android 9/10 support with the core ADB daemon root functionality.

### Technical Foundation
- [Magisk](https://github.com/topjohnwu/Magisk) by topjohnwu - The root solution that makes this module possible
- Android Open Source Project - For the ADB daemon source code and documentation

### Enhancement Contributions
This enhanced version extends the original project by:
- Adding Android 11, 12+ support with minijail bypass
- Fixing critical Android 10 ADB detection issues
- Implementing intelligent version detection
- Creating version-specific optimization strategies
- Providing comprehensive compatibility testing tools

## 📞 Support

- 📋 Create an issue for bug reports
- 💡 Suggest improvements via issues
- 📧 Contact for questions about compatibility

---

**⭐ If this project helps you, please give it a star!**