#!/bin/bash

# Install latest Neovim and JetBrains Mono Nerd Font (no sudo required)
set -e

echo "=== Installing latest Neovim ==="

# Create directory for Neovim
NVIM_DIR="$HOME/.local/bin"
mkdir -p "$NVIM_DIR"

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
    NVIM_FOLDER="nvim-linux64"
elif [ "$ARCH" = "aarch64" ]; then
    NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz"
    NVIM_FOLDER="nvim-linux-arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Download and extract Neovim
echo "Downloading Neovim from $NVIM_URL..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
curl -LO "$NVIM_URL"
tar xzf "$(basename "$NVIM_URL")"

# Move to installation directory
echo "Installing to $NVIM_DIR..."
rm -rf "$NVIM_DIR/nvim"
mv "$NVIM_FOLDER" "$NVIM_DIR/nvim"

# Clean up
cd - >/dev/null
rm -rf "$TEMP_DIR"

echo "=== Installing JetBrains Mono Nerd Font ==="

# Create fonts directory
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Download JetBrains Mono Nerd Font
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "Downloading JetBrains Mono Nerd Font..."
curl -LO "$FONT_URL"
unzip -q JetBrainsMono.zip -d JetBrainsMono

# Install fonts (only .ttf files)
echo "Installing fonts to $FONT_DIR..."
find JetBrainsMono -name "*.ttf" -exec cp {} "$FONT_DIR/" \;

# Update font cache
echo "Updating font cache..."
fc-cache -f "$FONT_DIR"

# Clean up
cd - >/dev/null
rm -rf "$TEMP_DIR"

echo "=== Configuring Terminal Font ==="

# Try to set font for common terminals
set_gnome_terminal_font() {
    if command -v gsettings &>/dev/null; then
        # Get the default profile
        PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
        if [ -n "$PROFILE" ]; then
            gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false
            gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'JetBrainsMono Nerd Font Mono 11'
            echo "✓ Set font for GNOME Terminal"
            return 0
        fi
    fi
    return 1
}

set_konsole_font() {
    if command -v konsole &>/dev/null; then
        KONSOLE_DIR="$HOME/.local/share/konsole"
        mkdir -p "$KONSOLE_DIR"
        PROFILE="$KONSOLE_DIR/MyProfile.profile"

        cat >"$PROFILE" <<'EOF'
[Appearance]
Font=JetBrainsMono Nerd Font Mono,11,-1,5,50,0,0,0,0,0

[General]
Name=MyProfile
Parent=FALLBACK/
EOF
        echo "✓ Created Konsole profile with font"
        echo "  (You may need to select 'MyProfile' in Konsole settings)"
        return 0
    fi
    return 1
}

FONT_SET=false
set_gnome_terminal_font && FONT_SET=true
set_konsole_font && FONT_SET=true

if [ "$FONT_SET" = false ]; then
    echo "⚠ Could not auto-configure terminal font"
    echo "  Please manually set your terminal font to:"
    echo "  'JetBrainsMono Nerd Font Mono' or 'JetBrainsMonoNL Nerd Font Mono'"
fi

echo "=== Setting up Neovim alias ==="

# Add alias to shell config files
NVIM_BIN="$NVIM_DIR/nvim/bin/nvim"

# Detect shell and add alias
add_alias() {
    local config_file="$1"
    if [ -f "$config_file" ]; then
        # Remove old nvim alias if it exists
        sed -i.bak '/alias nvim=/d' "$config_file" 2>/dev/null || true
        # Add new alias
        echo "alias nvim='$NVIM_BIN'" >>"$config_file"
        echo "✓ Added alias to $config_file"
    fi
}

# Add to bash
add_alias "$HOME/.bashrc"

# Add to zsh if it exists
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    add_alias "$HOME/.zshrc"
fi

# Add to fish if it exists
if [ -d "$HOME/.config/fish" ]; then
    FISH_CONFIG="$HOME/.config/fish/config.fish"
    mkdir -p "$(dirname "$FISH_CONFIG")"
    touch "$FISH_CONFIG"
    sed -i.bak '/alias nvim=/d' "$FISH_CONFIG" 2>/dev/null || true
    echo "alias nvim='$NVIM_BIN'" >>"$FISH_CONFIG"
    echo "✓ Added alias to $FISH_CONFIG"
fi

echo ""
echo "======================================"
echo "✓ Installation complete!"
echo "======================================"
echo ""
echo "Neovim installed to: $NVIM_DIR/nvim"
echo "Font installed: JetBrains Mono Nerd Font"
echo ""
echo "To use Neovim now, either:"
echo "  1. Run: source ~/.bashrc (or ~/.zshrc)"
echo "  2. Open a new terminal"
echo "  3. Run directly: $NVIM_BIN"
echo ""
echo "Then type: nvim"
echo ""

echo "=== Installing Neovim Configuration ==="
echo ""

# Check if git is available
if ! which git >/dev/null 2>&1; then
    echo "⚠ Warning: git is not installed"
    echo "  Please install git to download the Neovim configuration:"
    echo "  - Ubuntu/Debian: apt install git"
    echo "  - Or download from: https://git-scm.com/downloads"
    echo ""
    echo "  After installing git, run: curl -L n.bnjz.org | sh"
    echo ""
    exit 0
fi

# Download and run the config installation script
echo "Downloading and installing Neovim configuration..."
if curl -fsSL https://raw.githubusercontent.com/BenJurewicz/neovim-config/refs/heads/main/install.sh | sh; then
    echo ""
    echo "✓ Neovim configuration installed successfully!"
else
    echo ""
    echo "⚠ Failed to install Neovim configuration"
    echo "  You can try manually by running: curl -L https://raw.githubusercontent.com/BenJurewicz/neovim-config/refs/heads/main/install.sh | sh"
fi

echo ""
echo "======================================"
echo "✓ All done!"
echo "======================================"
echo ""

