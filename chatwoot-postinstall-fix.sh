#!/bin/bash

echo "🛠️ Ejecutando reparación post-instalación para Chatwoot..."

read -p "🔤 Nombre corto del cliente (CLIENT_ID): " CLIENT_ID

APP_CONTAINER=$(docker ps --filter "name=chatwoot_${CLIENT_ID}_app" --format "{{.Names}}" | head -n1)

if [ -z "$APP_CONTAINER" ]; then
  echo "❌ No se encontró el contenedor de la app para chatwoot_${CLIENT_ID}."
  exit 1
fi

echo "📦 Contenedor encontrado: $APP_CONTAINER"

echo "🚧 Ejecutando migraciones..."
docker exec -it $APP_CONTAINER bundle exec rails db:prepare

echo "🌱 (Opcional) Ejecutando seeds..."
read -p "¿Deseas ejecutar también los seeds iniciales? (s/n): " SEED
if [[ "$SEED" == "s" ]]; then
  docker exec -it $APP_CONTAINER bundle exec rails db:seed
fi

echo "✅ Listo. Si todo salió bien, intenta abrir el dominio en el navegador."
