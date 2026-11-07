#!/bin/zsh
# Records the iOS Settings walkthroughs and turns them into app assets
# (assets/walkthroughs). Usage, from the repo root:
#   flutter build ios --simulator --debug
#   tool/walkthroughs/record.sh [lang ...]      (default: every app language)
# WALK_TESTS="testHomeScreenWidget …" records only those walkthroughs.
# Each language is recorded on a fresh clone of a clean base simulator, so the
# Settings app always looks like it does for someone setting up Red Panda.
# Re-run for every new app language (see lib/l10n/README.md).
set -euo pipefail
cd "${0:A:h}"
APP_PATH=${APP_PATH:-../../build/ios/iphonesimulator/Runner.app}
BUNDLE=ch.masdatos.redpanda
BASE="RP Walkthroughs Base"
RAW=${WALK_RAW:-$PWD/raw}
if (( $# )); then LANGS=($@); else LANGS=(en fr de es it ja ar); fi
mkdir -p "$RAW"
TESTS="-only-testing:Walkthroughs/Recorder"
[[ -n "${WALK_TESTS:-}" ]] && TESTS=$(for t in ${=WALK_TESTS}; do printf -- '-only-testing:Walkthroughs/Recorder/%s ' $t; done)

udid() { xcrun simctl list devices -j | python3 -c "import json,sys; print(next((d['udid'] for r in json.load(sys.stdin)['devices'].values() for d in r if d['name']=='$1'), ''))"; }
gone() { local u=$(udid "$1"); [[ -n "$u" ]] && { xcrun simctl shutdown "$u" 2>/dev/null || true; xcrun simctl delete "$u"; }; true; }
locale_of() { case $1 in en) echo en_GB;; fr) echo fr_FR;; de) echo de_DE;; es) echo es_MX;; it) echo it_IT;; ja) echo ja_JP;; ar) echo ar_LB;; *) echo $1;; esac; }
keyboard_of() { case $1 in
  fr) echo "fr_FR@sw=AZERTY;hw=Automatic";; de) echo "de_DE@sw=QWERTZ;hw=Automatic";;
  es) echo "es_MX@sw=QWERTY-Spanish;hw=Automatic";; it) echo "it_IT@sw=QWERTY;hw=Automatic";;
  en) echo "en_GB@sw=QWERTY;hw=Automatic";; *) echo "en_US@sw=QWERTY;hw=Automatic";; esac; }
run() { xcodebuild test -project Walkthroughs.xcodeproj -scheme Walkthroughs -destination "id=$1" ${=2} > "$3" 2>&1 || { echo "failed: see $3"; grep -m3 " error:" "$3"; return 1; }; }

# 1. A clean base: Red Panda installed, location "While Using", microphone on,
#    speech recognition asked for once.
gone "$BASE"
B=$(xcrun simctl create "$BASE" com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro)
xcrun simctl boot "$B"; xcrun simctl bootstatus "$B" >/dev/null
xcrun simctl install "$B" "$APP_PATH"
# iOS only lists a new app's controls after a restart.
xcrun simctl shutdown "$B"; xcrun simctl boot "$B"; xcrun simctl bootstatus "$B" >/dev/null
# "Always" makes Location Services list Red Panda; then back to "While Using",
# so the walkthrough ends on choosing "Always".
xcrun simctl privacy "$B" grant location-always $BUNDLE
xcrun simctl privacy "$B" grant location $BUNDLE
xcrun simctl privacy "$B" grant microphone $BUNDLE
run "$B" "-only-testing:Walkthroughs/Prepare" "$RAW.prepare.log"
xcrun simctl shutdown "$B"

# 2. Each language on its own clone.
for L in $LANGS; do
  C=$(xcrun simctl clone "$B" "RP Walkthroughs $L")
  xcrun simctl boot "$C"; xcrun simctl bootstatus "$C" >/dev/null
  # The whole simulator in that language, keyboard included (ja and ar keep a
  # Latin keyboard: "Red" is typed into the controls search), then reboot.
  xcrun simctl spawn "$C" defaults write -g AppleLanguages -array "$L"
  xcrun simctl spawn "$C" defaults write -g AppleLocale "$(locale_of $L)"
  xcrun simctl spawn "$C" defaults write -g AppleKeyboards -array "$(keyboard_of $L)"
  xcrun simctl spawn "$C" defaults write -g AppleKeyboardsExpanded -int 1
  xcrun simctl shutdown "$C"; xcrun simctl boot "$C"; xcrun simctl bootstatus "$C" >/dev/null
  xcrun simctl status_bar "$C" override --time 9:41 --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3
  TEST_RUNNER_WALK_LANG=$L TEST_RUNNER_WALK_OUT=$RAW run "$C" "$TESTS" "$RAW.$L.log" || { gone "RP Walkthroughs $L"; exit 1; }
  gone "RP Walkthroughs $L"
  echo "$L recorded"
done
gone "$BASE"
python3 build_assets.py "$RAW" ../../assets/walkthroughs
