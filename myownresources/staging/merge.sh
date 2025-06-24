#!/bin/bash

# Variables
BRANCH_NAME="develop"  # La rama de desarrollo que quieres mergear
TARGET_BRANCH="master"  # La rama de producción (master)
#RELEASE_TAG="v1.0.0"    # La etiqueta de la versión, puede ser automática o manual

# Paso 1: Verificar que no haya cambios pendientes en el repositorio
echo "Verificando cambios pendientes..."
git status -s  # Esto muestra el estado de los archivos (modificados, no rastreados, etc.)

# Si git status encuentra cambios pendientes
if [[ $(git status -s) ]]; then
    echo "Error: Hay cambios pendientes en tu área de trabajo. Por favor, confirma tus cambios antes de proceder."
    exit 1
fi

# Paso 2: Cambiar a la rama de destino (master)
echo "Cambiando a la rama $TARGET_BRANCH..."
git checkout $TARGET_BRANCH

# Paso 3: Traer los últimos cambios de la rama master para evitar conflictos
echo "Actualizando la rama $TARGET_BRANCH con los últimos cambios del remoto..."
git pull origin $TARGET_BRANCH

# Paso 4: Hacer el merge de la rama de desarrollo (o cualquier rama de características) a master
echo "Haciendo merge de la rama $BRANCH_NAME a $TARGET_BRANCH..."
git merge origin/$BRANCH_NAME

# Paso 5: Verificar si el merge fue exitoso
if [[ $? -ne 0 ]]; then
    echo "Error: El merge ha fallado. No se puede continuar."
    exit 1
else
    echo "Merge exitoso."
fi

# Paso 6: Crear una etiqueta para la versión de lanzamiento (Release) si es necesario
#echo "Creando etiqueta para la versión $RELEASE_TAG..."
#git tag -a $RELEASE_TAG -m "Versión de lanzamiento: $RELEASE_TAG"

# Paso 7: Subir los cambios y la nueva etiqueta a GitHub (o el repositorio remoto)
echo "Subiendo cambios y la etiqueta al repositorio remoto..."
git push origin $TARGET_BRANCH
#git push origin $RELEASE_TAG

# Paso 8: Confirmación final
echo "Se ha subido a producción."
