#! /usr/bin/bash

sudo apt install gettext # dependency

# Download the extension
git clone https://gitlab.gnome.org/tuxor1337/hidetopbar.git

cd hidetopbar
make
gnome-extensions install ./hidetopbar.zip


echo -e "Restart the gnome session after the script is finished running"

# Enable the extension
gnome-extensions enable hidetopbar@mathieu.bidon.ca

# Copy the preset config
cp -a Settings.ui .local/share/gnome-shell/extensions/hidetopbar\@mathieu.bidon.ca/
