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
)

for package in "${APT_PACKAGES[@]}"; do
	sudo apt install -y "$package"
done

SNAP_PACKAGES=(
	"tldr"
)

for package in "${SNAP_PACKAGES[@]}"; do
	sudo snap install -y "$package"
done

# According to the docs we have to override the already existing fd that comes preinstalled with ubuntu
ln -s $(which fdfind) ~/.local/bin/fd
