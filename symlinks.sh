# Función para crear un enlace simbólico robusto y libre de errores
safe_symlink() {
    local src="$1"
    local dest="$2"

    # Asegura que el directorio padre del destino exista
    mkdir -p "$(dirname "$dest")"

    # Si el destino ya existe o es un enlace roto
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ]; then
            rm "$dest" # Si es un enlace roto o viejo, se borra directamente
        else
            log_warn "Se detectó un archivo real en $dest. Respaldando..."
            mv "$dest" "${dest}.backup_$(date +%Y%m%d_%H%M%S)"
        fi
    fi

    ln -s "$src" "$dest"
}

create_symlinks() {
    log_info "Generando enlaces simbólicos del sistema..."

    # Enlaces de la carpeta personal (Home)
    safe_symlink "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
    safe_symlink "$DOTFILES_DIR/home/.p10k.zsh" "$HOME/.p10k.zsh"

    # Carpetas en .config
    local configs=(
        "bspwm"
        "sxhkd"
        "polybar"
        "rofi"
        "kitty"
        "picom"
        "dunst"
        "xfce4"
    )

    for cfg in "${configs[@]}"; do
        if [ -d "$DOTFILES_DIR/config/$cfg" ]; then
            safe_symlink "$DOTFILES_DIR/config/$cfg" "$HOME/.config/$cfg"
            log_success "Enlace enrutado: ~/.config/$cfg"
        else
            log_warn "No se encontró la carpeta 'config/$cfg' en tu repositorio."
        fi
    done

    # Marcadores de Thunar (GTK-3.0)
    if [ -f "$DOTFILES_DIR/gtk-3.0/bookmarks" ]; then
        safe_symlink "$DOTFILES_DIR/gtk-3.0/bookmarks" "$HOME/.config/gtk-3.0/bookmarks"
    fi

    log_success "Todos los enlaces simbólicos han sido creados correctamente."
}
