# overlay.json — Complete Field Reference

## Root Fields

### schemaVersion (integer, required)
Must be `1`. The app ignores overlays with schemaVersion > supported version.

### id (string, required)
Unique overlay identifier. Rules:
- Lowercase alphanumeric + hyphens only
- Must start and end with alphanumeric
- Pattern: `^[a-z0-9]([a-z0-9\-]*[a-z0-9])?$`
- 2-50 characters
- Must match the folder name
- Must NOT be a built-in ID: `legacy`, `alternate`, `liaher`, `faelpessoal`, `faelpessoal-horizontal`, `windows11`

### displayName (string, required)
Human-readable name shown in the UI and store. Example: `"Retro VHS"`.

### author (string, required)
Your name or GitHub username.

### description (string, optional)
Short description, max 500 characters.

### overlayVersion (string, required)
Semantic version: `"1.0.0"`. Used for update detection. Pattern: `^\d+\.\d+\.\d+$`.

### tags (string[], optional)
Searchable tags for the store. Max 10 tags, each max 30 characters. Example: `["retro", "vhs", "80s"]`.

### IsBuiltIn (bool)
Not set in JSON — only set by the app for built-in overlays.

## Canvas / Rendering

### designWidth (number, default: 265)
Design surface width in device-independent pixels (DIPs).

### designHeight (number, default: 256)
Design surface height in DIPs.

### rootMargin (string, default: "0,0,0,-11")
Margin on the root Grid. Format: "left,top,right,bottom". Negative values extend beyond bounds.

### renderWidth (number, default: 256)
Final rendered bitmap width in pixels.

### renderHeight (number, default: 256)
Final rendered bitmap height in pixels.

## Layers

### layerOrder (string[] | null, default: ["base","poster","front","rating","title"])
Explicit z-order of children in the root Grid. Valid keys: `base`, `poster`, `front`, `rating`, `title`.
Layers not defined in the overlay are silently skipped.

### baseLayer (LayerDefinition | null)
Background frame image, sits behind the poster.

```json
"baseLayer": {
  "imagePath": "base.png",    // Required. Relative path within overlay folder
  "margin": "30,14,48,15"     // Required. WPF Thickness: "left,top,right,bottom"
}
```

### frontLayer (LayerDefinition | null)
Foreground overlay image, sits in front of the poster. Use PNG transparency.

```json
"frontLayer": {
  "imagePath": "front.png",   // Required. Relative path within overlay folder
  "margin": "16,14,35,15"     // Required. WPF Thickness
}
```

## poster (PosterConfig, required)

Controls how the user's poster image is positioned and rendered.

### poster.margin (string, required)
Position of the poster. WPF Thickness: "left,top,right,bottom".

### poster.clipRadius (string, default: "0")
Corner radius for rounded clipping. `"0"` = no clip.
- Single value: `"8"` (all corners)
- Four corners: `"5,10,5,10"` (tl, tr, br, bl)

### poster.clipRect (string | null, default: null)
Explicit clip rectangle: "x,y,width,height". Overrides auto-calculated clip from margins.
Use for pixel-perfect control.

### poster.posterInnerMargin (string | null, default: null)
Extra margin on the poster Image inside the Border (when clip is active).
Example: `"0,0,0,-1"` for fine-tuning.

### poster.opacityMaskPath (string | null, default: null)
Relative path to a grayscale opacity mask image. White = visible, black = transparent.
Can be combined with clipRadius.

## rating (RatingConfig, required)

The rating badge (shield icon + number).

### rating.shieldMargin (string, default: "160,97,6,5")
Position of the shield image.

### rating.textMargin (string, default: "189,30,21,24")
Position of the rating number text.

### rating.fontSize (number, default: 25, minimum: 1)
Font size for the rating number.

### rating.fontFamily (string, default: "Castellar")
Primary font name. WPF fallback chain handles missing fonts.

### rating.fontSource (string | null, default: null)
Path to a bundled .ttf/.otf font file within the overlay folder.

### rating.fontFallback (string, default: "Segoe UI")
Fallback font if primary isn't available.

### rating.textWidth (number, default: 55)
Width of the rating text bounding box.

### rating.textHeight (number, default: 46)
Height of the rating text bounding box.

### rating.textHorizontalAlignment (string, default: "Center")
`Left`, `Center`, `Right`, or `Stretch`.

### rating.textVerticalAlignment (string, default: "Center")
`Top`, `Center`, `Bottom`, or `Stretch`.

## title (TitleConfig, required)

Optional title text showing the media name.

### title.isVisible (bool, default: false)
Show/hide the title text.

### title.margin (string, default: "0,0,0,0")
Position via WPF Thickness.

### title.rotationAngle (number, default: 0, range: 0-360)
Rotation in degrees. Use 90 for DVD spine text.

### title.rotationOrigin (string, default: "0.5,0.5")
Pivot point as normalized coordinates "x,y" (0.0-1.0). `0.5,0.5` = center.

### title.fontFamily (string, default: "Cormorant")
Primary font name.

### title.fontSource (string | null, default: null)
Path to a bundled .ttf/.otf font file.

### title.fontFallback (string, default: "Segoe UI")
Fallback font.

### title.foreground (string, default: "White")
Text color. WPF color name (`"White"`, `"Gold"`) or hex (`"#FF5500"`, `"#80FFFFFF"`).

### title.trimming (string, default: "WordEllipsis")
`None`, `WordEllipsis`, or `CharacterEllipsis`.

### title.wrapping (string, default: "Wrap")
`NoWrap`, `Wrap`, or `WrapWithOverflow`.

### title.container (string, default: "Root")
`Root` (direct child of root Grid) or `RatingGrid` (inside rating Grid).

### title.gridRow (integer, default: 0, minimum: 0)
Grid row when container is `RatingGrid` (0, 1, or 2).

### title.horizontalAlignment (string, default: "Left")
`Left`, `Center`, `Right`, or `Stretch`.

### title.verticalAlignment (string, default: "Top")
`Top`, `Center`, `Bottom`, or `Stretch`.

## Image Path Resolution

Image paths are resolved in this order:
1. If path starts with `/` — treated as pack URI (built-in resources only)
2. If `_overlayFolderPath` is set — resolved against the overlay's folder
3. If path is absolute — used as-is
4. Otherwise — resolved against `AppContext.BaseDirectory`

**For community overlays, always use relative paths** (e.g. `"base.png"`, not `"/Resources/..."`)
