#!/bin/bash

# Activar depuración (imprime cada comando que se ejecuta)
set -x

# Desplegar con SAM usando opciones explícitas para entorno CI/CD
OUTPUT=$(sam deploy \
    --template-file template.yaml \
    --config-env "${STAGE}" \
    --region "${AWS_REGION}" \
    --no-confirm-changeset \
    --force-upload \
    --no-fail-on-empty-changeset \
    --no-progressbar 2>&1) || true

# Mostrar salida del despliegue
echo "$OUTPUT"

# Verificar el resultado del despliegue
if echo "$OUTPUT" | grep -q "No changes to deploy"; then
    echo "ℹ️ No hubo cambios en el stack."
elif echo "$OUTPUT" | grep -qi "error"; then
    echo "❌ Error durante el despliegue"
    exit 1
fi
