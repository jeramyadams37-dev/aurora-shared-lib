#!/data/data/com.termux/files/usr/bin/bash
#
# build_apk.sh — Standardized Termux-native Android build pipeline
# Automates the proven aapt2 -> javac -> d8 -> zipalign -> apksigner
# sequence from the AIScreenReader project, so it's reusable for any
# future native Android build without Android Studio.
#
# Usage:
#   chmod +x build_apk.sh
#   ./build_apk.sh <project_dir> <package_name>
#
# Requires: aapt2, d8, zipalign, apksigner available in $PATH
# (install via: pkg install aapt d8 zipalign apksigner -y — adjust as needed
# for whichever Termux package set you're using)

set -e

PROJECT_DIR="${1:-.}"
PACKAGE_NAME="${2:-com.example.app}"
OUT_DIR="$PROJECT_DIR/build"
UNSIGNED_APK="$OUT_DIR/app-unsigned.apk"
ALIGNED_APK="$OUT_DIR/app-aligned.apk"
SIGNED_APK="$OUT_DIR/app-release.apk"

echo "[build_apk] Building $PACKAGE_NAME from $PROJECT_DIR"
mkdir -p "$OUT_DIR"

echo "[build_apk] Step 1/5: aapt2 — compiling and linking resources"
aapt2 compile --dir "$PROJECT_DIR/res" -o "$OUT_DIR/compiled_resources.zip"
aapt2 link -o "$UNSIGNED_APK" \
  -I "$PREFIX/share/android-sdk/platforms/android-33/android.jar" \
  --manifest "$PROJECT_DIR/AndroidManifest.xml" \
  "$OUT_DIR/compiled_resources.zip"

echo "[build_apk] Step 2/5: javac — compiling Java sources"
mkdir -p "$OUT_DIR/classes"
javac -d "$OUT_DIR/classes" -cp "$PREFIX/share/android-sdk/platforms/android-33/android.jar" \
  $(find "$PROJECT_DIR/src" -name "*.java")

echo "[build_apk] Step 3/5: d8 — dexing compiled classes"
d8 --output "$OUT_DIR" $(find "$OUT_DIR/classes" -name "*.class")

echo "[build_apk] Step 4/5: zipalign — aligning APK"
zipalign -f -p 4 "$UNSIGNED_APK" "$ALIGNED_APK"

echo "[build_apk] Step 5/5: apksigner — signing APK"
apksigner sign --ks "$PROJECT_DIR/keystore.jks" --out "$SIGNED_APK" "$ALIGNED_APK"

echo "[build_apk] ✅ Build complete: $SIGNED_APK"
