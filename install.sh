#!/bin/bash
set -e

APP_NAME="SecretaryTasks"
APP_DIR="$HOME/Applications/${APP_NAME}.app"
CONTENTS_DIR="${APP_DIR}/Contents"

echo "Building release..."
swift build -c release

echo "Installing to ${APP_DIR}..."
mkdir -p "${CONTENTS_DIR}/MacOS" "${CONTENTS_DIR}/Resources"

cp .build/release/${APP_NAME} "${CONTENTS_DIR}/MacOS/${APP_NAME}"
chmod +x "${CONTENTS_DIR}/MacOS/${APP_NAME}"

# App icon
cp Sources/SecretaryTasks/Resources/AppIcon.icns "${CONTENTS_DIR}/Resources/AppIcon.icns" 2>/dev/null || true

# Info.plist (only if not exists or force update)
cat > "${CONTENTS_DIR}/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>SecretaryTasks</string>
    <key>CFBundleDisplayName</key>
    <string>Secretary Tasks</string>
    <key>CFBundleIdentifier</key>
    <string>com.rootstack.secretary-tasks</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleExecutable</key>
    <string>SecretaryTasks</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

# NOTE: Do NOT re-sign on update. Re-signing invalidates Accessibility permission.
# Only sign on first install when no signature exists.
if ! codesign -v "${APP_DIR}" 2>/dev/null; then
    echo "Signing (first time)..."
    codesign --force --sign - "${APP_DIR}"
    echo ""
    echo "*** Grant Accessibility permission: ***"
    echo "  System Settings > Privacy & Security > Accessibility > SecretaryTasks ON"
    echo ""
fi

echo "Done. Launch with: open ${APP_DIR}"
