"""Builds Red Panda's custom SF Symbols (Xcode .symbolset templates).

Shapes are drawn in a 100 x 100 box (y down), combined with path booleans,
then placed on the Regular-M glyph of an SF Symbols template. Layers:
the action (pencil, mic, basket) is hierarchical primary, the little panda
behind it secondary (rendered lighter), with a gap cut around the action.

usage: python make_glyphs.py OUT_DIR [PREVIEW_DIR]
"""
import json
import math
import os
import sys

import pathops

K = 0.5522847498  # cubic circle constant


def ellipse(cx, cy, rx, ry):
    p = pathops.Path()
    p.moveTo(cx + rx, cy)
    p.cubicTo(cx + rx, cy + ry * K, cx + rx * K, cy + ry, cx, cy + ry)
    p.cubicTo(cx - rx * K, cy + ry, cx - rx, cy + ry * K, cx - rx, cy)
    p.cubicTo(cx - rx, cy - ry * K, cx - rx * K, cy - ry, cx, cy - ry)
    p.cubicTo(cx + rx * K, cy - ry, cx + rx, cy - ry * K, cx + rx, cy)
    p.close()
    return p


def circle(cx, cy, r):
    return ellipse(cx, cy, r, r)


def poly(pts):
    p = pathops.Path()
    p.moveTo(*pts[0])
    for q in pts[1:]:
        p.lineTo(*q)
    p.close()
    return p


def rrect(x, y, w, h, r):
    r = min(r, w / 2, h / 2)
    p = pathops.Path()
    p.moveTo(x + r, y)
    p.lineTo(x + w - r, y)
    p.cubicTo(x + w - r + r * K, y, x + w, y + r - r * K, x + w, y + r)
    p.lineTo(x + w, y + h - r)
    p.cubicTo(x + w, y + h - r + r * K, x + w - r + r * K, y + h, x + w - r, y + h)
    p.lineTo(x + r, y + h)
    p.cubicTo(x + r - r * K, y + h, x, y + h - r + r * K, x, y + h - r)
    p.lineTo(x, y + r)
    p.cubicTo(x, y + r - r * K, x + r - r * K, y, x + r, y)
    p.close()
    return p


def op(a, b, kind):
    return pathops.op(a, b, kind, fix_winding=True)


def union(*ps):
    out = ps[0]
    for q in ps[1:]:
        out = op(out, q, pathops.PathOp.UNION)
    return out


def minus(a, b):
    return op(a, b, pathops.PathOp.DIFFERENCE)


def inter(a, b):
    return op(a, b, pathops.PathOp.INTERSECTION)


def shrink_triangle(pts, d):
    """Offsets a triangle inwards by d (scale about the incentre)."""
    (ax, ay), (bx, by), (cx, cy) = pts
    a = math.dist((bx, by), (cx, cy))
    b = math.dist((ax, ay), (cx, cy))
    c = math.dist((ax, ay), (bx, by))
    s = a + b + c
    ix, iy = (a * ax + b * bx + c * cx) / s, (a * ay + b * by + c * cy) / s
    area = abs((bx - ax) * (cy - ay) - (cx - ax) * (by - ay)) / 2
    r = 2 * area / s
    f = (r - d) / r
    return [(ix + (x - ix) * f, iy + (y - iy) * f) for x, y in pts]


def transformed(path, fn):
    """Applies fn(x, y) -> (x, y) to every point."""
    out = pathops.Path()
    pen = out.getPen()
    for verb, pts in path.segments:
        pts = [fn(*q) for q in pts]
        if verb == "moveTo":
            pen.moveTo(pts[0])
        elif verb == "lineTo":
            pen.lineTo(pts[0])
        elif verb == "curveTo":
            pen.curveTo(*pts)
        elif verb == "qCurveTo":
            pen.qCurveTo(*pts)
        elif verb == "closePath":
            pen.closePath()
        elif verb == "endPath":
            pen.endPath()
    return out


def rotate_about(path, deg, cx, cy):
    t = math.radians(deg)
    c, s = math.cos(t), math.sin(t)
    return transformed(path, lambda x, y: (cx + (x - cx) * c - (y - cy) * s, cy + (x - cx) * s + (y - cy) * c))


def move(path, dx, dy, k=1.0):
    return transformed(path, lambda x, y: (x * k + dx, y * k + dy))


# ------------------------------------------------------------------ shapes

