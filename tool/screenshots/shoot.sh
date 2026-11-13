#!/bin/zsh
# App Store screenshots: Red Panda on sample notes (seed.py), per language, on
# a 6.9" iPhone (1320 x 2868) and a 13" iPad (2064 x 2752), into
# appstore/screenshots/<App Store locale>/. Usage, from the repo root:
#   tool/screenshots/shoot.sh [lang ...]        (default: every app language)
# It builds the app with --dart-define=SHOT_TIME=09:41 (lib/platform/clock.dart),
# so the app shows the same time as the status bar; APP_PATH=… skips the build.
# DEVICES="iphone" or "ipad" shoots only one of them. The UI steps are in
# tool/walkthroughs/Walkthroughs/StoreShots.swift. Uses two temporary
# simulators ("RP Shots iPhone", "RP Shots iPad") and deletes them at the end.
set -euo pipefail
cd "${0:A:h}/../.."
REPO=$PWD
export SHOT_TIME=09:41
if [[ -z "${APP_PATH:-}" ]]; then
  flutter build ios --simulator --debug --dart-define=SHOT_TIME=$SHOT_TIME > build/shots.build.log 2>&1 || { tail -5 build/shots.build.log; exit 1; }
  APP_PATH=$REPO/build/ios/iphonesimulator/Runner.app
fi
BUNDLE=ch.masdatos.redpanda
GROUP=group.ch.masdatos.redpanda
if (( $# )); then LANGS=($@); else LANGS=(en fr de es it ja ar); fi
DEVICES=(${=DEVICES:-iphone ipad})
RUNTIME=$(xcrun simctl list runtimes | grep -o "com.apple.CoreSimulator.SimRuntime.iOS-18-[0-9]*" | tail -1)

udid() { xcrun simctl list devices -j | python3 -c "import json,sys; print(next((d['udid'] for r in json.load(sys.stdin)['devices'].values() for d in r if d['name']=='$1'), ''))"; }
gone() { local u=$(udid "$1"); [[ -n "$u" ]] && { xcrun simctl shutdown "$u" 2>/dev/null || true; xcrun simctl delete "$u"; }; true; }
type_of() { case $1 in iphone) echo com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro-Max;;
  ipad) echo com.apple.CoreSimulator.SimDeviceType.iPad-Pro-13-inch-M4-8GB;; esac; }
locale_of() { case $1 in en) echo en_GB;; fr) echo fr_FR;; de) echo de_DE;; es) echo es_MX;; it) echo it_IT;; ja) echo ja_JP;; ar) echo ar_LB;; esac; }
store_of() { case $1 in en) echo en-GB;; fr) echo fr-FR;; de) echo de-DE;; es) echo es-MX;; it) echo it;; ja) echo ja;; ar) echo ar-SA;; esac; }
labels() {  # the app's own button texts in language $1, as JSON
  python3 - "$1" "$(locale_of $1)" <<'PY'
import json, re, sys
lang, locale = sys.argv[1:3]
a = json.load(open(f"lib/l10n/app_{lang}.arb"))
basket = re.search(r"other\{(.*?)\{count\}", a["basketSemantics"]).group(1).strip()
print(json.dumps({"lang": lang, "locale": locale, "record": a["recordVoice"],
                  "settings": a["settings"], "privacy": a["settingsPrivacy"], "basket": basket}, ensure_ascii=False))
PY
}

for D in $DEVICES; do
  NAME="RP Shots ${(C)D}"
  [[ $D == ipad ]] && NAME="RP Shots iPad" || NAME="RP Shots iPhone"
  gone "$NAME"
  S=$(xcrun simctl create "$NAME" "$(type_of $D)" "$RUNTIME")
  for L in $LANGS; do
    xcrun simctl boot "$S" 2>/dev/null || true
    xcrun simctl spawn "$S" defaults write -g AppleLanguages -array "$L"
    xcrun simctl spawn "$S" defaults write -g AppleLocale "$(locale_of $L)"
    xcrun simctl shutdown "$S"; xcrun simctl boot "$S"
    sleep 20  # first boots settle (bootstatus can hang on a fresh device)
    xcrun simctl status_bar "$S" override --time 9:41 --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3
    xcrun simctl uninstall "$S" $BUNDLE 2>/dev/null || true
    xcrun simctl install "$S" "$APP_PATH"
    xcrun simctl privacy "$S" grant location-always $BUNDLE
    xcrun simctl privacy "$S" grant microphone $BUNDLE
    python3 tool/screenshots/seed.py "$(xcrun simctl get_app_container "$S" $BUNDLE $GROUP)" "$L"
    OUT="$REPO/appstore/screenshots/$(store_of $L)"
    mkdir -p "$OUT"; rm -f "$OUT"/${D}_*.png(N)
    LOG="$REPO/build/shots.$D.$L.log"
    ( cd tool/walkthroughs && TEST_RUNNER_SHOT_OUT="$OUT" TEST_RUNNER_SHOT_PREFIX=$D TEST_RUNNER_SHOT_LABELS="$(cd $REPO && labels $L)" \
        xcodebuild test -project Walkthroughs.xcodeproj -scheme Walkthroughs -destination "id=$S" \
        -only-testing:Walkthroughs/StoreShots > "$LOG" 2>&1 ) || { echo "$D $L failed: see $LOG"; grep -m3 "error" "$LOG"; exit 1; }
    echo "$D $L: ${#${(f)"$(ls "$OUT"/${D}_*.png(N))"}} shots"
  done
  gone "$NAME"
done
# English (U.S.) uses the same pictures as English (U.K.).
if [[ -d appstore/screenshots/en-GB ]]; then rm -rf appstore/screenshots/en-US; cp -R appstore/screenshots/en-GB appstore/screenshots/en-US; fi
