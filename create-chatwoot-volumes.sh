#!/bin/bash

echo "=== Crear volúmenes personalizados para una instancia de Chatwoot ==="
read -p "🔤 Ingresa el nombre corto del cliente (sin espacios): " CLIENT_ID

echo "📦 Creando volúmenes para cliente: $CLIENT_ID..."

docker volume create chatwoot_${CLIENT_ID}_storage
docker volume create chatwoot_${CLIENT_ID}_public
docker volume create chatwoot_${CLIENT_ID}_mailer
docker volume create chatwoot_${CLIENT_ID}_mailers
docker volume create chatwoot_${CLIENT_ID}_pgdata
docker volume create chatwoot_${CLIENT_ID}_redisdata

echo "✅ Volúmenes creados correctamente:"
docker volume ls | grep chatwoot_${CLIENT_ID}
