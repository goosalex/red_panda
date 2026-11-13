"""Contact sheet of screenshots, to look them over: contact.py out.png a.png b.png …"""
import sys
from PIL import Image
out, files = sys.argv[1], sys.argv[2:]
ims = [Image.open(f) for f in files]
h = 900
ims = [im.resize((round(im.width * h / im.height), h)) for im in ims]
c = Image.new("RGB", (sum(i.width for i in ims) + 10 * (len(ims) - 1), h), "white")
x = 0
for im in ims:
    c.paste(im, (x, 0)); x += im.width + 10
c.save(out)
