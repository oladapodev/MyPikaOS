#!/bin/bash

# --- PikaOS Demon Slayer Setup Script ---
# This script automates the installation of themes, shell enhancements, and fonts.

set -e # Exit on error

echo "🚀 Starting PikaOS Customization Setup..."

# 1. Update and Install System Dependencies
echo "📦 Installing system dependencies..."
sudo apt update
sudo apt install -y curl git unzip sassc libfuse2t64 gnome-terminal wl-clipboard

# 2. Install Shell Enhancements
echo "🐚 Setting up Shell (Starship, Zoxide, Fzf, Eza, ble.sh)..."
# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y
# Zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
# Eza
mkdir -p ~/.local/bin
curl -L https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar -xz -C ~/.local/bin
# ble.sh
git clone https://github.com/akinomyoga/ble.sh.git --recursive --depth 1 /tmp/ble.sh
make -C /tmp/ble.sh install PREFIX=~/.local
# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# 3. Install Fonts (JetBrainsMono Nerd Font)
echo "🔡 Installing Nerd Fonts..."
mkdir -p ~/.local/share/fonts
curl -L -o /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMonoNerd
fc-cache -fv

# 4. Download and Install Themes
mkdir -p ~/.themes ~/.icons
echo "🎨 Downloading Themes and Icons..."

# Orchis GTK Theme
git clone --depth 1 https://github.com/vinceliuice/Orchis-theme.git /tmp/Orchis
cd /tmp/Orchis && ./install.sh -d ~/.themes -c dark -s compact
# WhiteSur GTK Theme
git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git /tmp/WhiteSur
cd /tmp/WhiteSur && ./install.sh -d ~/.themes -c dark
# Rounded Rectangle Shell Theme (Placeholder for the one you have)
# Assuming you keep it in your GitHub assets folder
cp -r ./configs/Rounded-Rectangle ~/.themes/ 2>/dev/null || true

# Icons
# (Add logic to download Slot-Beauty, Bibata, etc if links available, or copy from assets)
# For now, we assume icons are in the assets folder or repo

# 5. Apply Configs
echo "⚙️ Applying configurations..."
cp ./configs/bashrc ~/.bashrc
cp ./configs/fzf.bash ~/.fzf.bash 2>/dev/null || true
mkdir -p ~/.config
cp ./configs/starship.toml ~/.config/starship.toml 2>/dev/null || true
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
cp ./configs/gtk3.css ~/.config/gtk-3.0/gtk.css
cp ./configs/gtk4.css ~/.config/gtk-4.0/gtk.css

# Link GTK4 theme
mkdir -p ~/.config/gtk-4.0
ln -sf ~/.themes/WhiteSur-Dark/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
ln -sf ~/.themes/WhiteSur-Dark/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css
ln -sf ~/.themes/WhiteSur-Dark/gtk-4.0/assets ~/.config/gtk-4.0/assets

# 6. GNOME Settings
echo "🖥️ Setting GNOME Preferences..."
gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'FernBLZ'
gsettings set org.gnome.desktop.interface icon-theme 'Slot-Beauty-Dark-Icons'
gsettings set org.gnome.shell.extensions.user-theme name 'Orchis-Dark-Compact'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
gsettings set org.gnome.desktop.interface text-scaling-factor 0.8
gsettings set org.gnome.desktop.background picture-uri "file://$(pwd)/assets/wallpaper.png"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$(pwd)/assets/wallpaper.png"

# 7. rEFInd Setup
echo "🔑 Setting up rEFInd (Demon Slayer)..."
# (Logic to download rEFInd-demon-slayer repo and add include to refind.conf)
# sudo mkdir -p /boot/efi/EFI/refind/themes
# sudo cp -r ./rEFInd-demon-slayer/* /boot/efi/EFI/refind/themes/
# sudo cp ./assets/pika-logo.png /boot/efi/EFI/refind/themes/rEFInd-tanjiro/icons/os_linux.png

echo "✅ Setup Finished! Please restart your session."
echo "👉 Run 'gdm-settings' to sync your login screen theme."
