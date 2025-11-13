#!/bin/bash
# GitHub Release Asset Management Script
# Helps organize and verify release assets for ADB Root Enhanced

set -e

# Configuration
PROJECT_NAME="ADB Root Enhanced"
CURRENT_VERSION="v2.0"
RELEASE_DIR="release_assets"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== ${PROJECT_NAME} Release Asset Manager ===${NC}"
echo

# Create release directory
mkdir -p "$RELEASE_DIR"

# Function to copy release assets
copy_release_assets() {
    echo -e "${BLUE}Copying release assets to ${RELEASE_DIR}/...${NC}"
    
    local assets=(
        "adb_root_android9-v2.0-android9.zip"
        "adb_root_android10-v2.0-android10.zip"
        "adb_root_android11-v2.0-android11.zip"
        "adb_root_android12-v2.0-android12.zip"
        "adb_root_universal-v2.0-universal.zip"
    )
    
    local copied_count=0
    
    for asset in "${assets[@]}"; do
        if [ -f "$asset" ]; then
            local size=$(du -h "$asset" | cut -f1)
            cp "$asset" "$RELEASE_DIR/"
            echo -e "${GREEN}✓ Copied: $asset ($size)${NC}"
            ((copied_count++))
        else
            echo -e "${RED}✗ Missing: $asset${NC}"
        fi
    done
    
    echo -e "${BLUE}Copied $copied_count/${#assets[@]} assets${NC}"
    return $(( ${#assets[@]} - copied_count ))
}

# Function to verify assets
verify_assets() {
    echo -e "${BLUE}Verifying release assets...${NC}"
    
    cd "$RELEASE_DIR"
    
    local total_size=0
    local file_count=0
    
    for file in *.zip; do
        if [ -f "$file" ]; then
            # Check ZIP integrity
            if unzip -t "$file" >/dev/null 2>&1; then
                local size=$(du -b "$file" | cut -f1)
                total_size=$((total_size + size))
                ((file_count++))
                echo -e "${GREEN}✓ Verified: $file ($(du -h "$file" | cut -f1))${NC}"
            else
                echo -e "${RED}✗ Corrupted: $file${NC}"
            fi
        fi
    done
    
    cd ..
    
    if [ $file_count -gt 0 ]; then
        echo -e "${GREEN}✓ Verified $file_count files ($(du -h "$RELEASE_DIR" | cut -f1) total)${NC}"
        return 0
    else
        echo -e "${RED}✗ No valid files found${NC}"
        return 1
    fi
}

# Function to generate checksums
generate_checksums() {
    echo -e "${BLUE}Generating checksums...${NC}"
    
    cd "$RELEASE_DIR"
    
    # Generate SHA256 checksums
    if command -v sha256sum &> /dev/null; then
        sha256sum *.zip > checksums_sha256.txt 2>/dev/null || true
        echo -e "${GREEN}✓ SHA256 checksums generated${NC}"
    fi
    
    # Generate MD5 checksums
    if command -v md5sum &> /dev/null; then
        md5sum *.zip > checksums_md5.txt 2>/dev/null || true
        echo -e "${GREEN}✓ MD5 checksums generated${NC}"
    fi
    
    # Generate file list with sizes
    ls -la *.zip > file_list.txt 2>/dev/null || true
    echo -e "${GREEN}✓ File list generated${NC}"
    
    cd ..
}

# Function to create release info
create_release_info() {
    echo -e "${BLUE}Creating release information...${NC}"
    
    cat > "$RELEASE_DIR/RELEASE_INFO.md" << EOF
# ${PROJECT_NAME} ${CURRENT_VERSION} Release Assets

Generated on: $(date)

## 📦 Module Files

| Module | Size | Description | Target |
|--------|------|-------------|--------|
EOF

    cd "$RELEASE_DIR"
    
    for file in *.zip; do
        if [ -f "$file" ]; then
            local size=$(du -h "$file" | cut -f1)
            local description=""
            local target=""
            
            case "$file" in
                *universal*)
                    description="Auto-detection with intelligent strategy selection"
                    target="All Android versions"
                    ;;
                *android9*)
                    description="Binary replacement approach"
                    target="Android 9 (API 28)"
                    ;;
                *android10*)
                    description="SELinux-only enhancement (preserves daemon)"
                    target="Android 10 (API 29)"
                    ;;
                *android11*)
                    description="Enhanced binary with minijail bypass"
                    target="Android 11 (API 30)"
                    ;;
                *android12*)
                    description="Comprehensive security bypass"
                    target="Android 12+ (API 31+)"
                    ;;
            esac
            
            echo "| \`$file\` | $size | $description | $target |" >> RELEASE_INFO.md
        fi
    done
    
    cat >> RELEASE_INFO.md << EOF

## 🎯 Download Recommendations

