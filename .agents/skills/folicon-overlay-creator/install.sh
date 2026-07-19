#!/usr/bin/env bash
# install.sh — Cross-platform installer for folicon-overlay-creator skill
set -euo pipefail

SKILL_NAME="folicon-overlay-creator"
SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect platform and install path
install_path=""
platform=""

detect_and_install() {
    # Claude Code (user-level)
    if [ -d "$HOME/.claude" ]; then
        install_path="$HOME/.claude/skills/$SKILL_NAME"
        platform="claude-code"
    # Claude Code (Windows)
    elif [ -d "$USERPROFILE/.claude" ] 2>/dev/null; then
        install_path="$USERPROFILE/.claude/skills/$SKILL_NAME"
        platform="claude-code"
    # GitHub Copilot CLI
    elif [ -d "$HOME/.copilot" ]; then
        install_path="$HOME/.copilot/skills/$SKILL_NAME"
        platform="copilot"
    # Gemini CLI
    elif [ -d "$HOME/.gemini" ]; then
        install_path="$HOME/.gemini/skills/$SKILL_NAME"
        platform="gemini"
    # Cline
    elif [ -d "$HOME/.cline" ]; then
        install_path="$HOME/.cline/skills/$SKILL_NAME"
        platform="cline"
    # Roo Code
    elif [ -d "$HOME/.roo" ]; then
        install_path="$HOME/.roo/skills/$SKILL_NAME"
        platform="roo-code"
    # Goose
    elif [ -d "$HOME/.config/goose" ]; then
        install_path="$HOME/.config/goose/skills/$SKILL_NAME"
        platform="goose"
    # OpenCode
    elif [ -d "$HOME/.config/opencode" ]; then
        install_path="$HOME/.config/opencode/skills/$SKILL_NAME"
        platform="opencode"
    # Universal fallback
    else
        install_path="$HOME/.agents/skills/$SKILL_NAME"
        platform="universal"
    fi
}

# Parse arguments
case "${1:-auto}" in
    --platform)
        case "${2:-}" in
            claude-code)  install_path="$HOME/.claude/skills/$SKILL_NAME" ;;
            copilot)      install_path="$HOME/.copilot/skills/$SKILL_NAME" ;;
            gemini)       install_path="$HOME/.gemini/skills/$SKILL_NAME" ;;
            cline)        install_path="$HOME/.cline/skills/$SKILL_NAME" ;;
            roo-code)     install_path="$HOME/.roo/skills/$SKILL_NAME" ;;
            goose)        install_path="$HOME/.config/goose/skills/$SKILL_NAME" ;;
            opencode)     install_path="$HOME/.config/opencode/skills/$SKILL_NAME" ;;
            universal)    install_path="$HOME/.agents/skills/$SKILL_NAME" ;;
            *)            echo "Unknown platform: ${2:-}"; exit 1 ;;
        esac
        platform="${2:-}"
        ;;
    --all)
        echo "Installing to all detected platforms..."
        for dir in "$HOME/.claude" "$HOME/.copilot" "$HOME/.gemini" "$HOME/.cline" "$HOME/.roo"; do
            if [ -d "$dir" ]; then
                target="$dir/skills/$SKILL_NAME"
                mkdir -p "$(dirname "$target")"
                cp -R "$SKILL_DIR" "$target"
                echo "  Installed to: $target"
            fi
        done
        # Always install to universal path
        mkdir -p "$HOME/.agents/skills"
        cp -R "$SKILL_DIR" "$HOME/.agents/skills/$SKILL_NAME"
        echo "  Installed to: $HOME/.agents/skills/$SKILL_NAME"
        echo "Done!"
        exit 0
        ;;
    --dry-run)
        detect_and_install
        echo "Would install to: $install_path"
        echo "Platform: $platform"
        echo "Files:"
        find "$SKILL_DIR" -type f | sed "s|$SKILL_DIR|  .|"
        exit 0
        ;;
    auto|*)
        detect_and_install
        ;;
esac

# Install
mkdir -p "$(dirname "$install_path")"
cp -R "$SKILL_DIR" "$install_path"

echo "Installed $SKILL_NAME to: $install_path"
echo "Platform: $platform"
echo ""
echo "To use it, type in your agent:"
echo "  /$SKILL_NAME"
echo ""
echo "Or say: 'create a new overlay'"
