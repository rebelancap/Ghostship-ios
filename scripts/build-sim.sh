#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/spikes/gs-sim-build"
GS_O2R="$ROOT/oracle/build-cmake/ghostship.o2r"

[[ -d "$ROOT/vendor/Ghostship/.git" ]] || "$ROOT/scripts/bootstrap.sh"
"$ROOT/scripts/apply-overlay.sh"
[[ -f "$GS_O2R" ]] || "$ROOT/scripts/build-oracle.sh"

cmake --no-warn-unused-cli -S "$ROOT/vendor/Ghostship" -B "$BUILD" -GXcode \
    -DCMAKE_XCODE_ATTRIBUTE_STRIP_INSTALLED_PRODUCT=NO \
    -DCMAKE_SYSTEM_NAME=iOS -DPLATFORM=SIMULATORARM64 \
    -DCMAKE_OSX_SYSROOT=iphonesimulator \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=15.0 -DCMAKE_BUILD_TYPE:STRING=Release \
    -DDEPLOYMENT_TARGET=15.0 `# Xcode 27 rejects ios-cmake's default 13.0` \
    "-DSOH_REMOTE_CONSOLE=${SOH_REMOTE_CONSOLE:-ON}" \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED=NO \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED=NO \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY="" \
    -DUSE_SATELLA=OFF \
    "-DGS_O2R_PATH=$GS_O2R" \
    "-DGS_IOS_SHELL_DIR=$ROOT/app/ios"

cmake --build "$BUILD" --config Release --target Ghostship --parallel 6

APP="$BUILD/Release-iphonesimulator/Ghostship.app"
[[ -d "$APP" ]] || { echo "FATAL: expected app at $APP" >&2; exit 1; }
lipo -info "$APP/Ghostship"
[[ -f "$APP/ghostship.o2r" && -f "$APP/config.yml" && -d "$APP/assets" ]] || {
    echo "FATAL: bundle resources missing (o2r/config.yml/assets)" >&2; exit 1; }
echo "built (simulator): $APP"