def taper(p1, p2, r1, r2):
    """A stroke from p1 (radius r1) to p2 (radius r2) with round ends."""
    (x1, y1), (x2, y2) = p1, p2
    dx, dy = x2 - x1, y2 - y1
    n = math.hypot(dx, dy)
    nx, ny = -dy / n, dx / n
    quad = poly([(x1 + nx * r1, y1 + ny * r1), (x2 + nx * r2, y2 + ny * r2),
                 (x2 - nx * r2, y2 - ny * r2), (x1 - nx * r1, y1 - ny * r1)])
    return union(quad, circle(x1, y1, r1), circle(x2, y2, r2))


def panda_outline(t=4.6):
    """Red panda face as a thin outline: wide head, round ears with dark
    insides, eyes with the tear marks running down to the muzzle, nose."""
    head_o = ellipse(40, 48, 31, 23)
    head_i = ellipse(40, 48, 31 - t, 23 - t)
    ears_o, ears_i, ears_in = [], [], []
    for tri, (ccx, ccy) in [([(8, 44), (13, 12), (39, 27)], (22, 31)),
                            ([(41, 27), (67, 12), (72, 44)], (58, 31))]:
        ears_o.append(inter(poly(tri), circle(ccx, ccy, 19)))
        ears_i.append(inter(poly(shrink_triangle(tri, t)), circle(ccx, ccy, 19 - t)))
        ears_in.append(inter(poly(shrink_triangle(tri, t + 3.2)), circle(ccx, ccy, 12)))
    outer = union(head_o, *ears_o)
    inner = union(head_i, *ears_i)
    face = minus(outer, inner)
    inner_ears = minus(union(*ears_in), ellipse(40, 48, 31 - t + 0.01, 23 - t + 3.2))
    features = union(
        circle(28, 45, 4.3), taper((28, 47), (33, 60), 2.6, 1.3),
        circle(52, 45, 4.3), taper((52, 47), (47, 60), 2.6, 1.3),
        ellipse(40, 57, 4.2, 3.0),
    )
    return union(face, inner_ears, features)


def pencil(g=0.0):
    """Pencil pointing down-left; g grows it (for the gap behind it)."""
    w = 7 + g
    body = poly([(-g, -w), (40, -w), (40, w), (-g, w)])
    tip = poly([(40, -w), (55 + g * 1.4, 0), (40, w)])
    shape = union(rrect(-g, -w, 44, 2 * w, 3 + g), tip, body)
    if g == 0:
        # Eraser band and the bare wood at the tip.
        shape = minus(shape, rrect(9, -w - 1, 3.2, 2 * w + 2, 0))
        shape = minus(shape, poly([(41.6, -w - 1), (43.2, -w - 1), (43.2, w + 1), (41.6, w + 1)]))
    return rotate_about(shape, 135, 0, 0)


def pencil_glyph(g=0.0):
    p = move(pencil(g), 96, 46)
    underline = rrect(22 - g, 89 - g, 34 + 2 * g, 5.4 + 2 * g, 2.7 + g)
    return union(p, underline)


def mic_glyph(g=0.0):
    head = rrect(62 - g, 34 - g, 20 + 2 * g, 38 + 2 * g, 10 + g)
    u = minus(circle(72, 60, 17.5 + g), circle(72, 60, 13 - g))
    u = inter(u, rrect(40, 56 - g, 70, 40, 0))
    stem = rrect(69.7 - g, 76, 4.6 + 2 * g, 11, 0)
    base = rrect(60 - g, 85 - g, 24 + 2 * g, 5.4 + 2 * g, 2.7 + g)
    return union(head, u, stem, base)


def basket_glyph():
    handle = minus(circle(50, 56, 34), circle(50, 56, 29))
    handle = inter(handle, rrect(0, 0, 100, 54, 0))
    rim = rrect(8, 50, 84, 10, 3.2)
    body = poly([(15, 62), (85, 62), (77, 94), (23, 94)])
    # Wicker: two rows of slots, offset like a weave.
    slots = union(
        rrect(25, 69, 14, 5, 2.5), rrect(43, 69, 14, 5, 2.5), rrect(61, 69, 14, 5, 2.5),
        rrect(30, 80, 11, 5, 2.5), rrect(45, 80, 10, 5, 2.5), rrect(59, 80, 11, 5, 2.5),
    )
    front = union(handle, rim, minus(body, slots))
    # The panda peeking over the rim (secondary layer).
    head = ellipse(50, 48, 16, 12)
    ears = union(inter(poly([(33, 45), (36, 29), (47, 37)]), circle(41, 39, 9.5)),
                 inter(poly([(53, 37), (64, 29), (67, 45)]), circle(59, 39, 9.5)))
    peek = union(head, ears)
    peek = inter(peek, rrect(0, 0, 100, 46.6, 0))
    peek = minus(peek, union(circle(44, 41.5, 2.6), circle(56, 41.5, 2.6)))
    return front, peek


