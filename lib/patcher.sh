patch_configurations() {
    log_info "Iniciando súper-parchado dinámico..."

    # 1. Asignar propiedad al usuario actual
    sudo chown -R $USER:$USER "$DOTFILES_DIR"

    # 2. Otorgar permisos de ejecución absolutos
    log_info "Ajustando permisos de ejecución..."
    find "$DOTFILES_DIR" -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true
    chmod +x "$DOTFILES_DIR/config/bspwm/bspwmrc" 2>/dev/null || true
    chmod +x "$DOTFILES_DIR/config/sxhkd/sxhkdrc" 2>/dev/null || true
    [ -d "$DOTFILES_DIR/config/scripts" ] && chmod +x "$DOTFILES_DIR/config/scripts/"* 2>/dev/null || true
    [ -d "$DOTFILES_DIR/config/bin" ] && chmod +x "$DOTFILES_DIR/config/bin/"* 2>/dev/null || true
    [ -d "$DOTFILES_DIR/config/polybar/scripts" ] && chmod +x "$DOTFILES_DIR/config/polybar/scripts/"* 2>/dev/null || true

    # 3. Corrección dinámica de rutas del usuario antiguo
    log_info "Adaptando rutas de sistema..."
    find "$DOTFILES_DIR" -type f \
        ! -path "*/.git/*" ! -name "*.ttf" ! -name "*.otf" ! -name "*.png" ! -name "*.jpg" ! -name "*.zip" \
        -exec sed -E -i "s|/home/[a-zA-Z0-9_-]+|$HOME|g" {} + 2>/dev/null || true

    # 4. PARCHE AUTOMÁTICO: Arreglar error silencioso de fzf en Zshrc
    if [ -f "$DOTFILES_DIR/home/.zshrc" ]; then
        sed -i 's|\[ -f ~/.fzf.zsh \] && source ~/.fzf.zsh|[ -f ~/.fzf.zsh ] \&\& source ~/.fzf.zsh \|\| true|g' "$DOTFILES_DIR/home/.zshrc"
    fi

    # 5. PARCHE AUTOMÁTICO: Inyectar fuente feather en Polybar si falta
    local polybar_conf="$DOTFILES_DIR/config/polybar/current.ini"
    if [ -f "$polybar_conf" ]; then
        # Borra declaraciones viejas de feather para evitar duplicados
        sed -i '/font-.*feather/d' "$polybar_conf"
        # Inyecta las fuentes correctas justo después de la font-7
        sed -i '/font-7 =/a font-8 = "feather:style=Regular:size=12;3"\nfont-9 = "Font Awesome 6 Free:style=Solid:size=10;3"' "$polybar_conf"
    fi

    # 6. PARCHE AUTOMÁTICO: Fondo de pantalla en BSPWM
    if [ -f "$DOTFILES_DIR/config/bspwm/bspwmrc" ]; then
        sed -i "s|/bin/feh --bg-fill.*|feh --bg-fill \$HOME/.config/bspwm/Fondo.jpg \&|g" "$DOTFILES_DIR/config/bspwm/bspwmrc"
    fi

    # 7. PARCHE AUTOMÁTICO: Ruta de Kitty
    if [ -f "$DOTFILES_DIR/config/sxhkd/sxhkdrc" ]; then
        sed -i 's|/opt/kitty/bin/kitty|kitty|g' "$DOTFILES_DIR/config/sxhkd/sxhkdrc"
    fi

    log_success "Todos los archivos han sido parcheados y automatizados."
}
