install_packages() {
    log_info "Actualizando repositorios del sistema..."
    sudo apt update -y

    log_info "Instalando paquetes básicos y de entorno gráfico..."
    sudo apt install -y bspwm sxhkd kitty picom polybar rofi feh dunst i3lock-fancy lsd bat zsh-autosuggestions zsh-syntax-highlighting unzip wget git

    log_info "Instalando motor de Powerlevel10k..."
    if [ ! -d "$HOME/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
        log_success "Powerlevel10k clonado correctamente."
    else
        log_info "Powerlevel10k ya se encuentra instalado."
    fi

    log_info "Configurando fuentes del sistema..."
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    # Copiar fuentes personalizadas locales desde tu carpeta de dotfiles
    if [ -d "$DOTFILES_DIR/fonts" ]; then
        log_info "Copiando tus fuentes personalizadas..."
        cp -f "$DOTFILES_DIR/fonts"/*.{ttf,otf} "$font_dir/" 2>/dev/null || true
    fi

    # Descargar Hack Nerd Font si no está en el sistema
    if ! fc-list : family | grep -iq "Hack Nerd Font"; then
        log_info "Descargando Hack Nerd Font..."
        wget -qO /tmp/Hack.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
        unzip -qo /tmp/Hack.zip -d "$font_dir"
        rm /tmp/Hack.zip
    fi

    log_info "Actualizando caché de fuentes..."
    fc-cache -fv >/dev/null
    log_success "Fuentes configuradas correctamente."
}
