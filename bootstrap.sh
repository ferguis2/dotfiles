#!/usr/bin/env bash

# Salir inmediatamente si un comando falla
set -e

# Colores para la salida en terminal
BLUE="\e[0;34m"
GREEN="\e[0;32m"
NC="\e[0m"

echo -e "${BLUE}[*] Iniciando la automatización de tu entorno Kali Linux...${NC}"

# ==========================================
# 1. ACTUALIZAR E INSTALAR PAQUETES BÁSICOS
# (Esto va primero para asegurar que tenemos git y wget)
# ==========================================
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

# ==========================================
# 2. DESCARGA DE FUENTES Y POWERLEVEL10K
# ==========================================
echo -e "${BLUE}[*] Instalando motor de Powerlevel10k...${NC}"
if [ ! -d "$HOME/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
fi

echo -e "${BLUE}[*] Instalando Hack Nerd Font para Kitty y tu entorno...${NC}"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Verificar si Hack Nerd Font ya está instalada
if ! fc-list : family | grep -iq "Hack Nerd Font"; then
    echo -e "  -> Descargando Hack Nerd Font desde el repositorio oficial..."
    wget -qO /tmp/Hack.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
    
    echo -e "  -> Extrayendo fuentes..."
    unzip -qo /tmp/Hack.zip -d "$FONT_DIR"
    rm /tmp/Hack.zip
    
    echo -e "  -> Actualizando caché de fuentes..."
    fc-cache -fv
else
    echo -e "  -> La fuente Hack Nerd Font ya está instalada."
fi

# ==========================================
# 3. CONFIGURAR /OPT PARA HERRAMIENTAS PESADAS
# ==========================================
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

# VS Code y Sublime Text
sudo apt install -y code sublime-text 2>/dev/null || echo "  -> Nota: VS Code/Sublime requieren repositorios externos para instalarse por apt."

# ==========================================
# 4. TEMAS EXTERNOS
# ==========================================
echo -e "${BLUE}[*] Descargando repositorios de estética...${NC}"
mkdir -p ~/.config
if [ ! -d "$HOME/.config/i3lock-fancy" ]; then
    git clone https://github.com/meskarune/i3lock-fancy.git ~/.config/i3lock-fancy
fi
if [ ! -d "$HOME/.config/rofi-themes-collection" ]; then
    git clone https://github.com/lr-tech/rofi-themes-collection.git ~/.config/rofi-themes-collection
fi

# ==========================================
# 5. CREAR ENLACES SIMBÓLICOS (SYMLINKS)
# ==========================================
echo -e "${BLUE}[*] Enlazando tus dotfiles...${NC}"
DOTFILES_DIR="$HOME/dotfiles"

CARPETAS=(
    "bspwm" "sxhkd" "kitty" "nvim" 
    "picom" "polybar" "rofi" 
    "bin" "scripts" 
    "Thunar" "gtk-3.0" "xfce4"
    "cherrytree" "powershell"
)

for carpeta in "${CARPETAS[@]}"; do
    if [ -d "$DOTFILES_DIR/config/$carpeta" ]; then
        rm -rf "$HOME/.config/$carpeta"
        ln -sfn "$DOTFILES_DIR/config/$carpeta" "$HOME/.config/$carpeta"
        echo -e "  -> Enlazado: $carpeta"
    fi
done

ln -sf "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
if [ -f "$DOTFILES_DIR/home/.p10k.zsh" ]; then
    ln -sf "$DOTFILES_DIR/home/.p10k.zsh" "$HOME/.p10k.zsh"
fi

# ==========================================
# 6. PERMISOS Y SHELL POR DEFECTO
# ==========================================
echo -e "${BLUE}[*] Aplicando permisos de ejecución a scripts y binarios...${NC}"
chmod +x "$HOME/.config/bspwm/bspwmrc" 2>/dev/null || true
chmod +x "$HOME/.config/sxhkd/sxhkdrc" 2>/dev/null || true
chmod +x "$HOME/.config/polybar/launch.sh" 2>/dev/null || true
chmod +x "$HOME/.config/scripts/"* 2>/dev/null || true
chmod +x "$HOME/.config/bin/"* 2>/dev/null || true

if [ "$SHELL" != "/usr/bin/zsh" ] && [ "$SHELL" != "/bin/zsh" ]; then
    echo -e "${BLUE}[*] Cambiando shell por defecto a Zsh...${NC}"
    chsh -s $(which zsh)
fi

echo -e "${GREEN}[+] ¡Todo listo! Tu entorno ha sido automatizado con éxito.${NC}"
