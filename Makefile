# Red Panda local iOS pipeline (macOS + Xcode 26 + Flutter stable).
#   make doctor     check toolchain
#   make check      analyze + unit tests
#   make sim        build for the iOS Simulator (no signing needed)
#   make run-sim    build and launch on a booted simulator
#   make device     signed release build for a connected iPhone
#   make run-device install + run on a connected iPhone
#   make ipa        App Store build -> build/ios/ipa/*.ipa
#   make upload     upload the ipa to App Store Connect / TestFlight
FLUTTER ?= flutter

.PHONY: doctor setup check sim run-sim device run-device ipa upload clean

doctor:
	$(FLUTTER) doctor -v
	xcodebuild -version

setup:
	$(FLUTTER) pub get
	@test -f ios/Flutter/Signing.xcconfig || (cp ios/Flutter/Signing.xcconfig.example ios/Flutter/Signing.xcconfig && echo ">> Edit ios/Flutter/Signing.xcconfig and set DEVELOPMENT_TEAM")

check: setup
	$(FLUTTER) analyze
	$(FLUTTER) test

sim: setup
	$(FLUTTER) build ios --simulator --debug

run-sim: setup
	open -a Simulator
	$(FLUTTER) run -d "$$(xcrun simctl list devices booted | grep -m1 -oE '[0-9A-F-]{36}')"

device: setup
	$(FLUTTER) build ios --release

run-device: setup
	$(FLUTTER) run --release

ipa: check
	$(FLUTTER) build ipa --release

# Needs an App Store Connect API key: put AuthKey_<ID>.p8 in ~/.appstoreconnect/private_keys/
# and export ASC_KEY_ID and ASC_ISSUER_ID.
upload:
	@test -n "$(ASC_KEY_ID)" -a -n "$(ASC_ISSUER_ID)" || (echo "Set ASC_KEY_ID and ASC_ISSUER_ID"; exit 1)
	xcrun altool --upload-app -t ios -f "$$(ls build/ios/ipa/*.ipa | head -1)" \
		--apiKey "$(ASC_KEY_ID)" --apiIssuer "$(ASC_ISSUER_ID)"

clean:
	$(FLUTTER) clean
