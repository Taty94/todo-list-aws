#!/bin/bash

# Variables
BRANCH_NAME="develop"
TARGET_BRANCH="master"
# RELEASE_TAG="v1.0.0"

# Función para imprimir mensajes en color
function print_msg() {
    COLOR=$1
    shift
    echo -e "${COLOR}$* \033[0m"
}

YELLOW="\033[1;33m"
RED="\033[1;31m"
GREEN="\033[1;32m"

print_msg "$YELLOW" "🔍 Verificando cambios pendientes..."
CHANGES=$(git status -s)

if [[ -n "$CHANGES" ]]; then
    print_msg "$RED" "⚠️  Hay cambios sin confirmar en el repositorio local:"
    echo "$CHANGES"
    print_msg "$RED" "🔒 Cancela el proceso o limpia el entorno antes de continuar."
    exit 1
fi

print_msg "$YELLOW" "🛠 Cambiando a la rama '$TARGET_BRANCH'..."
git checkout $TARGET_BRANCH || { print_msg "$RED" "❌ Error al cambiar a la rama $TARGET_BRANCH."; exit 1; }

print_msg "$YELLOW" "⬇️  Obteniendo últimos cambios de '$TARGET_BRANCH'..."
git pull origin $TARGET_BRANCH || { print_msg "$RED" "❌ Error al hacer pull de $TARGET_BRANCH."; exit 1; }

print_msg "$YELLOW" "🔀 Haciendo merge de '$BRANCH_NAME' a '$TARGET_BRANCH'..."
git merge origin/$BRANCH_NAME

if [[ $? -ne 0 ]]; then
    print_msg "$RED" "❌ El merge ha fallado. Resuelve los conflictos manualmente."
    exit 1
else
    print_msg "$GREEN" "✅ Merge exitoso."
fi

# Optional: Etiquetado
# print_msg "$YELLOW" "🏷️  Creando etiqueta de versión $RELEASE_TAG..."
# git tag -a "$RELEASE_TAG" -m "Versión de lanzamiento: $RELEASE_TAG"

print_msg "$YELLOW" "🚀 Subiendo cambios al repositorio remoto..."
git push origin $TARGET_BRANCH

if [[ $? -ne 0 ]]; then
    print_msg "$RED" "❌ Error al hacer push al repositorio remoto. Verifica credenciales o conexión."
    exit 1
fi

# print_msg "$YELLOW" "📤 Subiendo etiqueta..."
# git push origin $RELEASE_TAG

print_msg "$GREEN" "🎉 Promoción completada. La versión ha sido enviada a producción."
