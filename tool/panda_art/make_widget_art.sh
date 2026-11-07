#!/bin/sh
# Renders the mascot poses into the RedPandaControls widget asset catalog:
# PandaSleeping / PandaCurious / PandaExcited / PandaSad image sets
# (120x120 pt, @2x and @3x, transparent background).
# Usage: sh tool/panda_art/make_widget_art.sh
set -eu
cd "$(dirname "$0")/../.."

WORK="$PWD/build/panda_art"
CATALOG=ios/RedPandaControls/Assets.xcassets
rm -rf "$WORK"
mkdir -p "$WORK" "$CATALOG"

PANDA_OUT="$WORK" PANDA_SCALES=2,3 flutter test tool/panda_art/render_panda_test.dart

if [ ! -f "$CATALOG/Contents.json" ]; then
  cat > "$CATALOG/Contents.json" <<'JSON'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
JSON
fi

for pose in sleeping curious excited sad; do
  name="Panda$(echo "$pose" | cut -c1 | tr '[:lower:]' '[:upper:]')$(echo "$pose" | cut -c2-)"
  set_dir="$CATALOG/$name.imageset"
  mkdir -p "$set_dir"
  rm -f "$set_dir"/*.png
  cp "$WORK/$pose@2x.png" "$set_dir/$name@2x.png"
  cp "$WORK/$pose@3x.png" "$set_dir/$name@3x.png"
  cat > "$set_dir/Contents.json" <<JSON
{
  "images" : [
    {
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "$name@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "$name@3x.png",
      "idiom" : "universal",
      "scale" : "3x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
JSON
  echo "$set_dir"
done
