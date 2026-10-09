#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build-ios"
GS_O2R="$ROOT/oracle/build-cmake/ghostship.o2r"
TEAM="${GS_IOS_TEAM:?set your Apple Developer team id (see README)}"

if [[ -d "$BUILD/Ghostship.xcarchive" ]]; then
    echo "build dir carries an xcarchive (post-export poison) — wiping $BUILD"
    rm -rf "$BUILD"
fi

[[ -d "$ROOT/vendor/Ghostship/.git" ]] || "$ROOT/scripts/bootstrap.sh"
"$ROOT/scripts/apply-overlay.sh"
[[ -f "$GS_O2R" ]] || "$ROOT/scripts/build-oracle.sh"

cmake --no-warn-unused-cli -S "$ROOT/vendor/Ghostship" -B "$BUILD" -GXcode \
    -DCMAKE_XCODE_ATTRIBUTE_STRIP_INSTALLED_PRODUCT=NO \
    -DCMAKE_SYSTEM_NAME=iOS -DPLATFORM=OS64 \
    -DCMAKE_OSX_SYSROOT=iphoneos \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=15.0 -DCMAKE_BUILD_TYPE:STRING=Release \
    -DDEPLOYMENT_TARGET=15.0 `# Xcode 27 rejects ios-cmake's default 13.0` \
    "-DSOH_REMOTE_CONSOLE=${SOH_REMOTE_CONSOLE:-ON}" \
    "-DGS_O2R_PATH=$GS_O2R" \
    "-DGS_IOS_SHELL_DIR=$ROOT/app/ios" \
    -DGS_IOS_BUNDLE_IDENTIFIER=com.rebelancap.ghostship \
    "-DGS_IOS_DEVELOPMENT_TEAM=$TEAM"

cmake --build "$BUILD" --config Release --target Ghostship --parallel 6 -- -allowProvisioningUpdates

APP="$BUILD/Release-iphoneos/Ghostship.app"
[[ -d "$APP" ]] || { echo "FATAL: expected app at $APP" >&2; exit 1; }
lipo -info "$APP/Ghostship"
[[ -f "$APP/ghostship.o2r" && -f "$APP/config.yml" && -d "$APP/assets" ]] || {
    echo "FATAL: bundle resources missing (o2r/config.yml/assets)" >&2; exit 1; }
codesign -dv "$APP" 2>&1 | sed -n '1,3p'
echo "built: $APP"
