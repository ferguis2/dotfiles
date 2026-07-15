install_packages() {
    log_info "Actualizando repositorios del sistema..."
    sudo apt update -y

    log_info "Instalando paquetes básicos y de entorno gráfico..."
    sudo apt install -y bspwm sxhkd kitty picom polybar rofi feh dunst i3lock-fancy lsd bat zsh-autosuggestions zsh-syntax-highlighting unzip git neovim xclip wl-clipboard

    log_info "Instalando motor de Powerlevel10k..."
    if [ ! -d "$HOME/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
        log_success "Powerlevel10k clonado correctamente."
    fi

    log_info "Configurando NvChad (Neovim)..."
    if [ ! -d "$HOME/.config/nvim" ]; then
        log_info "Clonando repositorio oficial de NvChad..."
        git clone https://github.com/NvChad/starter "$HOME/.config/nvim" --depth 1
        log_success "NvChad base instalado correctamente."
    fi

    log_info "Instalando fuentes desde tu repositorio local..."
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    if [ -d "$DOTFILES_DIR/fonts" ]; then
        cp -f "$DOTFILES_DIR/fonts"/*.{ttf,otf} "$font_dir/" 2>/dev/null || true
        log_success "Fuentes locales copiadas exitosamente."
    else
        log_warn "No se encontró la carpeta 'fonts' en tu repositorio."
    fi

    log_info "Actualizando caché de tipografías..."
    fc-cache -fv >/dev/null
}
