# FoliCon Overlay Creator

Interactive wizard for creating FoliCon poster icon overlays. Handles all technical work (JSON generation, SHA256 hashing, validation) while you focus on the creative design.

## What It Does

1. **Guides your design** — choose from DVD case, rounded card, opacity mask, minimal, or spine title patterns
2. **Generates overlay.json** — complete layout with all fields, margins, layer order
3. **Generates manifest.json** — metadata, asset list, SHA256 hashes
4. **Validates everything** — checks images, sizes, formats, field values
5. **Installs for testing** — places overlay in FoliCon's directory
6. **Prepares for submission** — ready for PR to the FoliCon-Overlays store

You only provide: the creative concept and your mockup images. The wizard handles the rest.

## Install

### Claude Code (recommended)
```bash
git clone <repo-url> ~/.claude/skills/folicon-overlay-creator
```

### VS Code Copilot
```bash
git clone <repo-url> .github/skills/folicon-overlay-creator
```

### Cursor
```bash
git clone <repo-url> .cursor/skills/folicon-overlay-creator
```

### Gemini CLI
```bash
git clone <repo-url> ~/.gemini/skills/folicon-overlay-creator
```

### Auto-detect (all platforms)
```bash
./folicon-overlay-creator/install.sh
```

### Specific platform
```bash
./folicon-overlay-creator/install.sh --platform cursor
./folicon-overlay-creator/install.sh --platform copilot
./folicon-overlay-creator/install.sh --platform gemini
```

### Install to all detected platforms
```bash
./folicon-overlay-creator/install.sh --all
```

## Usage

Type in your agent:

```
/folicon-overlay-creator
```

Or say any of:
- "create an overlay"
- "new overlay"
- "overlay wizard"
- "design an overlay"
- "build a custom overlay"

## What You Need

- **Your overlay concept** — name, style, description
- **Image assets** — PNG files for your mockup frame (base.png, front.png)
  - Created in any image editor (Photoshop, GIMP, Figma, etc.)
  - Max 2 MB per image, 5 MB total
  - PNG format with transparency for front layers
- **preview.png** — 256×256 preview for the store (optional, can be created later)

## Design Patterns

| Pattern | Description | Images Needed |
|---------|-------------|---------------|
| DVD/Blu-ray Case | Poster inside a physical media frame | base.png + front.png |
| Rounded Card | Clean poster with rounded corners | None |
| Window / Opacity Mask | Poster through a custom shape | base.png + mask.png |
| Minimal | Poster with just a rating badge | None |
| DVD with Spine Title | DVD case with rotated spine text | base.png + front.png |

## Validation Limits

| Limit | Value |
|-------|-------|
| Image format | PNG only |
| Max single image | 2 MB |
| Max total package | 5 MB |
| ID format | lowercase + hyphens |
| Version format | semver (1.0.0) |

## Documentation

- [Creating Overlays](../../../CREATING-OVERLAYS.md) — Full guide
- [Overlay Schema](../../../schemas/overlay-schema.json) — JSON Schema
- [Manifest Schema](../../../schemas/manifest-schema.json) — JSON Schema

## License

MIT
