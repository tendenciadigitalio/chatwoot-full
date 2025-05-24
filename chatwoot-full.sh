#!/bin/bash

echo "=== Instalador Chatwoot por cliente (con subida automática a Portainer) ==="

read -p "🔤 Nombre corto del cliente (CLIENT_ID): " CLIENT_ID
read -p "🧾 Nombre completo del cliente (CLIENT_NAME): " CLIENT_NAME
read -p "🌐 Dominio completo (DOMAIN): " DOMAIN
read -p "📧 Correo SMTP (SMTP_EMAIL): " SMTP_EMAIL
read -p "🔑 Contraseña SMTP (SMTP_PASSWORD): " SMTP_PASSWORD
PORTAINER_URL="https://tdportainer.tendenciadigital.top"
read -p "👤 Usuario de Portainer: " PORTAINER_USER
read -s -p "🔐 Contraseña de Portainer: " PORTAINER_PASS
echo ""

SECRET_KEY=$(openssl rand -hex 32)
DB_NAME="chatwoot_${CLIENT_ID}"
REDIS_PREFIX="chatwoot_${CLIENT_ID}_"

cp stack-template.yml stack-chatwoot-${CLIENT_ID}.yml

sed -i "s|\${CLIENT_ID}|${CLIENT_ID}|g" stack-chatwoot-${CLIENT_ID}.yml
sed -i "s|\${CLIENT_NAME}|${CLIENT_NAME}|g" stack-chatwoot-${CLIENT_ID}.yml
sed -i "s|\${DOMAIN}|${DOMAIN}|g" stack-chatwoot-${CLIENT_ID}.yml
sed -i "s|\${SMTP_EMAIL}|${SMTP_EMAIL}|g" stack-chatwoot-${CLIENT_ID}.yml
sed -i "s|\${SMTP_PASSWORD}|${SMTP_PASSWORD}|g" stack-chatwoot-${CLIENT_ID}.yml
sed -i "s|\${DB_NAME}|${DB_NAME}|g" stack-chatwoot-${CLIENT_ID}.yml
sed -i "s|\${REDIS_PREFIX}|${REDIS_PREFIX}|g" stack-chatwoot-${CLIENT_ID}.yml
sed -i "s|\${SECRET_KEY}|${SECRET_KEY}|g" stack-chatwoot-${CLIENT_ID}.yml

echo "✅ Archivo generado: stack-chatwoot-${CLIENT_ID}.yml"

# Obtener JWT de autenticación
AUTH_RESPONSE=$(curl -sk -X POST "$PORTAINER_URL/api/auth" -H "Content-Type: application/json" -d "{"Username": "${PORTAINER_USER}", "Password": "${PORTAINER_PASS}"}")
JWT=$(echo "$AUTH_RESPONSE" | jq -r .jwt)

if [[ "$JWT" == "null" || -z "$JWT" ]]; then
  echo "❌ Error: No fue posible autenticarse en Portainer. Verifica usuario, contraseña o URL."
  exit 1
fi

# Obtener Endpoint ID
ENDPOINT_ID=$(curl -sk -H "Authorization: Bearer $JWT" "$PORTAINER_URL/api/endpoints" | jq '.[0].Id')

if [[ -z "$ENDPOINT_ID" || "$ENDPOINT_ID" == "null" ]]; then
  echo "❌ Error: No se pudo obtener EndpointId desde Portainer."
  exit 1
fi

echo "📡 Usando Endpoint ID: $ENDPOINT_ID"

# Verificar si ya existe el stack
EXISTING_STACK_ID=$(curl -sk -H "Authorization: Bearer $JWT" "$PORTAINER_URL/api/stacks" | jq ".[] | select(.Name==\"chatwoot_${CLIENT_ID}\") | .Id")

if [[ -n "$EXISTING_STACK_ID" ]]; then
  read -p "⚠️ Ya existe un stack llamado chatwoot_${CLIENT_ID}. ¿Deseas reemplazarlo? (s/n): " REPLACE
  if [[ "$REPLACE" != "s" ]]; then
    echo "❌ Instalación cancelada."
    exit 0
  else
    echo "🗑️ Eliminando stack existente ID $EXISTING_STACK_ID..."
    curl -sk -X DELETE -H "Authorization: Bearer $JWT" "$PORTAINER_URL/api/stacks/$EXISTING_STACK_ID?endpointId=$ENDPOINT_ID"
  fi
fi

# Crear nuevo stack
echo "🚀 Subiendo stack a Portainer..."
STACK_CONTENT=$(cat stack-chatwoot-${CLIENT_ID}.yml | jq -Rs .)
curl -sk -X POST "$PORTAINER_URL/api/stacks"   -H "Authorization: Bearer $JWT"   -H "Content-Type: application/json"   -d "{"Name":"chatwoot_${CLIENT_ID}","StackFileContent":$STACK_CONTENT,"Prune":true,"EndpointId":$ENDPOINT_ID}"

echo "✅ Stack enviado. Verifica en: $PORTAINER_URL/#/stacks"
