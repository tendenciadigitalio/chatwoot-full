#!/bin/bash

echo "=== Instalador automático de Chatwoot para múltiples clientes ==="

read -p "🔤 Nombre corto del cliente (sin espacios): " CLIENT_ID
read -p "🌐 Dominio completo (ej. chat.cliente.com): " DOMAIN
read -p "📧 Correo SMTP (Gmail): " SMTP_EMAIL
read -p "🔐 Contraseña de app SMTP (visible para verificar): " SMTP_PASSWORD

STACK_NAME="chatwoot_${CLIENT_ID}"
POSTGRES_PASSWORD=$(head -c 12 /dev/urandom | base64)
SECRET_KEY=$(head -c 32 /dev/urandom | xxd -p)

cat > "${STACK_NAME}.yml" <<EOF
version: "3.7"

services:
  ${STACK_NAME}_app:
    image: chatwoot/chatwoot:latest
    command: bundle exec rails s -p 3000 -b 0.0.0.0
    environment:
      RAILS_ENV: production
      FRONTEND_URL: "https://${DOMAIN}"
      SECRET_KEY_BASE: "${SECRET_KEY}"
      SMTP_ADDRESS: "smtp.gmail.com"
      SMTP_PORT: "465"
      SMTP_USERNAME: "${SMTP_EMAIL}"
      SMTP_PASSWORD: "${SMTP_PASSWORD}"
      SMTP_DOMAIN: "gmail.com"
      MAILER_SENDER_EMAIL: "${SMTP_EMAIL}"
      POSTGRES_HOST: "${STACK_NAME}_postgres"
      POSTGRES_USERNAME: "postgres"
      POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
      POSTGRES_DATABASE: "chatwoot"
      REDIS_URL: "redis://${STACK_NAME}_redis:6379/0"
      INSTALLATION_ENV: "docker"
    networks:
      - traefik_public
      - ${STACK_NAME}_network
    deploy:
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.${STACK_NAME}.rule=Host(\`${DOMAIN}\`)"
        - "traefik.http.routers.${STACK_NAME}.entrypoints=websecure"
        - "traefik.http.routers.${STACK_NAME}.tls.certresolver=letsencryptresolver"
        - "traefik.http.services.${STACK_NAME}.loadbalancer.server.port=3000"

  ${STACK_NAME}_sidekiq:
    image: chatwoot/chatwoot:latest
    command: bundle exec sidekiq -C config/sidekiq.yml
    environment:
      RAILS_ENV: production
      FRONTEND_URL: "https://${DOMAIN}"
      SECRET_KEY_BASE: "${SECRET_KEY}"
      SMTP_ADDRESS: "smtp.gmail.com"
      SMTP_PORT: "465"
      SMTP_USERNAME: "${SMTP_EMAIL}"
      SMTP_PASSWORD: "${SMTP_PASSWORD}"
      SMTP_DOMAIN: "gmail.com"
      MAILER_SENDER_EMAIL: "${SMTP_EMAIL}"
      POSTGRES_HOST: "${STACK_NAME}_postgres"
      POSTGRES_USERNAME: "postgres"
      POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
      POSTGRES_DATABASE: "chatwoot"
      REDIS_URL: "redis://${STACK_NAME}_redis:6379/0"
      INSTALLATION_ENV: "docker"
    networks:
      - ${STACK_NAME}_network

  ${STACK_NAME}_postgres:
    image: postgres:13
    environment:
      POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
      POSTGRES_DB: "chatwoot"
    volumes:
      - ${STACK_NAME}_pgdata:/var/lib/postgresql/data
    networks:
      - ${STACK_NAME}_network

  ${STACK_NAME}_redis:
    image: redis:6
    volumes:
      - ${STACK_NAME}_redisdata:/data
    networks:
      - ${STACK_NAME}_network

networks:
  ${STACK_NAME}_network:
    driver: overlay
  traefik_public:
    external: true

volumes:
  ${STACK_NAME}_pgdata:
  ${STACK_NAME}_redisdata:
EOF

echo "🚀 Desplegando stack ${STACK_NAME}..."
docker stack deploy -c "${STACK_NAME}.yml" "${STACK_NAME}"

echo "⏳ Esperando a que el contenedor web esté listo..."
sleep 15

APP_CONTAINER=$(docker ps --filter "name=${STACK_NAME}_app" --format "{{.Names}}" | head -n1)

if [ -z "$APP_CONTAINER" ]; then
  echo "❌ No se encontró el contenedor de la app."
  exit 1
fi

echo "🛠️ Ejecutando migraciones para ${STACK_NAME}..."
docker exec -it $APP_CONTAINER bundle exec rails db:prepare

echo "✅ Instalación de ${STACK_NAME} completa."
echo "🌐 Accede a: https://${DOMAIN}"
