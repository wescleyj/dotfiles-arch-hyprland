#!/bin/bash
# scripts/switch_theme.sh
# Usage: ./switch_theme.sh [theme_name]
# Example: ./switch_theme.sh dark-blue

THEME="$1"
WALLPAPER_DIR="$HOME/dotfiles/wallpapers"

# Validation
if [ -z "$THEME" ]; then
	echo "Error: No theme specified."
	echo "Usage: $0 [dark-blue|nature-green|abstract-light]"
	exit 1
fi

# 1. Set Wallpaper (using hyprpaper as example, adjust for swww or swaybg)
# Assumes wallpapers are named like 'dark-blue.png'
if [ -f "$WALLPAPER_DIR/$THEME.png" ]; then
	echo "Setting wallpaper..."
	# Kill old instance and start new one (simple method)
	pkill hyprpaper
	hyprctl hyprpaper preload "$WALLPAPER_DIR/$THEME.png"
	hyprctl hyprpaper wallpaper ",$WALLPAPER_DIR/$THEME.png"
else
	echo "Warning: Wallpaper $THEME.png not found."
fi

# 2. Switch Waybar Style
# This assumes you have style-theme.css files in ~/.config/waybar/
echo "Updating Waybar..."
ln -sf "$HOME/.config/waybar/style-$THEME.css" "$HOME/.config/waybar/style.css"
# Reload Waybar
pkill waybar && waybar &

# 3. Switch Kitty Theme
# Assumes you have theme files in ~/.config/kitty/themes/
echo "Updating Kitty..."
ln -sf "$HOME/.config/kitty/themes/$THEME.conf" "$HOME/.config/kitty/theme.conf"
# Reload active Kitty instances
killall -SIGUSR1 kitty

# 4. Send Notification
notify-send "Theme Changed" "Active theme: $THEME"

echo "Theme switched to $THEME"

