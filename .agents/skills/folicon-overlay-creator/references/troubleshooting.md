# Troubleshooting

Common issues when creating FoliCon overlays and how to fix them.

## Validation Errors

### "Overlay 'id' contains invalid characters"
**Cause:** The ID has uppercase, underscores, spaces, or special characters.
**Fix:** Use only lowercase letters, numbers, and hyphens. Must start and end with a letter or number.
- Bad: `My_Overlay`, `my overlay!`, `-my-overlay-`
- Good: `my-overlay`, `retro-vhs-2`, `example-dvd-case`

### "overlay 'id' 'X' is a reserved built-in ID"
**Cause:** The ID matches one of the built-in overlay IDs.
**Fix:** Choose a different ID. Reserved: `legacy`, `alternate`, `liaher`, `faelpessoal`, `faelpessoal-horizontal`, `windows11`.

### "baseLayer.imagePath 'X.png' file not found"
**Cause:** The image file doesn't exist in the overlay folder, or the filename is wrong.
**Fix:**
1. Check the filename matches exactly (case-sensitive on Linux!)
2. Ensure the file is in the same folder as overlay.json
3. For community overlays, use relative paths: `"base.png"`, not `"/Resources/..."`

### "poster.margin is not a valid Thickness string"
**Cause:** The margin format is wrong.
**Fix:** Use comma-separated numbers: `"left,top,right,bottom"`.
- Bad: `"10px,20px"`, `"10 20 30 40"`, `"left:10,top:20"`
- Good: `"10,20,30,40"`, `"10,20"`, `"15"`

### "Overlay folder exceeds maximum total size"
**Cause:** Total package > 5 MB.
**Fix:** Compress your PNG images:
- Use [pngquant](https://pngquant.org/): `pngquant --quality=65-80 image.png`
- Use [TinyPNG](https://tinypng.com/) (web-based)
- Reduce image dimensions if larger than needed
- Use 8-bit PNG instead of 32-bit if you don't need full alpha

### "image 'X.png' exceeds maximum size (Y MB > 2 MB)"
**Cause:** Single image file > 2 MB.
**Fix:** Same as above — compress or reduce dimensions.

## Image Issues

### Poster doesn't show through the frame
**Cause:** The base layer image doesn't have transparency where the poster should appear.
**Fix:** In your image editor, make the poster window area transparent (delete/clear those pixels). The poster shows through transparent areas of the base layer.

### Front layer doesn't overlay correctly
**Cause:** The front layer margin doesn't align with the base layer.
**Fix:** Adjust the front layer margin to match the physical overlay position. Both layers should share roughly the same coordinate space.

### Poster looks stretched or squished
**Cause:** The poster aspect ratio doesn't match the margin-defined area.
**Fix:** This is normal — FoliCon uses `Stretch.Fill` to fill the area. Adjust margins to change the poster area's aspect ratio.

### Opacity mask doesn't work as expected
**Cause:** The mask image isn't grayscale, or the dimensions don't match.
**Fix:**
1. Use pure grayscale (white = visible, black = hidden)
2. The mask should cover the same area as the poster
3. Use gradients for smooth transitions

## Rating Badge Issues

### Rating number overlaps the poster
**Cause:** The rating margins position it inside the poster area.
**Fix:** Adjust `rating.shieldMargin` and `rating.textMargin` to move the badge to a clear area.

### Rating font looks wrong
**Cause:** The specified font isn't installed on the system.
**Fix:** Either install the font, or use `fontFallback` for a system font, or bundle the font as `fontSource`.

## Title Text Issues

### Title text is not visible
**Cause:** `title.isVisible` is `false` (default).
**Fix:** Set `"isVisible": true` in the title config.

### Title text is clipped or truncated
**Cause:** The text area is too small, or `trimming` cuts it off.
**Fix:** Adjust `margin` to give more space, or change `trimming` to `"None"`.

### Rotated title is positioned wrong
**Cause:** The rotation origin or margin doesn't account for the rotation.
**Fix:** Adjust the margin after rotating. Rotation happens around `rotationOrigin` (default center), so the text shifts. Use trial and error with small margin adjustments.

## Layer Order Issues

### Front layer appears behind the poster
**Cause:** `layerOrder` has `front` before `poster`.
**Fix:** Ensure the order is `["base", "poster", "front", "rating", "title"]` — front must come AFTER poster.

### Rating badge appears behind the poster
**Cause:** `layerOrder` has `rating` before `poster`.
**Fix:** Move `rating` after `poster` in the layer order.

## SHA256 Issues

### "SHA256 mismatch for 'X'"
**Cause:** The hash in manifest.json doesn't match the actual file hash.
**Fix:** Recompute the hash after any file change:
```powershell
# Windows
Get-FileHash -Algorithm SHA256 -Path overlay.json | Select-Object -ExpandProperty Hash

# Linux/macOS
sha256sum overlay.json
```

### Hash format error
**Cause:** The hash isn't 64 lowercase hex characters.
**Fix:** Ensure the hash is lowercase and exactly 64 characters. Convert uppercase to lowercase.

## Testing Issues

### Overlay doesn't appear in FoliCon settings
**Cause:** The overlay folder isn't in the right location, or overlay.json is invalid.
**Fix:**
1. Check the folder is at `%AppData%/FoliCon/Overlays/{your-id}/`
2. Ensure `overlay.json` exists in the folder root
3. Ensure the JSON is valid (no syntax errors)
4. Restart FoliCon after adding/modifying overlays

### Preview image doesn't show in the store
**Cause:** `previewImage` in manifest.json doesn't match the actual filename.
**Fix:** Ensure the filename in manifest.json matches exactly: `"previewImage": "preview.png"`.

### Installed overlay shows "no preview" in settings
**Cause:** The overlay folder doesn't contain a `preview.png`.
**Fix:** Add a `preview.png` (256×256) to the overlay folder.

## Updating an Overlay

When updating an existing overlay:
1. Bump `overlayVersion` in overlay.json (e.g. `1.0.0` → `1.1.0`)
2. Bump `overlayVersion` in manifest.json to match
3. Update `updatedAt` timestamp
4. Recompute SHA256 hashes for ALL changed files
5. Update the `assets` list if files were added/removed