### For Most Users
**Use**: \`adb_root_universal-v2.0-universal.zip\`
- Auto-detects Android version
- Applies optimal strategy
- Safest choice for unknown devices

### For Known Android Versions
- **Android 9**: Use \`adb_root_android9-v2.0-android9.zip\`
- **Android 10**: Use \`adb_root_android10-v2.0-android10.zip\` (fixes ADB issues)
- **Android 11**: Use \`adb_root_android11-v2.0-android11.zip\`
- **Android 12+**: Use \`adb_root_android12-v2.0-android12.zip\`

## 🔧 Installation Steps

1. **Download** appropriate module
2. **Install via Magisk Manager** (Modules → Install from storage)
3. **Reboot device**
4. **Test functionality**:
   \`\`\`bash
   adb devices    # Check device detection
   adb root       # Enable root access
   adb shell id   # Verify root identity
   \`\`\`

## ⚠️ Important Notes

- **Android 10**: Always use specific module to avoid ADB detection failure
- **Android 11+**: Experimental support, feedback welcome
- **Backup First**: Always backup before installing modules
- **Test Compatibility**: Run \`test_adb_root_compatibility.sh\` first

## 📋 File Verification

Check file integrity using provided checksums:
- \`checksums_sha256.txt\` - SHA256 checksums
- \`checksums_md5.txt\` - MD5 checksums

---

**Repository**: https://github.com/brucehe1026/adb_root_enhanced  
**Issues**: https://github.com/brucehe1026/adb_root_enhanced/issues
EOF

    cd ..
    echo -e "${GREEN}✓ Release information created${NC}"
}

# Function to create GitHub upload script
create_upload_script() {
    echo -e "${BLUE}Creating GitHub upload script...${NC}"
    
    cat > upload_to_github.sh << 'EOF'
#!/bin/bash
# Upload release assets to GitHub

if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is required but not installed."
    echo "Install from: https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Please authenticate with GitHub CLI first:"
    echo "gh auth login"
    exit 1
fi

RELEASE_VERSION="v2.0"
ASSET_DIR="release_assets"

echo "Uploading assets to GitHub release ${RELEASE_VERSION}..."

# Check if release exists
if gh release view "$RELEASE_VERSION" --repo brucehe1026/adb_root_enhanced &> /dev/null; then
    echo "Release ${RELEASE_VERSION} exists, uploading assets..."
else
    echo "Release ${RELEASE_VERSION} does not exist."
    echo "Please create the release first via GitHub web interface or:"
    echo "./create_github_release.sh"
    exit 1
fi

# Upload assets
cd "$ASSET_DIR"
for file in *.zip *.md *.txt; do
    if [ -f "$file" ]; then
        echo "Uploading $file..."
        gh release upload "$RELEASE_VERSION" "$file" --repo brucehe1026/adb_root_enhanced
        if [ $? -eq 0 ]; then
            echo "✓ Uploaded $file"
        else
            echo "✗ Failed to upload $file"
        fi
    fi
done

echo "Upload complete!"
echo "Check release at: https://github.com/brucehe1026/adb_root_enhanced/releases/tag/${RELEASE_VERSION}"
EOF

    chmod +x upload_to_github.sh
    echo -e "${GREEN}✓ GitHub upload script created${NC}"
}

# Function to display summary
display_summary() {
    echo
    echo -e "${BLUE}=== Release Asset Package Summary ===${NC}"
    echo
    
    if [ -d "$RELEASE_DIR" ]; then
        echo -e "${GREEN}Release assets prepared in: $RELEASE_DIR/${NC}"
        echo
        echo "Files:"
        ls -lh "$RELEASE_DIR"/*.zip 2>/dev/null || echo "No ZIP files found"
        echo
        echo "Checksums:"
        ls -l "$RELEASE_DIR"/checksums_*.txt 2>/dev/null || echo "No checksum files"
        echo
        echo "Documentation:"
        ls -l "$RELEASE_DIR"/*.md 2>/dev/null || echo "No documentation files"
        echo
        echo -e "${BLUE}Total package size: $(du -h "$RELEASE_DIR" | cut -f1)${NC}"
        echo
        echo -e "${YELLOW}Next steps:${NC}"
        echo "1. Create GitHub release at: https://github.com/brucehe1026/adb_root_enhanced/releases"
        echo "2. Upload all files from $RELEASE_DIR/"
        echo "3. Or run: ./upload_to_github.sh (requires GitHub CLI)"
    else
        echo -e "${RED}No release assets prepared${NC}"
    fi
}

# Main execution
main() {
    # Copy assets
    if ! copy_release_assets; then
        echo -e "${RED}Some assets are missing. Generate them first:${NC}"
        echo "python generate_version_modules.py"
        exit 1
    fi
    
    # Verify assets
    if ! verify_assets; then
        echo -e "${RED}Asset verification failed${NC}"
        exit 1
    fi
    
    # Generate checksums
    generate_checksums
    
    # Create release info
    create_release_info
    
    # Create upload script
    create_upload_script
    
    # Display summary
    display_summary
}

# Run main function
main "$@"