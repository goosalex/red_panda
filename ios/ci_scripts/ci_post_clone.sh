#!/bin/sh
# Xcode Cloud runs this right after cloning the repository (it looks for
# ci_scripts/ next to the Xcode project). Xcode Cloud has no Flutter, so this
# installs it and generates what the Xcode project needs:
# ios/Flutter/Generated.xcconfig and the Swift package for the plugins.
#
# Workflow environment variables (Xcode > Manage Workflows > Environment):
#   TEAM_ID  optional, your 10-character Apple team id, if signing asks for one.
set -e

# Keep in step with the Flutter used locally (`flutter --version`).
FLUTTER_VERSION=3.47.9

cd "$CI_PRIMARY_REPOSITORY_PATH"

if [ ! -x "$HOME/flutter/bin/flutter" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 --branch "$FLUTTER_VERSION" "$HOME/flutter"
fi
export PATH="$HOME/flutter/bin:$PATH"

flutter config --no-analytics
flutter config --enable-swift-package-manager
flutter precache --ios
flutter pub get

if [ -n "$TEAM_ID" ]; then
  echo "DEVELOPMENT_TEAM = $TEAM_ID" > ios/Flutter/Signing.xcconfig
fi

# TestFlight needs a new build number for every upload: use Xcode Cloud's.
flutter build ios --config-only --release --no-codesign --build-number "${CI_BUILD_NUMBER:-1}"
