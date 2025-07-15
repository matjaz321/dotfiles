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
