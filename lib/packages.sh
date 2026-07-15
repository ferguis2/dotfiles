install_packages() {
    log_info "Actualizando repositorios..."
    sudo apt update -y

    log_info "Instalando paquetes del sistema..."
    sudo apt install -y bspwm sxhkd kitty picom polybar rofi feh dunst i3lock-fancy lsd bat zsh-autosuggestions zsh-syntax-highlighting unzip wget git neovim xclip wl-clipboard fonts-font-awesome

    log_info "Instalando motor de Powerlevel10k..."
    if [ ! -d "$HOME/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
    fi

    log_info "Configurando NvChad (Neovim)..."
    if [ ! -d "$HOME/.config/nvim" ]; then
        git clone https://github.com/NvChad/starter "$HOME/.config/nvim" --depth 1
    fi

    log_info "Descargando e instalando fuentes automáticamente..."
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    # 1. Descargar Hack Nerd Font
    wget -q --show-progress -O /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip
    unzip -q -o /tmp/Hack.zip -d "$font_dir"
    
    # 2. Descargar Iosevka Nerd Font (Usada por tu Polybar)
    wget -q --show-progress -O /tmp/Iosevka.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip
    unzip -q -o /tmp/Iosevka.zip -d "$font_dir"

    # 3. Descargar Feather (Vital para los iconos de la batería)
    wget -q -O "$font_dir/feather.ttf" "https://raw.githubusercontent.com/adi1090x/polybar-themes/master/fonts/feather.ttf"

    rm -f /tmp/Hack.zip /tmp/Iosevka.zip

    log_info "Actualizando caché de tipografías..."
    fc-cache -fv >/dev/null
    log_success "Fuentes y paquetes instalados con éxito."
}
