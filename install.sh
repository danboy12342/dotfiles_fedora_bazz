#!/usr/bin/env bash
set -e
DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Restoring Bazzite setup..."

# 1. Restore Homebrew packages
if command -v brew &>/dev/null; then
  echo "Installing Homebrew packages from Brewfile..."
  brew bundle --file="$DOTDIR/Brewfile"
fi

# 2. Restore Flatpaks
if [ -f "$DOTDIR/flatpaks.txt" ]; then
  echo "Installing Flatpaks..."
  while read -r app; do
    [ -n "$app" ] && flatpak install -y flathub "$app" || true
  done < "$DOTDIR/flatpaks.txt"
fi

# 3. Restore Config files
echo "Restoring configuration files..."
mkdir -p ~/.config ~/.local/lib64/qt6/plugins/kwin/effects/plugins ~/.var/app/menu.kando.Kando/config/kando

cp -r "$DOTDIR/config/"* ~/.config/
cp "$DOTDIR/shell/.bashrc" ~/.bashrc

# Kando
[ -f "$DOTDIR/kando/menus.json" ] && cp "$DOTDIR/kando/menus.json" ~/.var/app/menu.kando.Kando/config/kando/menus.json
[ -f "$DOTDIR/local/kwin_plugins/kandointegration.so" ] && \
  cp "$DOTDIR/local/kwin_plugins/kandointegration.so" ~/.local/lib64/qt6/plugins/kwin/effects/plugins/

# KDE settings
[ -d "$DOTDIR/kde" ] && cp -r "$DOTDIR/kde/"* ~/.config/

echo "✔ Restoration complete! Please log out and back in to apply desktop panels and KWin effects."
