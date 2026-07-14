# Crear la carpeta .config para root si no existe
sudo mkdir -p /root/.config

# Compartir la configuración de tu shell y alias
sudo ln -sf "$HOME/.zshrc" /root/.zshrc
sudo ln -sf "$HOME/.p10k.zsh" /root/.p10k.zsh
sudo ln -sf "$HOME/powerlevel10k" /root/powerlevel10k

# Compartir Neovim, lsd y bat
sudo ln -sfn "$HOME/.config/nvim" /root/.config/nvim
sudo ln -sfn "$HOME/.config/lsd" /root/.config/lsd
sudo ln -sfn "$HOME/.config/bat" /root/.config/bat

# Cambiar la shell de root a Zsh (por si acaso está en bash)
sudo chsh -s $(which zsh) root
