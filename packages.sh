#! /bin/bash

APT_PACKAGES=(
	"git"
	"vim"
	"tmux"
	"curl"
	"wget"
	"rofi"
	"ripgrep"
	"fd-find"
	"pavucontrol"
	"gammastep"
	"gawk"
	"rlwrap"
	"aspell"
	"translate-shell"
	"xclip"
)

package_list=""
for package in "${APT_PACKAGES[@]}"; do
	package_list="$package_list $package"
done

echo "Installing packages $package_list"
sudo apt install $package_list -y

SNAP_PACKAGES=(
	"tldr"
)

for package in "${SNAP_PACKAGES[@]}"; do
	sudo snap install "$package"
done

if [ ! -L "$HOME/.local/bin/fd" ]; then
	# According to the docs we have to override the already existing fd that comes preinstalled with ubuntu
	ln -s $(which fdfind) ~/.local/bin/fd
fi
