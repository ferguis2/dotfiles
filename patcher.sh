patch_configurations() {
    log_info "Iniciando parchado dinámico de configuraciones..."

    # 1. Reemplazo dinámico universal de rutas de usuario en archivos de configuración planos.
    # Corrige automáticamente referencias obsoletas a directorios personales en .zshrc, scripts de red, bookmarks de thunar, etc.
    log_info "Adaptando rutas de inicio al usuario actual ($USER)..."
    find "$DOTFILES_DIR" -type f \
        ! -path "*/.git/*" \
        ! -name "*.ttf" \
        ! -name "*.otf" \
        ! -name "*.png" \
        ! -name "*.jpg" \
        -exec sed -E -i "s|/home/[a-zA-Z0-9_-]+|$HOME|g" {} + 2>/dev/null || true

    # 2. Corregir fondo de pantalla en bspwmrc
    if [ -f "$DOTFILES_DIR/config/bspwm/bspwmrc" ]; then
        log_info "Parcheando bspwmrc para usar Fondo.jpg relativo..."
        sed -i "s|/bin/feh --bg-fill.*|feh --bg-fill \$HOME/.config/bspwm/Fondo.jpg \&|g" "$DOTFILES_DIR/config/bspwm/bspwmrc"
    fi

    # 3. Corregir ruta absoluta de Kitty en sxhkdrc
    if [ -f "$DOTFILES_DIR/config/sxhkd/sxhkdrc" ]; then
        log_info "Parcheando ejecutable de Kitty en sxhkdrc..."
        sed -i 's|/opt/kitty/bin/kitty|kitty|g' "$DOTFILES_DIR/config/sxhkd/sxhkdrc"
    fi

    # 4. Corregir comandos de salida y bloqueo en menús de Rofi (Powerbar)
    for powermenu in "$DOTFILES_DIR/config/polybar/scripts/powermenu" "$DOTFILES_DIR/config/polybar/scripts/powermenu_alt"; do
        if [ -f "$powermenu" ]; then
            log_info "Parcheando comandos de cierre de sesión en $(basename "$powermenu")..."
            sed -i 's|openbox --exit|bspc quit|g' "$powermenu"
            sed -i 's|i3lock|i3lock-fancy|g' "$powermenu"
        fi
    done

    log_success "Parchado de archivos finalizado sin errores."
}
