# Creating FoliCon Overlays — A Complete Guide

Overlays define how your media poster icons look in FoliCon. They're JSON-driven visual templates — no code required. Design your layers, define the layout, and FoliCon renders every poster icon using your design.

## Table of Contents

- [How It Works](#how-it-works)
- [Quick Start](#quick-start)
- [File Structure](#file-structure)
- [overlay.json — Complete Reference](#overlayjson--complete-reference)
- [The Layer System](#the-layer-system)
- [Poster Effects](#poster-effects)
- [Rating Badge](#rating-badge)
- [Title Text](#title-text)
- [Layer Ordering (Z-Order)](#layer-ordering-z-order)
- [Margins Explained](#margins-explained)
- [manifest.json — Complete Reference](#manifestjson--complete-reference)
- [Image Assets](#image-assets)
- [Validation & Limits](#validation--limits)
- [Design Tips & Patterns](#design-tips--patterns)
- [Example: From Scratch to Store](#example-from-scratch-to-store)
- [Submitting Your Overlay](#submitting-your-overlay)

---

## How It Works

FoliCon renders a 256×256 poster icon for each media item. An overlay defines the visual template — mockup frame, poster placement, rating badge position, and optional title text — all from a JSON file.

```
┌─────────────────────────┐
│  base layer (frame)     │  ← Bottom: your mockup background image
│  ┌───────────────────┐  │
│  │                   │  │
│  │   poster image    │  │  ← The user's actual media poster
│  │   (auto-filled)   │  │
│  │                   │  │
│  └───────────────────┘  │
│  front layer (glass)    │  ← Top: transparent overlay effect
│                 ★ 8.5   │  ← Rating badge
│  Title Text             │  ← Optional media title
└─────────────────────────┘
```

The renderer (`DynamicPosterIcon`) reads your JSON, builds a WPF visual tree, composites all layers, and renders the final 256×256 bitmap.

---

## Quick Start

### 1. Create your folder

```
my-overlay/
  overlay.json      # Your overlay definition
  manifest.json     # Metadata for the store
  preview.png       # 256×256 preview image
  base.png          # (optional) Background frame
  front.png         # (optional) Foreground glass/plastic effect
```

### 2. Write a minimal overlay.json

```json
{
  "schemaVersion": 1,
  "id": "my-overlay",
  "displayName": "My Overlay",
  "author": "YourName",
  "description": "A custom poster frame",
  "overlayVersion": "1.0.0",
  "tags": ["custom"],
  "poster": {
    "margin": "20,20,20,20"
  },
  "rating": {},
  "title": {}
}
```

### 3. Create your mockup images

- **base.png** — The frame/background behind the poster (PNG, max 2 MB)
- **front.png** — A transparent overlay on top of the poster (glass, glare, plastic effect)

### 4. Write manifest.json

```json
{
  "schemaVersion": 1,
  "id": "my-overlay",
  "displayName": "My Overlay",
  "author": "YourName",
  "description": "A custom poster frame",
  "overlayVersion": "1.0.0",
  "tags": ["custom"],
  "previewImage": "preview.png",
  "assets": ["overlay.json", "base.png", "front.png", "preview.png"],
  "sha256": {}
}
```

### 5. Test locally

Drop your folder into `%AppData%/FoliCon/Overlays/my-overlay/` and restart FoliCon. It appears in Settings → Poster Icon Overlay.

### 6. Submit

Fork [FoliCon-Overlays](https://github.com/DineshSolanki/FoliCon-Overlays), add your folder under `overlays/`, and open a Pull Request.

---

## File Structure

Every overlay is a folder containing:

| File | Required | Description |
|------|----------|-------------|
| `overlay.json` | **Yes** | The overlay definition — layout, layers, styling |
| `manifest.json` | **Yes** (for store) | Metadata, asset list, SHA256 hashes |
| `preview.png` | **Yes** (for store) | 256×256 preview shown in the Overlay Store |
| `base.png` | No | Background mockup frame image |
| `front.png` | No | Foreground transparent overlay image |
| `*.png` | No | Any additional image assets (opacity masks, custom layers) |
| `*.ttf` / `*.otf` | No | Custom font files for rating or title text |

### Naming rules

- **Folder name** must match the `id` field in both JSON files
- **ID format**: lowercase alphanumeric + hyphens only (e.g. `my-cool-overlay`, not `My_Cool_Overlay`)
- **Reserved IDs** (built-in, cannot be used): `legacy`, `alternate`, `liaher`, `faelpessoal`, `faelpessoal-horizontal`, `windows11`

---

## overlay.json — Complete Reference

This is the core file that defines your overlay's visual layout.

### Metadata fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schemaVersion` | integer | Yes | Must be `1` |
| `id` | string | Yes | Unique identifier. Lowercase + hyphens. Must match folder name |
| `displayName` | string | Yes | Human-readable name shown in the UI |
| `author` | string | Yes | Your name or GitHub username |
| `description` | string | No | Short description (max 500 chars) |
| `overlayVersion` | string | Yes | Semantic version: `"1.0.0"` |
| `tags` | string[] | No | Searchable tags for the store (e.g. `["rounded", "modern"]`) |

### Canvas / rendering fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `designWidth` | number | 265 | Design surface width in device-independent pixels (DIPs) |
| `designHeight` | number | 256 | Design surface height in DIPs |
| `rootMargin` | string | `"0,0,0,-11"` | Margin on the root Grid (left,top,right,bottom). Negative values extend beyond bounds |
| `renderWidth` | number | 256 | Final rendered bitmap width in pixels |
| `renderHeight` | number | 256 | Final rendered bitmap height in pixels |

> **When to change these:** Most overlays should keep the defaults (265×256 design, 256×256 render). Change `designWidth`/`designHeight` if your mockup needs a different canvas size. Change `rootMargin` to shift/extend the entire composition.

### Layer fields

| Field | Type | Description |
|-------|------|-------------|
| `baseLayer` | LayerDefinition \| null | Background frame image (behind the poster) |
| `frontLayer` | LayerDefinition \| null | Foreground overlay image (in front of the poster) |
| `poster` | PosterConfig | Poster image positioning and effects |
| `rating` | RatingConfig | Rating badge (shield + number) |
| `title` | TitleConfig | Title text overlay |
| `layerOrder` | string[] \| null | Explicit z-order. Default: `["base","poster","front","rating","title"]` |

---

## The Layer System

An overlay has up to 5 visual layers, stacked in z-order:

### Base layer (`baseLayer`)

The background frame — typically a mockup image (DVD case back, Blu-ray frame, etc.) that sits **behind** the poster.

```json
"baseLayer": {
  "imagePath": "base.png",
  "margin": "30,14,48,15"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `imagePath` | string | **Required.** Relative path to the image within your overlay folder |
| `margin` | string | **Required.** WPF Thickness: `"left,top,right,bottom"` |

The base layer respects `MockupVisibility` — it hides when the user disables mockup display.

### Front layer (`frontLayer`)

A transparent overlay image that sits **in front of** the poster. Used for glass/plastic effects, glare, or decorative borders that should overlap the poster.

```json
"frontLayer": {
  "imagePath": "front.png",
  "margin": "16,14,35,15"
}
```

Same fields as `baseLayer`. Also respects `MockupVisibility`.

> **Design tip:** Use PNG with transparency. The front layer is composited over the poster, so transparent areas show the poster through. This creates the illusion of the poster being "inside" a case or behind glass.

### Poster (`poster`)

The user's actual media poster image. FoliCon automatically fills this with the media's poster art. You control where and how it appears.

### Rating (`rating`)

The rating badge — a shield icon with the media's rating number overlaid on it.

### Title (`title`)

Optional title text showing the media name. Can be positioned anywhere, rotated, and placed in different containers.

---

## Poster Effects

The poster layer supports three rendering modes:

### 1. Plain poster (no effects)

The simplest mode — just position the poster with margins.

```json
"poster": {
  "margin": "31,42,50,19",
  "clipRadius": "0"
}
```

The poster image fills the area defined by the margin, stretched to fit.

### 2. Rounded corners (clip)

Clip the poster to a rounded rectangle. The poster is wrapped in a `Border` with `CornerRadius` and a clip geometry.

```json
"poster": {
  "margin": "34,10,43,21",
  "clipRadius": "8",
  "clipRect": "0,0,188,236"
}
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `clipRadius` | string | `"0"` | Corner radius. Single value (`"8"`) or four corners (`"5,10,5,10"` for tl,tr,br,bl). `"0"` = no clip |
| `clipRect` | string | null | Explicit clip rectangle: `"x,y,width,height"`. Overrides auto-calculated clip |
| `posterInnerMargin` | string | null | Extra margin on the poster Image inside the Border. Use for fine-tuning (e.g. `"0,0,0,-1"`) |

**How clipping works:**
- If `clipRect` is set, those exact coordinates are used
- If `clipRect` is null, the clip is auto-calculated from `designWidth`, `designHeight`, `rootMargin`, and `poster.margin`
- `clipRadius` applies to both the Border's CornerRadius and the clip geometry's corner radius

> **Tip:** Use `clipRect` for pixel-perfect control. The auto-calculation works for most cases, but explicit values let you match an original design exactly.

### 3. Opacity mask

Apply a gradient/mask image to create shaped transparency effects (fades, custom shapes).

```json
"poster": {
  "margin": "5,58,5,32",
  "clipRadius": "0",
  "opacityMaskPath": "mask.png"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `opacityMaskPath` | string \| null | Relative path to a mask image. White = visible, black = transparent, gray = semi-transparent |

The opacity mask image uses the **luminance** of each pixel to control the poster's transparency. White pixels are fully visible, black pixels are fully transparent.

**Combining clip + opacity mask:** You can use both together. The poster gets clipped to the rounded rectangle AND masked by the opacity image.

> **Design tip:** Opacity masks are great for creating vignette effects, fade-out edges, or custom-shaped poster windows (circles, arches, etc.).

---

## Rating Badge

The rating badge displays the media's rating (e.g. "8.5") on a shield icon in the bottom-right corner.

```json
"rating": {
  "shieldMargin": "160,97,6,5",
  "textMargin": "189,30,21,24",
  "fontSize": 25,
  "fontFamily": "Castellar",
  "fontSource": null,
  "fontFallback": "Segoe UI",
  "textWidth": 55,
  "textHeight": 46,
  "textHorizontalAlignment": "Center",
  "textVerticalAlignment": "Center"
}
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `shieldMargin` | string | `"160,97,6,5"` | Position of the shield image |
| `textMargin` | string | `"189,30,21,24"` | Position of the rating number text |
| `fontSize` | number | 25 | Font size for the rating number |
| `fontFamily` | string | `"Castellar"` | Primary font name |
| `fontSource` | string \| null | null | Path to a bundled .ttf/.otf font file in your overlay folder |
| `fontFallback` | string | `"Segoe UI"` | Fallback font if primary isn't installed |
| `textWidth` | number | 55 | Width of the text bounding box |
| `textHeight` | number | 46 | Height of the text bounding box |
| `textHorizontalAlignment` | string | `"Center"` | `Left`, `Center`, `Right`, or `Stretch` |
| `textVerticalAlignment` | string | `"Center"` | `Top`, `Center`, `Bottom`, or `Stretch` |

### Custom fonts

Bundle a `.ttf` or `.otf` file in your overlay folder and reference it:

```json
"rating": {
  "fontFamily": "My Custom Font",
  "fontSource": "MyCustomFont.ttf",
  "fontFallback": "Arial"
}
```

The font is loaded from the overlay folder at render time. `fontFamily` should match the font's internal name. If the font fails to load, `fontFallback` is used.

> **Note:** The rating badge uses the built-in shield image (`/Resources/rating_mockup/shield.png`). You cannot replace it with a custom shield in the current version.

---

## Title Text

Optional text overlay showing the media's title. Disabled by default.

```json
"title": {
  "isVisible": true,
  "margin": "0,200,0,0",
  "fontFamily": "Cormorant",
  "foreground": "White",
  "trimming": "WordEllipsis",
  "wrapping": "Wrap",
  "horizontalAlignment": "Left",
  "verticalAlignment": "Top"
}
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `isVisible` | boolean | `false` | Show/hide the title text |
| `margin` | string | `"0,0,0,0"` | Position via margin |
| `fontFamily` | string | `"Cormorant"` | Primary font name |
| `fontSource` | string \| null | null | Path to a bundled .ttf/.otf font |
| `fontFallback` | string | `"Segoe UI"` | Fallback font |
| `foreground` | string | `"White"` | Text color. WPF color name (`"White"`, `"Gold"`) or hex (`"#FF5500"`, `"#80FFFFFF"`) |
| `trimming` | string | `"WordEllipsis"` | `None`, `WordEllipsis`, or `CharacterEllipsis` |
| `wrapping` | string | `"Wrap"` | `NoWrap`, `Wrap`, or `WrapWithOverflow` |
| `horizontalAlignment` | string | `"Left"` | `Left`, `Center`, `Right`, or `Stretch` |
| `verticalAlignment` | string | `"Top"` | `Top`, `Center`, `Bottom`, or `Stretch` |

### Rotation

Title text can be rotated — useful for spine text on DVD/Blu-ray mockups.

```json
"title": {
  "isVisible": true,
  "margin": "190,14,-2,53",
  "rotationAngle": 90,
  "rotationOrigin": "0.5,0.5",
  "fontFamily": "Cormorant",
  "foreground": "White"
}
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `rotationAngle` | number | 0 | Rotation in degrees (0–360) |
| `rotationOrigin` | string | `"0.5,0.5"` | Pivot point as normalized coordinates `"x,y"` (0.0–1.0). `0.5,0.5` = center |

**Common rotation origins:**
- `"0.5,0.5"` — Rotate around center (default)
- `"0,0"` — Rotate around top-left corner
- `"1,1"` — Rotate around bottom-right corner

### Title containers

The title can live in two different visual containers:

| Container | Description |
|-----------|-------------|
| `"Root"` (default) | Direct child of the root Grid. Position with `margin` relative to the entire overlay |
| `"RatingGrid"` | Inside the rating badge's Grid. Position with `gridRow` to place it in one of the rating grid's rows |

```json
"title": {
  "isVisible": true,
  "container": "RatingGrid",
  "gridRow": 1,
  "margin": "190,14,-2,53",
  "rotationAngle": 90
}
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `container` | string | `"Root"` | `"Root"` or `"RatingGrid"` |
| `gridRow` | integer | 0 | Grid row when container is `"RatingGrid"` (0, 1, or 2) |

> **When to use RatingGrid:** Use it when the title should be positioned relative to the rating badge area rather than the full overlay. This is useful for DVD spine text that sits alongside the rating.

---

## Layer Ordering (Z-Order)

Layers are stacked bottom-to-top in the order they're added to the root Grid. You can control this explicitly:

```json
"layerOrder": ["base", "poster", "front", "rating", "title"]
```

**Available keys:** `base`, `poster`, `front`, `rating`, `title`

**Default** (if `layerOrder` is null): `["base", "poster", "front", "rating", "title"]`

### How it works

Each layer is only added if it exists in your overlay (e.g., if you don't define `baseLayer`, the `"base"` key is skipped). Layers listed in `layerOrder` but not defined in your overlay are silently ignored.

### Common patterns

| Pattern | Order | Use case |
|---------|-------|----------|
| Frame + glass | `base → poster → front → rating` | DVD/Blu-ray case with plastic overlay |
| No frame | `poster → rating` | Poster-only with rating badge |
| Title behind frame | `base → title → poster → front → rating` | Title text visible through transparent poster area |
| Opacity mask only | `base → poster → rating` | Windows 11 style with no front layer |

> **Important:** The order matters for visual stacking. If your front layer should appear over the poster, it must come AFTER `poster` in the array.

---

## Margins Explained

Margins use WPF's Thickness format to position elements. They define the space between an element's edges and its parent container's edges.

### Format

```
"left,top,right,bottom"
```

### Value count variations

| Values | Example | Meaning |
|--------|---------|---------|
| 1 | `"10"` | All sides: 10 |
| 2 | `"10,20"` | Horizontal=10, Vertical=20 |
| 3 | `"10,20,30"` | Left=10, Top=20, Right=30, Bottom=20 |
| 4 | `"10,20,30,40"` | Left=10, Top=20, Right=30, Bottom=40 |

### Negative margins

Negative values extend an element beyond its parent bounds. This is used extensively for precise positioning:

```json
"baseLayer": {
  "imagePath": "base.png",
  "margin": "-8,0,0,10"
}
```

This pushes the base layer 8 pixels to the left of the Grid's edge.

### How margins position elements

In WPF, `Margin` on an element inside a `Grid` works as insets from the Grid cell edges:

- `margin: "30,10,30,10"` — Inset 30px from left, 10px from top, 30px from right, 10px from bottom
- `margin: "0,0,0,0"` — Fills the entire Grid cell
- `margin: "-10,-10,-10,-10"` — Extends 10px beyond all edges

> **Tip:** Start with `"0,0,0,0"` and adjust each side until your mockup layers align perfectly. Use the preview in FoliCon's settings to see real-time results.

---

## manifest.json — Complete Reference

The manifest provides metadata for the Overlay Store and integrity verification.

```json
{
  "schemaVersion": 1,
  "id": "my-overlay",
  "displayName": "My Overlay",
  "author": "YourName",
  "description": "A custom poster frame",
  "overlayVersion": "1.0.0",
  "tags": ["custom", "modern"],
  "previewImage": "preview.png",
  "assets": ["overlay.json", "base.png", "front.png", "preview.png"],
  "sha256": {
    "overlay.json": "abc123...",
    "base.png": "def456...",
    "front.png": "ghi789...",
    "preview.png": "jkl012..."
  },
  "sizeBytes": 123456,
  "createdAt": "2026-07-19T00:00:00Z",
  "updatedAt": "2026-07-19T00:00:00Z"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schemaVersion` | integer | Yes | Must be `1` |
| `id` | string | Yes | Must match folder name and overlay.json id |
| `displayName` | string | Yes | Human-readable name |
| `author` | string | Yes | Author name |
| `description` | string | No | Short description (max 500 chars) |
| `overlayVersion` | string | Yes | Semantic version for update detection |
| `tags` | string[] | No | Category tags (max 10, each max 30 chars) |
| `previewImage` | string | No | Filename of preview image (usually `"preview.png"`) |
| `assets` | string[] | Yes | List of ALL files in the folder. Must include `"overlay.json"` |
| `sha256` | object | Yes | Per-file SHA256 hashes (hex, 64 chars). Key = filename, value = hash |
| `sizeBytes` | integer | No | Computed automatically by the CI — you don't need to set this |
| `createdAt` | string | No | ISO 8601 timestamp |
| `updatedAt` | string | No | ISO 8601 timestamp |

### Computing SHA256 hashes

On Windows (PowerShell):
```powershell
Get-FileHash -Algorithm SHA256 overlay.json | Select-Object -ExpandProperty Hash
```

On Linux/macOS:
```bash
sha256sum overlay.json base.png front.png preview.png
```

> **Note:** `sizeBytes` is computed automatically when the catalog is generated. You can set it to `0` or omit it.

---

## Image Assets

### Format requirements

| Requirement | Value |
|-------------|-------|
| Format | PNG only |
| Max single file size | 2 MB |
| Max total package size | 5 MB |
| Recommended preview size | 256×256 pixels |

### Image types

| Image | Purpose | Tips |
|-------|---------|------|
| `base.png` | Background frame | Should match your `designWidth`×`designHeight`. Use transparency for irregular shapes |
| `front.png` | Foreground overlay | Must use transparency — only the visible parts will overlay the poster |
| `preview.png` | Store preview | A 256×256 composite showing how the overlay looks with a sample poster |
| `mask.png` | Opacity mask | Grayscale image for `opacityMaskPath`. White=visible, black=transparent |
| `*.ttf` / `*.otf` | Custom font | Bundled font for rating/title text |

### Creating mockup images

1. **Start with a photo or 3D render** of your desired frame (DVD case, Blu-ray, vinyl sleeve, etc.)
2. **Cut out the poster window** — make it transparent so the user's poster shows through
3. **Split into base + front:**
   - `base.png`: Everything behind the poster (back of the case, inner frame)
   - `front.png`: Everything in front of the poster (plastic wrap, glass, decorative borders)
4. **Export as PNG** with transparency preserved

> **Tip:** If your design doesn't need a front layer (no glass/plastic effect), set `"frontLayer": null` and skip the front image.

---

## Validation & Limits

When you submit an overlay, FoliCon validates it automatically:

| Check | Rule |
|-------|------|
| Schema version | Must be ≤ app's supported version (currently 1) |
| ID format | Lowercase alphanumeric + hyphens, must start/end with alphanumeric |
| ID uniqueness | Must not match a built-in overlay ID |
| Required fields | `id`, `displayName`, `author`, `overlayVersion`, `poster.margin`, `rating`, `title` |
| Image existence | All referenced image files must exist in the overlay folder |
| Image size | Each image ≤ 2 MB |
| Package size | Total folder ≤ 5 MB |
| Margin format | 1–4 comma-separated numeric values |
| Rotation origin | Two values between 0.0 and 1.0 |

### Common validation errors

| Error | Fix |
|-------|-----|
| `overlay 'id' contains invalid characters` | Use only `a-z`, `0-9`, and `-` |
| `baseLayer.imagePath 'x.png' file not found` | Check the filename matches exactly (case-sensitive on Linux) |
| `poster.margin is not a valid Thickness string` | Use `"left,top,right,bottom"` format with numbers only |
| `Overlay folder exceeds maximum total size` | Compress your PNGs. Use tools like [pngquant](https://pngquant.org/) or [TinyPNG](https://tinypng.com/) |

---

## Design Tips & Patterns

### Pattern 1: DVD / Blu-ray case

```
base.png  → Back of the case (visible around poster edges)
front.png → Plastic wrap / glossy overlay
poster    → Positioned inside the case window
rating    → Bottom-right corner
```

```json
{
  "baseLayer": { "imagePath": "base.png", "margin": "30,14,48,15" },
  "frontLayer": { "imagePath": "front.png", "margin": "16,14,35,15" },
  "poster": { "margin": "31,42,50,19", "clipRadius": "0" },
  "layerOrder": ["base", "poster", "front", "rating"]
}
```

### Pattern 2: Rounded card

```
poster    → Rounded corners via clipRadius
rating    → Overlaid on the poster
no base/front layers
```

```json
{
  "baseLayer": null,
  "frontLayer": null,
  "poster": { "margin": "10,10,10,10", "clipRadius": "12", "clipRect": "0,0,245,236" },
  "layerOrder": ["poster", "rating"]
}
```

### Pattern 3: Window with opacity mask

```
base      → Window frame
poster    → Shaped by opacity mask (arch, circle, custom shape)
rating    → Corner badge
```

```json
{
  "baseLayer": { "imagePath": "base.png", "margin": "5,0,5,10" },
  "poster": { "margin": "5,58,5,32", "clipRadius": "0", "opacityMaskPath": "mask.png" },
  "layerOrder": ["base", "poster", "rating"]
}
```

### Pattern 4: DVD spine with rotated title

```
base      → Case back
front     → Plastic overlay
poster    → Inside the case
title     → Rotated 90° on the spine
rating    → Bottom badge
```

```json
{
  "title": {
    "isVisible": true,
    "container": "RatingGrid",
    "gridRow": 1,
    "margin": "190,14,-2,53",
    "rotationAngle": 90,
    "rotationOrigin": "0.5,0.5",
    "foreground": "White"
  },
  "layerOrder": ["base", "poster", "front", "title", "rating"]
}
```

### Color tips for `foreground`

| Format | Example |
|--------|---------|
| Named color | `"White"`, `"Gold"`, `"Black"`, `"Red"` |
| Hex RGB | `"#FF5500"`, `"#333333"` |
| Hex ARGB | `"#80FFFFFF"` (50% transparent white) |

### Negative margin tricks

- **Extend beyond bounds:** `"-10,0,0,0"` pushes an element 10px left of the Grid edge
- **Overlap layers:** Use negative margins on the front layer to make it overlap the poster more
- **Fine-tune alignment:** Small negative values (like `"-1"`) fix 1-pixel gaps between layers

---

## Example: From Scratch to Store

Let's walk through creating a "vinyl record" overlay:

### Step 1: Design the concept

A circular vinyl record peeking out of a sleeve. The poster image fills the record area.

### Step 2: Create images

- `base.png` — The record sleeve (265×256 PNG with transparent circle cutout)
- `front.png` — The record's edge and label ring (transparent PNG, sits over the poster)
- `preview.png` — A 256×256 composite showing how it looks

### Step 3: Write overlay.json

```json
{
  "schemaVersion": 1,
  "id": "vinyl-record",
  "displayName": "Vinyl Record",
  "author": "YourName",
  "description": "Vintage vinyl record sleeve with circular poster window",
  "overlayVersion": "1.0.0",
  "tags": ["vintage", "music", "circular"],
  "designWidth": 265,
  "designHeight": 256,
  "rootMargin": "0,0,0,-11",
  "renderWidth": 256,
  "renderHeight": 256,
  "layerOrder": ["base", "poster", "front", "rating"],
  "baseLayer": {
    "imagePath": "base.png",
    "margin": "0,0,0,0"
  },
  "frontLayer": {
    "imagePath": "front.png",
    "margin": "0,0,0,0"
  },
  "poster": {
    "margin": "32,32,32,43",
    "clipRadius": "100",
    "clipRect": "0,0,201,192"
  },
  "rating": {
    "shieldMargin": "160,97,6,5",
    "textMargin": "189,30,21,24",
    "fontSize": 25,
    "fontFamily": "Castellar",
    "fontFallback": "Segoe UI",
    "textWidth": 55,
    "textHeight": 46,
    "textHorizontalAlignment": "Center",
    "textVerticalAlignment": "Center"
  },
  "title": {
    "isVisible": false
  }
}
```

### Step 4: Write manifest.json

Generate SHA256 hashes for each file:
```bash
sha256sum overlay.json base.png front.png preview.png
```

```json
{
  "schemaVersion": 1,
  "id": "vinyl-record",
  "displayName": "Vinyl Record",
  "author": "YourName",
  "description": "Vintage vinyl record sleeve with circular poster window",
  "overlayVersion": "1.0.0",
  "tags": ["vintage", "music", "circular"],
  "previewImage": "preview.png",
  "assets": ["overlay.json", "base.png", "front.png", "preview.png"],
  "sha256": {
    "overlay.json": "...",
    "base.png": "...",
    "front.png": "...",
    "preview.png": "..."
  },
  "createdAt": "2026-07-19T00:00:00Z",
  "updatedAt": "2026-07-19T00:00:00Z"
}
```

### Step 5: Test locally

1. Copy the folder to `%AppData%/FoliCon/Overlays/vinyl-record/`
2. Open FoliCon → Settings → Change Poster Icon Overlay
3. Select "Vinyl Record" from the list
4. Verify the preview looks correct

### Step 6: Submit

1. Fork [FoliCon-Overlays](https://github.com/DineshSolanki/FoliCon-Overlays)
2. Add your folder under `overlays/vinyl-record/`
3. Open a Pull Request
4. The CI automatically generates the catalog entry

---

## Submitting Your Overlay

1. **Fork** the [FoliCon-Overlays](https://github.com/DineshSolanki/FoliCon-Overlays) repository
2. **Create** your overlay folder under `overlays/{your-id}/`
3. **Add** all files: `overlay.json`, `manifest.json`, `preview.png`, and any image/font assets
4. **Compute SHA256** hashes for all assets and fill in `manifest.json`
5. **Open a Pull Request** to `main`
6. The GitHub Action automatically generates `catalog.json` from your manifest
7. Once merged, your overlay appears in FoliCon's Overlay Store for all users

### PR checklist

- [ ] Folder name matches `id` in both JSON files
- [ ] `overlay.json` passes validation (all referenced images exist)
- [ ] `manifest.json` has correct SHA256 hashes for every asset
- [ ] `preview.png` is 256×256 and shows how the overlay looks
- [ ] Total package size is under 5 MB
- [ ] No single image exceeds 2 MB
- [ ] Tested locally in FoliCon before submitting

### Updating your overlay

1. Bump `overlayVersion` in both `overlay.json` and `manifest.json` (e.g. `1.0.0` → `1.1.0`)
2. Update `updatedAt` timestamp
3. Recompute SHA256 hashes for changed files
4. Push to your fork — the PR triggers the catalog regeneration
5. Users who installed your overlay will see an "Update" button in the store

---

## Quick Reference Card

```
┌──────────────────────────────────────────────────────────────┐
│                    OVERLAY QUICK REFERENCE                    │
├──────────────────────────────────────────────────────────────┤
│  Design canvas:  265 × 256 DIPs (default)                    │
│  Render size:    256 × 256 pixels (default)                  │
│  Max image:      2 MB per file                               │
│  Max package:    5 MB total                                  │
│  Format:         PNG only                                    │
│  ID format:      lowercase + hyphens (e.g. "my-overlay")     │
│  Version:        semver (e.g. "1.0.0")                       │
├──────────────────────────────────────────────────────────────┤
│  Margin format:  "left,top,right,bottom"                     │
│  Corner radius:  "radius" or "tl,tr,br,bl"                   │
│  Clip rect:      "x,y,width,height"                          │
│  Rotation origin: "x,y" (0.0 to 1.0)                        │
│  Colors:         name ("White") or hex ("#FF5500")           │
├──────────────────────────────────────────────────────────────┤
│  Layers:  base → poster → front → rating → title             │
│  (z-order, bottom to top, customizable via layerOrder)       │
├──────────────────────────────────────────────────────────────┤
│  Install path:  %AppData%/FoliCon/Overlays/{id}/             │
│  Store:         Settings → Change Poster Icon Overlay        │
│  Submit:        PR to FoliCon-Overlays repo                  │
└──────────────────────────────────────────────────────────────┘
```
