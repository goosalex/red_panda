#!/usr/bin/env python3
"""Turns recorder output (raw/<lang>/<id>/frames.json + PNGs) into app assets:
small JPEGs in assets/walkthroughs/ (<lang>_<id>_<n>.jpg, one flat folder so
pubspec.yaml needs one line) and one index,
assets/walkthroughs/walkthroughs.json: {id: {lang: [frame, ...]}}.
A frame is {"image", "tap": {x, y}} or {"image", "swipe": {from, to}} with
normalised coordinates, plus the tapped "label" in that language; the last
frame of each walkthrough has neither (it shows the result)."""
import json, pathlib, subprocess, sys

from PIL import Image  # pip install pillow

raw, out = map(pathlib.Path, sys.argv[1:3])


CONTROLS = json.loads((pathlib.Path(__file__).parent / '../../ios/RedPandaControls/Localizable.xcstrings').read_text())['strings']


def clean(label, lang):
    """The name as the user reads it: without a row's count after a comma
    (",", Arabic "،", Japanese "、") or bidi marks. iOS keeps a control's name
    in the language it first saw, so Red Panda's own controls are named from
    their String Catalog instead."""
    for mark in '\u200f\u200e\u2068\u2069':
        label = label.replace(mark, '')
    for comma in (',', '،', '、'):
        label = label.split(comma)[0]
    label = label.strip()
    entry = CONTROLS.get(label)
    if entry and lang != 'en':
        label = entry['localizations'][lang]['stringUnit']['value']
    return label


def cut_row(png, hide):
    """Removes a row (the test runner's own app) by moving what is below it up;
    the freed strip above the home indicator gets the page background."""
    im = Image.open(png).convert('RGB')
    w, h = im.size
    top, rh = int(hide['y'] * h), int(round(hide['h'] * h))
    end = h - int(0.045 * h)  # leave the home indicator where it is
    if top < 0 or top + rh >= end:
        return png  # not on screen
    below = im.crop((0, top + rh, w, end))
    im.paste(below, (0, top))
    bg = im.getpixel((4, end - rh - 2))
    im.paste(bg, (0, end - rh, w, end))
    out = png.with_suffix('.cut.png')
    im.save(out)
    return out

WIDTH, QUALITY = 450, 62
index = {}
if (out / 'walkthroughs.json').exists():
    index = json.loads((out / 'walkthroughs.json').read_text())
for meta in sorted(raw.glob('*/*/frames.json')):
    rec = json.loads(meta.read_text())
    lang, wid = rec['lang'], rec['id']
    out.mkdir(parents=True, exist_ok=True)
    for old in out.glob(f'{lang}_{wid}_*.jpg'):
        old.unlink()
    frames = []
    for f in rec['frames']:
        jpg = f"{lang}_{wid}_{f['image'].replace('.png', '.jpg')}"
        src = meta.parent / f['image']
        if 'hide' in f:
            src = cut_row(src, f.pop('hide'))
        subprocess.run(['sips', '-s', 'format', 'jpeg', '-s', 'formatOptions', str(QUALITY), '-Z', str(WIDTH * 2622 // 1206),
                        str(src), '--out', str(out / jpg)], check=True, capture_output=True)
        if 'label' in f:
            f['label'] = clean(f['label'], lang)
        frames.append({**f, 'image': jpg})
    index.setdefault(wid, {})[lang] = frames
out.mkdir(parents=True, exist_ok=True)
(out / 'walkthroughs.json').write_text(json.dumps(index, ensure_ascii=False, indent=1, sort_keys=True) + '\n')
size = sum(p.stat().st_size for p in out.rglob('*.jpg'))
print(f'{sum(len(v) for v in index.values())} walkthroughs, {size // 1024} KB')
