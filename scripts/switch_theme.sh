#!/bin/bash
# scripts/switch_theme.sh

THEME="$1"
DOTFILES_DIR="$HOME/dotfiles"
WALLPAPER_DIR="$DOTFILES_DIR/wallpapers"
HYPR_CONF_DIR="$HOME/.config/hypr"

# Validação
if [ -z "$THEME" ]; then
	echo "Error: No theme specified."
	echo "Usage: $0 [dark-red|dark-blue|nature-green|abstract-light]"
	exit 1
fi

echo "Swapping to theme: $THEME"

# 1. Identificar Wallpaper (PNG ou JPG)
WALLPAPER=""
if [ -f "$WALLPAPER_DIR/$THEME.png" ]; then
    WALLPAPER="$WALLPAPER_DIR/$THEME.png"
elif [ -f "$WALLPAPER_DIR/$THEME.jpg" ]; then
    WALLPAPER="$WALLPAPER_DIR/$THEME.jpg"
fi

if [ -n "$WALLPAPER" ]; then
    echo "Setting wallpaper: $WALLPAPER"
    
    # A: Aplica imediatamente (Runtime)
    hyprctl hyprpaper preload "$WALLPAPER"
    hyprctl hyprpaper wallpaper ",$WALLPAPER"
    
    # B: Garante persistência no reboot (Config file)
    # Sobrescreve o hyprpaper.conf para carregar este wallpaper na próxima vez
    echo "preload = $WALLPAPER" > "$HYPR_CONF_DIR/hyprpaper.conf"
    echo "wallpaper = , $WALLPAPER" >> "$HYPR_CONF_DIR/hyprpaper.conf"
    echo "ipc = on" >> "$HYPR_CONF_DIR/hyprpaper.conf"
else
    echo "Warning: Wallpaper not found for $THEME."
fi

# 2. Waybar
ln -sf "$DOTFILES_DIR/config/waybar/style-$THEME.css" "$HOME/.config/waybar/style.css"
pkill waybar && waybar &

# 3. Kitty
ln -sf "$DOTFILES_DIR/config/kitty/themes/$THEME.conf" "$HOME/.config/kitty/theme.conf"
# Recarrega instâncias do Kitty
killall -SIGUSR1 kitty 2>/dev/null

# 4. Rofi
ln -sf "$DOTFILES_DIR/config/rofi/colors-$THEME.rasi" "$HOME/.config/rofi/colors.rasi"

# 5. Notificação
notify-send "Theme Switched" "Active theme: $THEME"