def with_panda(front, gap):
    """Action big in the lower right, the panda smaller behind it."""
    def big(p):
        return move(p, -16, -16, 1.16)
    panda = move(panda_outline(), 4, 2, 0.86)
    return big(front), minus(panda, big(gap))


GLYPHS = {
    "redpanda.note": lambda: with_panda(pencil_glyph(), pencil_glyph(5.0)),
    "redpanda.voice": lambda: with_panda(mic_glyph(), mic_glyph(5.0)),
    "redpanda.basket": basket_glyph,
}

# ------------------------------------------------------------------ template

BASE_M, CAP_M = 1126.0, 1055.54
SIZE = 96.0  # glyph box in template units (cap height is ~70.5)
LEFT = 1500.0
BEARING = 4.0


def to_template(path):
    k = SIZE / 100.0
    top = BASE_M + 12.0 - SIZE  # box bottom slightly below the baseline
    return transformed(path, lambda x, y: (LEFT + BEARING + x * k, top + y * k))


def svg_d(path):
    out = []
    for verb, pts in path.segments:
        f = " ".join(f"{x:.3f} {y:.3f}" for x, y in pts)
        if verb == "moveTo":
            out.append(f"M{f}")
        elif verb == "lineTo":
            out.append(f"L{f}")
        elif verb == "curveTo":
            out.append(f"C{f}")
        elif verb == "qCurveTo":
            out.append(f"Q{f}")
        elif verb == "closePath":
            out.append("Z")
    return "".join(out)


def template(name, front, back):
    right = LEFT + 2 * BEARING + SIZE
    guide = 'style="fill:none;stroke:#27AAE1;opacity:1;stroke-width:0.5;"'
    lines = []
    for n, y in [("Baseline-S", 696), ("Capline-S", 625.541), ("Baseline-M", BASE_M),
                 ("Capline-M", CAP_M), ("Baseline-L", 1556), ("Capline-L", 1485.54)]:
        lines.append(f'<line id="{n}" {guide} x1="263" x2="3036" y1="{y}" y2="{y}"/>')
    lines.append(f'<line id="left-margin-Regular-M" {guide} x1="{LEFT}" x2="{LEFT}" y1="1030.79" y2="1150.12"/>')
    lines.append(f'<line id="right-margin-Regular-M" {guide} x1="{right}" x2="{right}" y1="1030.79" y2="1150.12"/>')
    return f'''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<!--Generator: Red Panda tool/glyphs (make_glyphs.py)-->
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="3300" height="2200">
<!--glyph: "{name}", point size: 100.0, template writer version: "138.0.0"-->
<g id="Notes">
<text style="stroke:none;fill:black;font-family:sans-serif;font-size:13;" transform="matrix(1 0 0 1 263 322)">Red Panda glyph {name}: the action, with a small panda behind it (secondary).</text>
</g>
<g id="Guides">
{chr(10).join(lines)}
</g>
<g id="Symbols">
<g id="Regular-M">
<path class="monochrome-0 multicolor-0:tintColor hierarchical-0:secondary" d="{svg_d(to_template(back))}"/>
<path class="monochrome-1 multicolor-1:tintColor hierarchical-1:primary" d="{svg_d(to_template(front))}"/>
</g>
</g>
</svg>
'''


def preview_svg(front, back):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="400" height="400">
<rect width="100" height="100" fill="white"/>
<path d="{svg_d(back)}" fill="#9a9a9a"/>
<path d="{svg_d(front)}" fill="#111"/>
</svg>'''


def main():
    out = sys.argv[1]
    preview = sys.argv[2] if len(sys.argv) > 2 else None
    for name, build in GLYPHS.items():
        front, back = build()
        d = os.path.join(out, f"{name}.symbolset")
        os.makedirs(d, exist_ok=True)
        with open(os.path.join(d, f"{name}.svg"), "w") as f:
            f.write(template(name, front, back))
        with open(os.path.join(d, "Contents.json"), "w") as f:
            json.dump({"info": {"author": "xcode", "version": 1},
                       "symbols": [{"filename": f"{name}.svg", "idiom": "universal"}]}, f, indent=2)
        if preview:
            os.makedirs(preview, exist_ok=True)
            with open(os.path.join(preview, f"{name}.svg"), "w") as f:
                f.write(preview_svg(front, back))


if __name__ == "__main__":
    main()
