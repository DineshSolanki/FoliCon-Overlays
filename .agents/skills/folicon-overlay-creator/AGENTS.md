# folicon-overlay-creator

Interactive wizard for creating FoliCon poster icon overlays. Guides users through
designing overlay layout, generating all required JSON files, computing SHA256 hashes,
validating assets, and preparing for local testing or store submission.

## When to Use

- User wants to create a new FoliCon overlay
- User says "create overlay", "new overlay", "overlay wizard", "design overlay"
- User is working on poster icon overlays for FoliCon
- User wants to customize their media poster icon appearance

## What It Does

1. **Gathers concept** — name, author, description, visual style
2. **Recommends design pattern** — DVD case, rounded card, opacity mask, minimal, spine title
3. **Generates overlay.json** — complete layout definition with all fields
4. **Handles images** — guides user to create/provide base.png, front.png, preview.png
5. **Generates manifest.json** — metadata, assets list, SHA256 hashes
6. **Validates everything** — JSON syntax, required fields, image sizes, ID format
7. **Installs for testing** — places in FoliCon's user overlays directory
8. **Prepares for submission** — ready for PR to FoliCon-Overlays repo

## AI Handles

- All JSON generation (overlay.json, manifest.json)
- SHA256 hash computation for all assets
- Validation against schema and size limits
- File placement in correct directories
- Iteration and regeneration when user wants changes

## User Provides

- Creative concept (name, style, description)
- Image assets (base.png, front.png, preview.png) — created in any image editor
- Design feedback (adjust margins, enable title, change fonts, etc.)

## Activation

Invoke with `/folicon-overlay-creator` or say any of:
- "create an overlay"
- "new overlay"
- "overlay wizard"
- "design an overlay"
- "build an overlay"
- "make a custom overlay"

## Full Details

See `SKILL.md` for the complete workflow, design pattern defaults, validation rules,
and interactive behavior guidelines.
