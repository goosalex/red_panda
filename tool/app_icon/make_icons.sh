#!/bin/sh
# Regenerates ios/Runner/Assets.xcassets/AppIcon.appiconset from the mascot painter.
# Usage: make icon   (or: sh tool/app_icon/make_icons.sh)
set -eu
cd "$(dirname "$0")/../.."

WORK=build/app_icon
SET=ios/Runner/Assets.xcassets/AppIcon.appiconset
mkdir -p "$WORK"

ICON_OUT="$PWD/$WORK/icon_rgba.png" flutter test tool/app_icon/render_app_icon_test.dart

# App Store icons must not have an alpha channel: flatten through JPEG (max quality).
sips -s format jpeg -s formatOptions 100 "$WORK/icon_rgba.png" --out "$WORK/icon.jpg" >/dev/null
sips -s format png "$WORK/icon.jpg" --out "$WORK/icon_1024.png" >/dev/null

# Every PNG in the icon set is named Icon-App-<points>x<points>@<scale>x.png.
for f in "$SET"/Icon-App-*.png; do
  name=$(basename "$f")
  pts=$(echo "$name" | sed -E 's/Icon-App-([0-9.]+)x.*/\1/')
  scale=$(echo "$name" | sed -E 's/.*@([0-9])x\.png/\1/')
  px=$(echo "$pts * $scale" | bc | sed -E 's/\.0+$//')
  sips -z "$px" "$px" "$WORK/icon_1024.png" --out "$f" >/dev/null
  echo "$name -> ${px}px"
done
