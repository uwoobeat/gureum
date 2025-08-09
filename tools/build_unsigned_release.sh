#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.."

echo "Building unsigned release version..."

# Release 구성에서 서명 없이 빌드
xcodebuild -project Gureum.xcodeproj \
    -scheme OSX \
    -configuration Release \
    -destination "platform=macOS" \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    clean build

echo "Build completed successfully!"
echo "Built app location: ~/Library/Developer/Xcode/DerivedData/*/Build/Products/Release/Gureum.app"