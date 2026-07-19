# Overlay Design Patterns

Visual patterns for FoliCon overlays with ASCII previews and JSON templates.

## Pattern A: DVD / Blu-ray Case

The classic physical media look. Poster sits inside a case with a back panel and a transparent front overlay.

```
┌─────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░ │  base layer (case back)
│ ░┌───────────────────┐░ │
│ ░│                   │░ │
│ ░│      POSTER       │░ │  user's poster art
│ ░│                   │░ │
│ ░└───────────────────┘░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░ │  front layer (plastic wrap/glass)
│                   ★ 8.5 │  rating badge
└─────────────────────────┘
```

**Images needed:** base.png (case back), front.png (plastic overlay with transparency)
**Best for:** Movies, TV shows, physical media collectors

```json
{
  "layerOrder": ["base", "poster", "front", "rating"],
  "baseLayer": { "imagePath": "base.png", "margin": "30,14,48,15" },
  "frontLayer": { "imagePath": "front.png", "margin": "16,14,35,15" },
  "poster": { "margin": "31,42,50,19", "clipRadius": "0" }
}
```

**Design tips:**
- Create base.png with a transparent window where the poster goes
- Create front.png as a semi-transparent overlay (plastic wrap effect)
- Adjust margins to align the poster window precisely
- Use the liaher or example-dvd-case overlays as reference

---

## Pattern B: Rounded Card

Clean, modern look with rounded poster corners. No frame images needed.

```
╭─────────────────────────╮
│                         │
│        POSTER           │  poster with rounded clip
│                         │
│                   ★ 8.5 │  rating badge
╰─────────────────────────╯
```

**Images needed:** None (or just a preview.png for the store)
**Best for:** Modern/minimal designs, music, games

```json
{
  "layerOrder": ["poster", "rating"],
  "baseLayer": null,
  "frontLayer": null,
  "poster": { "margin": "10,10,10,10", "clipRadius": "12", "clipRect": "0,0,245,236" }
}
```

**Design tips:**
- Adjust `clipRadius` for more or less rounding
- Use `clipRect` for precise control over the clip area
- Add more margin to make the poster smaller within the frame

---

## Pattern C: Window / Opacity Mask

The poster is visible through a custom shape cut into a frame. Uses opacity masks for non-rectangular windows.

```
┌─────────────────────────┐
│   ╭─────╮               │
│   │     │   POSTER      │  base (frame) + opacity mask shapes poster
│   │     │  (shaped)     │
│   ╰─────╯               │
│                   ★ 8.5 │  rating badge
└─────────────────────────┘
```

**Images needed:** base.png (frame), mask.png (grayscale shape for opacity)
**Best for:** Creative designs, themed overlays (portals, windows, bubbles)

```json
{
  "layerOrder": ["base", "poster", "rating"],
  "baseLayer": { "imagePath": "base.png", "margin": "5,0,5,10" },
  "frontLayer": null,
  "poster": { "margin": "5,58,5,32", "clipRadius": "0", "opacityMaskPath": "mask.png" }
}
```

**How opacity masks work:**
- White pixels → poster fully visible
- Black pixels → poster fully transparent
- Gray pixels → semi-transparent
- Use gradients for smooth fade effects
- The mask image should be the same aspect ratio as the poster area

**Design tips:**
- Create the mask in any image editor (white shape on black background)
- Combine with clipRadius for shaped + rounded effects
- Use the windows11 overlay as reference

---

## Pattern D: Minimal

Poster fills the icon with just a rating badge. Cleanest look.

```
┌─────────────────────────┐
│                         │
│        POSTER           │  plain poster, full bleed
│                         │
│                   ★ 8.5 │  rating badge only
└─────────────────────────┘
```

**Images needed:** None
**Best for:** Letting the poster art speak for itself

```json
{
  "layerOrder": ["poster", "rating"],
  "baseLayer": null,
  "frontLayer": null,
  "poster": { "margin": "0,0,0,0", "clipRadius": "0" }
}
```

---

## Pattern E: DVD with Spine Title

DVD case with the media title rotated 90° along the spine.

```
┌─────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░┌───────────────────┐░ │
│ ░│                   │░ │
│T │      POSTER       │░ │  T = rotated title on spine
│I │                   │░ │
│T │                   │░ │
│L │                   │░ │
│E └───────────────────┘░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░ │
│                   ★ 8.5 │
└─────────────────────────┘
```

**Images needed:** base.png, front.png
**Best for:** DVD/Blu-ray collections with spine text

```json
{
  "layerOrder": ["base", "poster", "front", "title", "rating"],
  "baseLayer": { "imagePath": "base.png", "margin": "-6,0,-2,10" },
  "frontLayer": { "imagePath": "front.png", "margin": "-9,-18,16,2" },
  "poster": { "margin": "27,4,53,27", "clipRadius": "7", "clipRect": "0,0,186,267" },
  "title": {
    "isVisible": true,
    "container": "RatingGrid",
    "gridRow": 1,
    "margin": "190,14,-2,53",
    "rotationAngle": 90,
    "rotationOrigin": "0.5,0.5",
    "fontFamily": "Cormorant",
    "foreground": "White",
    "trimming": "WordEllipsis",
    "wrapping": "Wrap",
    "horizontalAlignment": "Stretch",
    "verticalAlignment": "Stretch"
  }
}
```

---

## Pattern F: Stacked / Multi-Layer

Creative overlays with multiple transparent layers for depth effects.

```
┌─────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░  ┌─────────────────┐░ │  decorative top frame
│ ░  │                 │░ │
│ ░  │    POSTER       │░ │  middle poster
│ ░  │                 │░ │
│ ░  └─────────────────┘░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░ │  decorative bottom frame
│                   ★ 8.5 │
└─────────────────────────┘
```

**Images needed:** base.png, front.png (with artistic transparency)
**Best for:** Artistic, themed, or decorative overlays

---

## Common Margin Patterns

### Centered poster with equal margins
```json
"poster": { "margin": "20,20,20,20" }
```

### Poster flush with bottom (rating space at bottom)
```json
"poster": { "margin": "10,10,10,50" }
```

### Narrow poster (DVD window style)
```json
"poster": { "margin": "30,10,30,10" }
```

### Wide poster (letterbox effect)
```json
"poster": { "margin": "5,40,5,40" }
```

## Font Pairing Suggestions

| Style | Rating Font | Title Font | Notes |
|-------|------------|------------|-------|
| Classic | Castellar | Cormorant | Default, elegant |
| Modern | Segoe UI | Segoe UI | Clean, system fonts |
| Retro | Courier New | Impact | Monospace + bold |
| Elegant | Georgia | Palatino | Serif pairing |
| Minimal | Arial | Helvetica | Sans-serif, clean |

Bundle custom fonts as .ttf files and reference via `fontSource`.

## Color Palette Ideas

| Theme | Title Foreground | Notes |
|-------|-----------------|-------|
| Classic | White | Default, works on dark posters |
| Gold | Gold | Premium feel |
| Neon | #00FF00 or #FF00FF | Cyberpunk/retro |
| Muted | #AAAAAA | Subtle, doesn't distract |
| Match poster | Use eyedropper from poster | Harmonious |
