#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$0")"

echo "Installing unsigned release build..."

# 빌드된 앱 찾기 - 여러 경로 시도
POSSIBLE_PATHS=(
    "~/Library/Developer/Xcode/DerivedData/Gureum-*/Build/Products/Release/Gureum.app"
    "$SCRIPT_DIR/../build/Release/Gureum.app"
    "$SCRIPT_DIR/../Release/Gureum.app"
)

APP_PATH=""
for path in "${POSSIBLE_PATHS[@]}"; do
    # 글로브 패턴 확장
    expanded_path=$(eval echo "$path")
    if [ -d "$expanded_path" ]; then
        APP_PATH="$expanded_path"
        break
    fi
done

if [ -z "$APP_PATH" ]; then
    echo "Error: Release build not found in any of these locations:"
    for path in "${POSSIBLE_PATHS[@]}"; do
        echo "  - $(eval echo "$path")"
    done
    echo "Please run ./build_unsigned_release.sh first"
    exit 1
fi

echo "Found app at: $APP_PATH"

# 기존 입력기 종료
sudo killall Gureum 2>/dev/null || true

# Input Methods 디렉터리에 설치
sudo rm -rf "/Library/Input Methods/Gureum.app"
sudo cp -R "$APP_PATH" "/Library/Input Methods/"

echo "Installation completed!"
echo "Please configure the input method in System Preferences → Keyboard → Input Sources"