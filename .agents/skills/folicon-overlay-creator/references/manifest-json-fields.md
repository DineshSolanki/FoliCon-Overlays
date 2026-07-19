# manifest.json — Complete Field Reference

The manifest provides metadata for the Overlay Store and integrity verification.

## Fields

### schemaVersion (integer, required)
Must be `1`.

### id (string, required)
Must match folder name and overlay.json id. Same rules as overlay.json id.
Pattern: `^[a-z0-9][a-z0-9-]*[a-z0-9]$`, 2-50 characters.

### displayName (string, required)
Human-readable name, 1-100 characters.

### author (string, required)
Author name or GitHub username, 1-100 characters.

### description (string, optional)
Brief description, max 500 characters.

### overlayVersion (string, required)
Semantic version for update detection. Pattern: `^\d+\.\d+\.\d+$`.

### tags (string[], optional)
Category tags for store filtering. Max 10 tags, each max 30 characters.

### previewImage (string, optional)
Relative path to preview image within the overlay folder. Usually `"preview.png"`.

### assets (string[], required)
List of ALL files in the overlay folder. Must include `"overlay.json"`.
Min 1 item. Example: `["overlay.json", "base.png", "front.png", "preview.png"]`.

### sha256 (object, required)
Per-file SHA256 hashes. Key = filename, value = hex-encoded hash (64 lowercase chars).
Pattern for values: `^[a-f0-9]{64}$`.

Example:
```json
"sha256": {
  "overlay.json": "abc123def456...",
  "base.png": "789abc012def..."
}
```

### sizeBytes (integer, optional)
Total download size in bytes. Max 5,242,880 (5 MB).
**Computed automatically by CI** — set to 0 or omit.

### createdAt (string, optional)
ISO 8601 creation timestamp. Example: `"2026-07-20T00:00:00Z"`.

### updatedAt (string, optional)
ISO 8601 last update timestamp.

## Computing SHA256 Hashes

### Windows (PowerShell)
```powershell
Get-FileHash -Algorithm SHA256 -Path overlay.json | Select-Object -ExpandProperty Hash
# For multiple files:
Get-ChildItem *.png, overlay.json | ForEach-Object { "$($_.Name): $((Get-FileHash $_.FullName -Algorithm SHA256).Hash.ToLower())" }
```

### Linux/macOS
```bash
sha256sum overlay.json base.png front.png preview.png
```

### Important Notes
- Hash values must be lowercase hex (64 characters)
- Hash every file listed in `assets`
- Recompute hashes when any file changes
- The CI does NOT compute hashes — you must provide them

## Complete Example

```json
{
  "schemaVersion": 1,
  "id": "retro-vhs",
  "displayName": "Retro VHS",
  "author": "YourName",
  "description": "80s VHS tape aesthetic with scan lines and retro frame",
  "overlayVersion": "1.0.0",
  "tags": ["retro", "vhs", "80s"],
  "previewImage": "preview.png",
  "assets": ["overlay.json", "base.png", "front.png", "preview.png"],
  "sha256": {
    "overlay.json": "a1b2c3d4e5f6...",
    "base.png": "f6e5d4c3b2a1...",
    "front.png": "1a2b3c4d5e6f...",
    "preview.png": "6f5e4d3c2b1a..."
  },
  "sizeBytes": 0,
  "createdAt": "2026-07-20T00:00:00Z",
  "updatedAt": "2026-07-20T00:00:00Z"
}
```

## What the CI Does

When you push to the FoliCon-Overlays repository, the GitHub Action:
1. Reads every `manifest.json` under `overlays/`
2. Computes `sizeBytes` automatically from actual file sizes
3. Generates `catalog.json` at the repository root
4. Commits the updated catalog

You do NOT need to manually set `sizeBytes` — leave it as 0.
