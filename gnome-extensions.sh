#!/usr/bin/bash

# Install gnomme-shell-extensions
sudo apt install gnome-shell-extensions

# Update the ghostty terminal prio to 10
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /snap/ghostty/current/bin/ghostty 10

# install the hite-top-bar extension
sudo apt install gnome-shell-extension-autohidetopbar

# Disable dock
gnome-extensions disable ubuntu-dock@ubuntu.com

# Set ghostty as default term
gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'

# enable hide-top-bar extension
gnome-extensions enable hidetopbar@mathieu.bidon.ca

gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/keyboardlayoutswitch/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/keyboardlayoutswitch/ name "Switch Keyboard Layout"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/keyboardlayoutswitch/ command "$HOME/.config/polybar/scripts/keyboard_layout_switcher.sh toggle"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/keyboardlayoutswitch/ binding "<Alt>space"

echo "Layout switching script created and bound to Alt+Space"


