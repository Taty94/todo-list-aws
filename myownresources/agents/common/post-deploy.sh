#!/bin/bash
set -e
set -x

# Parámetros esperados
STAGE=$1
REGION=$2

if [[ -z "$STAGE" || -z "$REGION" ]]; then
  echo "❌ Uso: $0 todo-list-aws-<STAGE> <REGION>"
  exit 1
fi

# Obtiene la URL del API Gateway (ajusta OutputKey según tu template.yaml)
BASE_URL=$(aws cloudformation describe-stacks \
  --stack-name todo-list-aws-"$STAGE" \
  --query "Stacks[0].Outputs[?OutputKey=='BaseUrlApi'].OutputValue" \
  --region "$REGION" \
  --output text)

if [ -n "$BASE_URL" ]; then
  echo "✅ URL del API Gateway: $BASE_URL"
else
  echo "⚠️ No se encontró la URL del API Gateway."
fi

# Exportar a un archivo para que Jenkins lo lea
echo "$BASE_URL" > base_url.txt
