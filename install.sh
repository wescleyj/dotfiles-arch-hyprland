#!/bin/bash
# install.sh

# Variables
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# List of configs to manage (folder names inside config/)
CONFIGS=("hypr" "waybar" "rofi" "kitty" "mako")

echo "Starting dotfiles installation..."

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "Backup directory created at $BACKUP_DIR"

for app in "${CONFIGS[@]}"; do
	target="$CONFIG_DIR/$app"
	source="$DOTFILES_DIR/config/$app"

	# Check if source exists
	if [ -d "$source" ]; then
		# Backup existing config if it exists and is not a symlink
		if [ -d "$target" ] && [ ! -L "$target" ]; then
			echo "Backing up existing $app config..."
			mv "$target" "$BACKUP_DIR/"
		elif [ -L "$target" ]; then
			echo "Removing existing symlink for $app..."
			rm "$target"
		fi

		# Create symlink
		echo "Linking $app..."
		ln -s "$source" "$target"
	else
		echo "Warning: Source config for $app not found in repository."
	fi
done

echo "Done! Please restart Hyprland."
