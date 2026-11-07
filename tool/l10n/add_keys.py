"""Adds keys to every lib/l10n/app_<lang>.arb.

usage: python3 tool/l10n/add_keys.py keys.json
keys.json: {"key": {"en": "...", "fr": "...", ..., "@": {optional ARB metadata}}}
Existing keys are overwritten; key order is kept, new keys are appended.
"""
import json
import sys

LANGS = ["en", "fr", "de", "es", "it", "ja", "ar"]

keys = json.load(open(sys.argv[1]))
for lang in LANGS:
    path = f"lib/l10n/app_{lang}.arb"
    arb = json.load(open(path))
    for k, v in keys.items():
        missing = [l for l in LANGS if l not in v]
        if missing:
            sys.exit(f"{k}: missing {missing}")
        arb[k] = v[lang]
        if lang == "en" and "@" in v:
            arb[f"@{k}"] = v["@"]
    with open(path, "w") as f:
        json.dump(arb, f, ensure_ascii=False, indent=2)
        f.write("\n")
print(f"{len(keys)} keys x {len(LANGS)} languages")
