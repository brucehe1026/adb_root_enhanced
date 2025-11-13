#!/bin/bash
# GitHub Release Creation Script for ADB Root Enhanced
# This script helps create releases with proper versioning and assets

set -e

# Configuration
REPO_URL="https://github.com/brucehe1026/adb_root_enhanced"
PROJECT_NAME="ADB Root Enhanced"
CURRENT_VERSION="v2.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== ${PROJECT_NAME} Release Creation Script ===${NC}"
echo

# Check if git is available
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed${NC}"
    exit 1
fi

# Check if gh (GitHub CLI) is available
if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}Warning: GitHub CLI (gh) is not installed${NC}"
    echo -e "${YELLOW}Please install it from: https://cli.github.com/${NC}"
    echo -e "${YELLOW}Or create releases manually via GitHub web interface${NC}"
    echo
fi

# Function to create release notes
create_release_notes() {
    local version=$1
    local date=$(date +"%Y-%m-%d")
    
    cat << EOF
# ${PROJECT_NAME} ${version}

Released on ${date}

## 🚀 Major Features

### Multi-Version Android Support
- ✅ **Android 9** (API 28) - Stable binary replacement
- ✅ **Android 10** (API 29) - Fixed ADB detection issues  
- 🧪 **Android 11** (API 30) - Experimental minijail bypass
- 🧪 **Android 12+** (API 31+) - Experimental comprehensive bypass

### Key Innovations
- **Android 10 Fix**: Resolves ADB daemon detection failure
- **Minijail Bypass**: Handles Android 11+ sandboxing
- **Auto-Detection**: Universal module with intelligent version detection
- **Safe Installation**: Version-specific strategies prevent system breakage

## 📦 Release Assets

### Recommended Downloads

#### For Unknown Android Version
- \`adb_root_universal-v2.0-universal.zip\` (1.9KB) - **RECOMMENDED**
  - Auto-detects Android version
  - Applies optimal strategy automatically

#### For Specific Android Versions
- \`adb_root_android9-v2.0-android9.zip\` (1.7KB) - Android 9
- \`adb_root_android10-v2.0-android10.zip\` (1.6KB) - Android 10  
- \`adb_root_android11-v2.0-android11.zip\` (2.0KB) - Android 11
- \`adb_root_android12-v2.0-android12.zip\` (2.0KB) - Android 12+

## 🛠️ Installation

1. **Download appropriate module** for your Android version
2. **Install via Magisk Manager** (Modules → Install from storage)
3. **Reboot device**
4. **Test functionality**:
   \`\`\`bash
   adb devices    # Check device detection
   adb root       # Enable root access  
   adb shell id   # Verify root identity
   \`\`\`

## 🔍 Pre-Installation Testing

Run compatibility test on your device:
\`\`\`bash
sh test_adb_root_compatibility.sh
\`\`\`

## 🐛 Fixed Issues

- **Android 10 ADB Detection**: Fixed daemon initialization failure
- **Magisk Installation**: Resolved module structure issues
- **Version Compatibility**: Created version-specific optimization strategies

## 📊 Compatibility Matrix

| Android Version | Status | Strategy | Testing |
|----------------|--------|----------|---------|
| Android 9 | ✅ Stable | Binary Replacement | Verified |
| Android 10 | ✅ Fixed | SELinux-Only | Issue Resolved |
| Android 11 | 🧪 Experimental | Enhanced + Minijail | Requires Testing |
| Android 12+ | 🧪 Experimental | Comprehensive | Requires Testing |

## 📚 Documentation

- Complete development iteration history
- Version compatibility analysis
- Troubleshooting guides
- Technical implementation details

## ⚠️ Important Notes

- **Android 10 Users**: Use specific Android 10 module to avoid ADB detection issues
- **Android 11+**: Experimental support, feedback welcome
- **Universal Module**: Recommended for unknown versions
- **Backup First**: Always backup before installing modules

## 🤝 Contributing

- Test on your device and report results
- Submit issues for bugs or compatibility problems
- Share feedback for improvements

---

**⭐ If this release helps you, please star the repository!**
EOF
}

# Function to check release assets
check_release_assets() {
    echo -e "${BLUE}Checking release assets...${NC}"
    
    local assets=(
        "adb_root_android9-v2.0-android9.zip"
        "adb_root_android10-v2.0-android10.zip"
        "adb_root_android11-v2.0-android11.zip"
        "adb_root_android12-v2.0-android12.zip"
        "adb_root_universal-v2.0-universal.zip"
    )
    
    local missing_assets=()
    
    for asset in "${assets[@]}"; do
        if [ -f "$asset" ]; then
            local size=$(du -h "$asset" | cut -f1)
            echo -e "${GREEN}✓ Found: $asset ($size)${NC}"
        else
            echo -e "${RED}✗ Missing: $asset${NC}"
            missing_assets+=("$asset")
        fi
    done
    
    if [ ${#missing_assets[@]} -gt 0 ]; then
        echo -e "${YELLOW}Warning: Some assets are missing${NC}"
        echo -e "${YELLOW}Run: python generate_version_modules.py${NC}"
        return 1
    fi
    
    return 0
}

# Function to create GitHub release using GitHub CLI
create_github_release() {
    local version=$1
    local notes_file=$2
    
    echo -e "${BLUE}Creating GitHub release ${version}...${NC}"
    
    # Create release notes file
    create_release_notes "$version" > "$notes_file"
    
    if command -v gh &> /dev/null; then
        echo -e "${GREEN}Using GitHub CLI to create release...${NC}"
        
        # Create release with assets
        gh release create "$version" \
            --title "${PROJECT_NAME} ${version}" \
            --notes-file "$notes_file" \
            --repo "brucehe1026/adb_root_enhanced" \
            adb_root_*.zip
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ GitHub release created successfully!${NC}"
            echo -e "${BLUE}Release URL: ${REPO_URL}/releases/tag/${version}${NC}"
        else
            echo -e "${RED}✗ Failed to create GitHub release${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}GitHub CLI not available${NC}"
        echo -e "${BLUE}Manual release creation instructions:${NC}"
        echo "1. Go to: ${REPO_URL}/releases"
        echo "2. Click 'Create a new release'"
        echo "3. Tag version: ${version}"
        echo "4. Copy release notes from: ${notes_file}"
        echo "5. Upload all ZIP files as assets"
        echo "6. Publish release"
    fi
}

# Function to create git tag
create_git_tag() {
    local version=$1
    
    echo -e "${BLUE}Creating git tag ${version}...${NC}"
    
    # Check if tag already exists
    if git rev-parse "$version" >/dev/null 2>&1; then
        echo -e "${YELLOW}Tag ${version} already exists${NC}"
        read -p "Do you want to delete and recreate it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git tag -d "$version"
            git push origin ":refs/tags/$version" 2>/dev/null || true
        else
            return 1
        fi
    fi
    
    # Create annotated tag
    git tag -a "$version" -m "Release ${version} - Multi-version Android support with Android 10 fix"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Git tag created successfully${NC}"
        
        # Push tag to remote
        echo -e "${BLUE}Pushing tag to remote...${NC}"
        git push origin "$version"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Tag pushed to remote${NC}"
        else
            echo -e "${YELLOW}Warning: Could not push tag to remote${NC}"
        fi
    else
        echo -e "${RED}✗ Failed to create git tag${NC}"
        return 1
    fi
}

# Main execution
main() {
    echo -e "${BLUE}Starting release creation process...${NC}"
    echo
    
    # Check release assets
    if ! check_release_assets; then
        echo -e "${RED}Please generate missing assets before continuing${NC}"
        exit 1
    fi
    
    echo
    read -p "Do you want to create release ${CURRENT_VERSION}? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Release creation cancelled${NC}"
        exit 0
    fi
    
    # Create temporary notes file
    local notes_file="release_notes_${CURRENT_VERSION}.md"
    
    # Create git tag
    if create_git_tag "$CURRENT_VERSION"; then
        # Create GitHub release
        create_github_release "$CURRENT_VERSION" "$notes_file"
        
        # Cleanup
        rm -f "$notes_file"
        
        echo
        echo -e "${GREEN}✓ Release creation process completed!${NC}"
        echo -e "${BLUE}Check your release at: ${REPO_URL}/releases${NC}"
    else
        echo -e "${RED}✗ Release creation failed${NC}"
        rm -f "$notes_file"
        exit 1
    fi
}

# Run main function
main "$@"