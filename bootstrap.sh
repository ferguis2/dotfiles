#!/usr/bin/env bash

# Detener la ejecución si ocurre algún error imprevisto (Modo Seguro)
set -euo pipefail

# Obtener de forma indestructible la ruta absoluta de tus dotfiles,
# sin importar desde qué carpeta lances la instalación.
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_DIR

# Cargar las librerías modulares
LIB_DIR="$DOTFILES_DIR/lib"

if [ ! -f "$LIB_DIR/utils.sh" ] || [ ! -f "$LIB_DIR/packages.sh" ] || [ ! -f "$LIB_DIR/patcher.sh" ] || [ ! -f "$LIB_DIR/symlinks.sh" ]; then
    echo "[!] ERROR: No se pudieron encontrar los scripts en la biblioteca $LIB_DIR."
    echo "Verifica que la carpeta 'lib/' se encuentre en el mismo directorio que bootstrap.sh."
    exit 1
fi

source "$LIB_DIR/utils.sh"
source "$LIB_DIR/packages.sh"
source "$LIB_DIR/patcher.sh"
source "$LIB_DIR/symlinks.sh"

# Mensaje de presentación
echo -e "${BLUE}"
echo "========================================================"
echo "   INSTALADOR DE CONFIGURACIONES AUTOMÁTICO Y SEGURO   "
echo "========================================================"
echo -e "${NC}"

# Pipeline de instalación secuencial
install_packages
patch_configurations
create_symlinks

echo -e "\n${GREEN}[+] ¡La instalación y configuración del entorno ha finalizado con éxito!${NC}"
echo -e "${YELLOW}[!] Reinicia la terminal o bspwm para ver los cambios aplicados.${NC}\n"
