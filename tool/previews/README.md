# Quick capture previews

`assets/quick_capture/*.png` (Settings > Panda > Quick capture) are rendered
from the real widget views and glyphs by `PreviewRender.swift`:

1. Temporarily add to the Runner target: this file,
   `ios/RedPandaControls/PandaWidget.swift` (Sources) and
   `ios/RedPandaControls/Assets.xcassets` (Resources).
2. Call `PreviewRender.runIfAsked()` first thing in
   `AppDelegate.application(_:didFinishLaunchingWithOptions:)`.
3. `flutter build ios --simulator --debug`, install, then
   `xcrun simctl launch booted ch.masdatos.redpanda -renderPreviews`.
4. Copy `<app data container>/Documents/previews/*.png` to
   `assets/quick_capture/` and undo steps 1 and 2.

Glyphs (`redpanda.note`, `.voice`, `.basket`) come from
`tool/glyphs/make_glyphs.py` (needs `pip install skia-pathops`).
