setup_root() {
    log_info "Compartiendo la configuración de la shell con root..."

    # Crear la carpeta .config para root si no existe
    sudo mkdir -p /root/.config

    # Compartir la configuración de tu shell y Powerlevel10k
    sudo ln -sfn "$HOME/.zshrc" /root/.zshrc
    sudo ln -sfn "$HOME/.p10k.zsh" /root/.p10k.zsh
    sudo ln -sfn "$HOME/powerlevel10k" /root/powerlevel10k

    # Compartir Neovim, lsd y bat solo si existen
    for cfg in nvim lsd bat; do
        if [ -e "$HOME/.config/$cfg" ]; then
            sudo ln -sfn "$HOME/.config/$cfg" "/root/.config/$cfg"
        fi
    done

    # Cambiar la shell de root a Zsh
    sudo chsh -s "$(command -v zsh)" root

    log_success "Root usa ahora la misma configuración de zsh y Powerlevel10k."
}
