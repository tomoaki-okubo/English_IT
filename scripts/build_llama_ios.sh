#!/bin/bash
# Build llama.cpp xcframework for iOS (arm64 device + arm64 simulator)
# This script clones the matching llama.cpp commit and builds the native libraries.
#
# Prerequisites:
#   brew install cmake
#   Xcode with Command Line Tools
#   Valid Apple Developer Team ID (L5F6GAY9Q6)

set -e

PACKAGE_DIR="$HOME/.pub-cache/hosted/pub.dev/llama_cpp_dart-0.2.2"
LLAMA_CPP_DIR="$PACKAGE_DIR/src/llama.cpp"
DARWIN_DIR="$PACKAGE_DIR/darwin"
IOS_DIR="$PACKAGE_DIR/ios"
DEV_TEAM="L5F6GAY9Q6"
LLAMA_CPP_COMMIT="4ffc47cb2001e7d523f9ff525335bbe34b1a2858"

echo "================================================"
echo "Building llama.cpp xcframework for iOS"
echo "Team ID: $DEV_TEAM"
echo "llama.cpp commit: $LLAMA_CPP_COMMIT"
echo "================================================"
echo ""

# Check cmake
if ! command -v cmake &>/dev/null; then
  echo "Error: cmake not found. Run: brew install cmake"
  exit 1
fi
echo "cmake: $(cmake --version | head -1)"
echo ""

# Clone llama.cpp at matching commit if not present
if [ ! -f "$LLAMA_CPP_DIR/CMakeLists.txt" ]; then
  echo "Cloning llama.cpp at commit $LLAMA_CPP_COMMIT ..."
  mkdir -p "$LLAMA_CPP_DIR"
  git clone https://github.com/ggml-org/llama.cpp.git "$LLAMA_CPP_DIR"
  cd "$LLAMA_CPP_DIR"
  git checkout "$LLAMA_CPP_COMMIT"
  cd "$PACKAGE_DIR"
  echo "llama.cpp cloned OK"
else
  echo "llama.cpp source already present."
fi
echo ""

# Build for iOS Simulator ARM64
echo "Building for SIMULATORARM64..."
cd "$DARWIN_DIR"
bash run_build.sh "$LLAMA_CPP_DIR" "$DEV_TEAM" SIMULATORARM64 2>&1 | tail -20

echo ""
echo "Fixing rpaths for SIMULATORARM64..."
bash fix_rpath.sh SIMULATORARM64

echo ""
echo "Building for iOS Device OS64..."
bash run_build.sh "$LLAMA_CPP_DIR" "$DEV_TEAM" OS64 2>&1 | tail -20

echo ""
echo "Fixing rpaths for OS64..."
bash fix_rpath.sh OS64

echo ""
echo "Creating Llama.xcframework..."
cd "$PACKAGE_DIR"
bash darwin/create_xcframework.sh

echo ""
echo "Copying Llama.xcframework to ios/ folder..."
rm -rf "$IOS_DIR/Llama.xcframework"
cp -R "$PACKAGE_DIR/Llama.xcframework" "$IOS_DIR/Llama.xcframework"

echo ""
echo "================================================"
echo "SUCCESS! Now run:"
echo ""
echo "  cd /Users/ookubotomoakira/work/brse_ai_coach"
echo "  flutter clean"
echo "  flutter pub get"
echo "  cd ios && pod install && cd .."
echo "  flutter run"
echo "================================================"
