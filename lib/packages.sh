install_packages() {
    log_info "Actualizando repositorios del sistema..."
    sudo apt update -y

    log_info "Instalando paquetes básicos..."
    sudo apt install -y bspwm sxhkd kitty picom polybar rofi feh dunst i3lock-fancy lsd bat zsh-autosuggestions zsh-syntax-highlighting unzip wget git neovim xclip wl-clipboard

    log_info "Instalando motor de Powerlevel10k..."
    if [ ! -d "$HOME/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
        log_success "Powerlevel10k clonado."
    fi

    log_info "Configurando NvChad (Neovim)..."
    if [ ! -d "$HOME/.config/nvim" ]; then
        git clone https://github.com/NvChad/starter "$HOME/.config/nvim" --depth 1
        log_success "NvChad base instalado."
    fi

    log_info "Descargando e instalando Hack Nerd Font..."
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    wget -q --show-progress -O /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip
    unzip -q -o /tmp/Hack.zip -d "$font_dir"
    rm /tmp/Hack.zip

    log_info "Actualizando caché de tipografías..."
    fc-cache -fv >/dev/null
    log_success "Fuentes instaladas."
}
