#!/bin/bash
# scripts/switch_theme.sh

THEME="$1"
DOTFILES_DIR="$HOME/dotfiles"
WALLPAPER_DIR="$DOTFILES_DIR/wallpapers"

# Validação
if [ -z "$THEME" ]; then
	echo "Error: No theme specified."
	echo "Usage: $0 [dark-red|dark-blue|nature-green|abstract-light]"
	exit 1
fi

echo "Swapping to theme: $THEME"

# 1. Wallpaper (Suporte a PNG e JPG)
WALLPAPER=""
if [ -f "$WALLPAPER_DIR/$THEME.png" ]; then
    WALLPAPER="$WALLPAPER_DIR/$THEME.png"
elif [ -f "$WALLPAPER_DIR/$THEME.jpg" ]; then
    WALLPAPER="$WALLPAPER_DIR/$THEME.jpg"
fi

if [ -n "$WALLPAPER" ]; then
    echo "Setting wallpaper: $WALLPAPER"
    # Pré-carrega e define o novo wallpaper
    hyprctl hyprpaper preload "$WALLPAPER"
    hyprctl hyprpaper wallpaper ",$WALLPAPER"
else
    echo "Warning: Wallpaper not found for $THEME (checked .png and .jpg in $WALLPAPER_DIR)."
fi

# 2. Waybar
ln -sf "$DOTFILES_DIR/config/waybar/style-$THEME.css" "$HOME/.config/waybar/style.css"
pkill waybar && waybar &

# 3. Kitty
ln -sf "$DOTFILES_DIR/config/kitty/themes/$THEME.conf" "$HOME/.config/kitty/theme.conf"
killall -SIGUSR1 kitty 2>/dev/null

# 4. Rofi
ln -sf "$DOTFILES_DIR/config/rofi/colors-$THEME.rasi" "$HOME/.config/rofi/colors.rasi"

# 5. Notificação
notify-send "Theme Switched" "Active theme: $THEME"
