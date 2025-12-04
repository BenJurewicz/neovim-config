#!/bin/bash

# Uninstall Neovim, fonts, and configuration
set -e

echo "=== Uninstalling Neovim Setup ==="
echo ""

# Remove Neovim
NVIM_DIR="$HOME/.local/bin/nvim"
if [ -d "$NVIM_DIR" ]; then
    echo "Removing Neovim from $NVIM_DIR..."
    rm -rf "$NVIM_DIR"
    echo "✓ Neovim removed"
else
    echo "⊘ Neovim directory not found"
fi

# Remove Neovim configuration
NVIM_CONFIG="$HOME/.config/nvim"
if [ -d "$NVIM_CONFIG" ]; then
    echo "Removing Neovim configuration from $NVIM_CONFIG..."
    rm -rf "$NVIM_CONFIG"
    echo "✓ Neovim configuration removed"
else
    echo "⊘ Neovim configuration not found"
fi

# Remove Neovim data/cache/state
NVIM_DATA="$HOME/.local/share/nvim"
NVIM_STATE="$HOME/.local/state/nvim"
NVIM_CACHE="$HOME/.cache/nvim"

if [ -d "$NVIM_DATA" ]; then
    echo "Removing Neovim data from $NVIM_DATA..."
    rm -rf "$NVIM_DATA"
    echo "✓ Neovim data removed"
fi

if [ -d "$NVIM_STATE" ]; then
    echo "Removing Neovim state from $NVIM_STATE..."
    rm -rf "$NVIM_STATE"
    echo "✓ Neovim state removed"
fi

if [ -d "$NVIM_CACHE" ]; then
    echo "Removing Neovim cache from $NVIM_CACHE..."
    rm -rf "$NVIM_CACHE"
    echo "✓ Neovim cache removed"
fi

# Remove JetBrains Mono Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
echo "Removing JetBrains Mono Nerd Fonts..."
find "$FONT_DIR" -name "*JetBrains*" -delete 2>/dev/null || true
echo "✓ JetBrains Mono Nerd Fonts removed"

# Update font cache
if command -v fc-cache &>/dev/null; then
    echo "Updating font cache..."
    fc-cache -f "$FONT_DIR"
    echo "✓ Font cache updated"
fi

# Remove nvim alias from shell configs
remove_alias() {
    local config_file="$1"
    if [ -f "$config_file" ]; then
        if grep -q "alias nvim=" "$config_file"; then
            sed -i.bak '/alias nvim=/d' "$config_file" 2>/dev/null || true
            echo "✓ Removed alias from $config_file"
        fi
    fi
}

echo "Removing nvim aliases from shell configs..."
remove_alias "$HOME/.bashrc"
remove_alias "$HOME/.zshrc"

# Remove from fish
FISH_CONFIG="$HOME/.config/fish/config.fish"
if [ -f "$FISH_CONFIG" ]; then
    if grep -q "alias nvim=" "$FISH_CONFIG"; then
        sed -i.bak '/alias nvim=/d' "$FISH_CONFIG" 2>/dev/null || true
        echo "✓ Removed alias from $FISH_CONFIG"
    fi
fi

echo ""
echo "======================================"
echo "✓ Uninstallation complete!"
echo "======================================"
echo ""
echo "Removed:"
echo "  - Neovim installation"
echo "  - Neovim configuration"
echo "  - Neovim data, cache, and state"
echo "  - JetBrains Mono Nerd Fonts"
echo "  - nvim aliases from shell configs"
echo ""
echo "Note: Terminal font settings were not changed."
echo "You may want to manually reset your terminal font."
echo ""
echo "To apply alias removal, run: source ~/.bashrc (or ~/.zshrc)"
echo "Or simply open a new terminal."
echo ""
