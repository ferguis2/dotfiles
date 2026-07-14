#!/usr/bin/env bash

# Salir inmediatamente si un comando falla
set -e

# Colores para la salida en terminal
BLUE="\e[0;34m"
GREEN="\e[0;32m"
NC="\e[0m"

echo -e "${BLUE}[*] Iniciando la automatización de tu entorno Kali Linux...${NC}"

# 1. Actualizar el sistema e instalar paquetes básicos
echo -e "${BLUE}[*] Instalando dependencias de interfaz, terminal y desarrollo...${NC}"
sudo apt update && sudo apt install -y \
    bspwm sxhkd kitty zsh polybar lsd bat \
    build-essential gcc make cmake tar unzip git curl wget \
    python3 python3-pip python3-venv \
    ripgrep fd-find xclip feh picom rofi \
    cherrytree powershell thunar

# Parche para bat/batcat en sistemas Debian/Kali
mkdir -p ~/.local/bin
if command -v batcat &> /dev/null; then
    ln -sf $(which batcat) ~/.local/bin/bat
fi

# 2. Configurar el directorio /opt para herramientas pesadas
echo -e "${BLUE}[*] Configurando /opt (Neovim, PEASS-ng, VS Code, Sublime)...${NC}"
sudo mkdir -p /opt

# Neovim (Binario precompilado)
if [ ! -d "/opt/nvim-linux64" ]; then
    echo -e "  -> Descargando Neovim..."
    curl -fLo /tmp/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo tar -C /opt -xzf /tmp/nvim-linux64.tar.gz
    sudo mv /opt/nvim-linux-x86_64 /opt/nvim-linux64 || true
    rm /tmp/nvim-linux64.tar.gz
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
fi

# PEASS-ng para auditorías
if [ ! -d "/opt/peass-ng" ]; then
    echo -e "  -> Clonando PEASS-ng..."
    sudo git clone https://github.com/peass-ng/PEASS-ng.git /opt/peass-ng
fi

# VS Code y Sublime Text (Instalación por apt si no existen)
sudo apt install -y code sublime-text 2>/dev/null || echo "Editores instalados."

# 3. Descargar temas externos a ~/.config (No ensucian el GitHub)
echo -e "${BLUE}[*] Descargando repositorios de estética...${NC}"
mkdir -p ~/.config
if [ ! -d "$HOME/.config/i3lock-fancy" ]; then
    git clone https://github.com/meskarune/i3lock-fancy.git ~/.config/i3lock-fancy
fi
if [ ! -d "$HOME/.config/rofi-themes-collection" ]; then
    git clone https://github.com/lr-tech/rofi-themes-collection.git ~/.config/rofi-themes-collection
fi

# 4. Crear los Enlaces Simbólicos (Symlinks)
echo -e "${BLUE}[*] Enlazando tus dotfiles...${NC}"
DOTFILES_DIR="$HOME/dotfiles"

# Array con todas las carpetas que guardaste en dotfiles/config/
CARPETAS=(
    "bspwm" "sxhkd" "kitty" "nvim" 
    "picom" "polybar" "rofi" 
    "bin" "scripts" 
    "Thunar" "gtk-3.0" "xfce4"
    "cherrytree" "powershell"
)

# Bucle para enlazar cada carpeta automáticamente
for carpeta in "${CARPETAS[@]}"; do
    if [ -d "$DOTFILES_DIR/config/$carpeta" ]; then
        # Elimina el directorio destino si existe para evitar conflictos al enlazar
        rm -rf "$HOME/.config/$carpeta"
        ln -sfn "$DOTFILES_DIR/config/$carpeta" "$HOME/.config/$carpeta"
        echo -e "  -> Enlazado: $carpeta"
    fi
done

# Enlaces de la shell
ln -sf "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
if [ -f "$DOTFILES_DIR/home/.p10k.zsh" ]; then
    ln -sf "$DOTFILES_DIR/home/.p10k.zsh" "$HOME/.p10k.zsh"
fi

# 5. Asegurar permisos de ejecución
echo -e "${BLUE}[*] Aplicando permisos de ejecución a scripts y binarios...${NC}"
chmod +x "$HOME/.config/bspwm/bspwmrc" 2>/dev/null || true
chmod +x "$HOME/.config/sxhkd/sxhkdrc" 2>/dev/null || true
chmod +x "$HOME/.config/polybar/launch.sh" 2>/dev/null || true
chmod +x "$HOME/.config/scripts/"* 2>/dev/null || true
chmod +x "$HOME/.config/bin/"* 2>/dev/null || true

# 6. Configurar Zsh por defecto
if [ "$SHELL" != "/usr/bin/zsh" ] && [ "$SHELL" != "/bin/zsh" ]; then
    echo -e "${BLUE}[*] Cambiando shell por defecto a Zsh...${NC}"
    chsh -s $(which zsh)
fi

echo -e "${GREEN}[+] ¡Todo listo! Tu entorno ha sido automatizado con éxito.${NC}"
