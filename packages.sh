#! /bin/bash

APT_PACKAGES=(
	"git"
	"vim"
	"tmux"
	"curl"
	"wget"
	"rofi"
)

for package in "${APT_PACKAGES[@]}"; do
	sudo apt install -y "$package"
done
