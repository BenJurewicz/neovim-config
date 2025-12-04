#!/bin/bash
set -e

REPO_URL="https://github.com/BenJurewicz/neovim-config"
INSTALL_DIR="$HOME/.config/nvim"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

echo "Installation complete"
