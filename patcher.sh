patch_configurations() {
    log_info "Iniciando parchado dinámico de configuraciones..."

    # 1. Asignar propiedad al usuario actual (adiós al usuario 'xoe')
    log_info "Ajustando permisos y propietario a $USER..."
    sudo chown -R $USER:$USER "$DOTFILES_DIR"

    # 2. Dar permisos de ejecución automáticamente a todo lo que sea script
    log_info "Otorgando permisos de ejecución a los módulos de Polybar y BSPWM..."
    find "$DOTFILES_DIR" -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true
    chmod +x "$DOTFILES_DIR/config/scripts/"* 2>/dev/null || true
    chmod +x "$DOTFILES_DIR/config/bin/"* 2>/dev/null || true

    # 3. Corrección dinámica de rutas (cambia /home/xoe a /home/tu_usuario_actual)
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
