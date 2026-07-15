patch_configurations() {
    log_info "Iniciando parchado dinámico de configuraciones..."

    # 1. Asignar propiedad al usuario actual
    log_info "Ajustando permisos y propietario a $USER..."
    sudo chown -R $USER:$USER "$DOTFILES_DIR"

    # 2. Permisos de ejecución automáticos
    log_info "Otorgando permisos de ejecución a los scripts del sistema..."
    find "$DOTFILES_DIR" -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true
    chmod +x "$DOTFILES_DIR/config/bspwm/bspwmrc" 2>/dev/null || true
    chmod +x "$DOTFILES_DIR/config/sxhkd/sxhkdrc" 2>/dev/null || true
    if [ -d "$DOTFILES_DIR/config/scripts" ]; then chmod +x "$DOTFILES_DIR/config/scripts/"* 2>/dev/null || true; fi
    if [ -d "$DOTFILES_DIR/config/bin" ]; then chmod +x "$DOTFILES_DIR/config/bin/"* 2>/dev/null || true; fi
    if [ -d "$DOTFILES_DIR/config/polybar/scripts" ]; then chmod +x "$DOTFILES_DIR/config/polybar/scripts/"* 2>/dev/null || true; fi

    # 3. Adaptar rutas de /home/viejo a /home/nuevo
    log_info "Adaptando rutas de inicio al usuario actual ($USER)..."
    find "$DOTFILES_DIR" -type f \
        ! -path "*/.git/*" \
        ! -name "*.ttf" \
        ! -name "*.otf" \
        ! -name "*.png" \
        ! -name "*.jpg" \
        -exec sed -E -i "s|/home/[a-zA-Z0-9_-]+|$HOME|g" {} + 2>/dev/null || true

    # Parches específicos
    if [ -f "$DOTFILES_DIR/config/bspwm/bspwmrc" ]; then
        sed -i "s|/bin/feh --bg-fill.*|feh --bg-fill \$HOME/.config/bspwm/Fondo.jpg \&|g" "$DOTFILES_DIR/config/bspwm/bspwmrc"
    fi

    if [ -f "$DOTFILES_DIR/config/sxhkd/sxhkdrc" ]; then
        sed -i 's|/opt/kitty/bin/kitty|kitty|g' "$DOTFILES_DIR/config/sxhkd/sxhkdrc"
    fi

    for powermenu in "$DOTFILES_DIR/config/polybar/scripts/powermenu" "$DOTFILES_DIR/config/polybar/scripts/powermenu_alt"; do
        if [ -f "$powermenu" ]; then
            sed -i 's|openbox --exit|bspc quit|g' "$powermenu"
            sed -i 's|i3lock|i3lock-fancy|g' "$powermenu"
        fi
    done

    log_success "Parchado de archivos finalizado sin errores."
}
