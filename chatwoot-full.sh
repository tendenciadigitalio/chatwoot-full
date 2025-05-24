#!/bin/bash

echo "=== Instalador de Chatwoot por cliente (Docker Swarm + Portainer) ==="
echo "Versión inicial - Tendencia Digital IO"
echo ""

read -p "🔹 Nombre corto del cliente (sin espacios, solo minúsculas): " CLIENT_ID
read -p "🔹 Nombre completo del cliente (para mostrar en la interfaz): " CLIENT_NAME
read -p "🔹 Dominio completo (ej. cwcliente.tudominio.com): " DOMAIN
read -p "🔹 Correo SMTP (Gmail): " SMTP_EMAIL
read -p "🔹 Contraseña de aplicación SMTP (solo Gmail): " SMTP_PASSWORD

DB_NAME="chatwoot_${CLIENT_ID}"
STACK_FILE="stack-chatwoot-${CLIENT_ID}.yml"
REDIS_PREFIX="chatwoot_${CLIENT_ID}_"
SECRET_KEY=$(docker run --rm ruby:2.7 bash -c "bundle exec rake secret")

echo ""
echo "📦 Creando volúmenes de Docker..."
docker volume create chatwoot_${CLIENT_ID}_storage
docker volume create chatwoot_${CLIENT_ID}_public
docker volume create chatwoot_${CLIENT_ID}_mailer
docker volume create chatwoot_${CLIENT_ID}_mailers

echo ""
echo "🐘 Creando base de datos PostgreSQL..."
docker exec -i postgres psql -U postgres <<EOF
CREATE DATABASE ${DB_NAME};
EOF

echo ""
echo "📝 Generando archivo $STACK_FILE ..."
cat > $STACK_FILE <<EOF
version: "3.7"

services:

  chatwoot_${CLIENT_ID}_app:
    image: sendingtk/chatwoot:latest
    command: bundle exec rails s -p 3000 -b 0.0.0.0
    entrypoint: docker/entrypoints/rails.sh
    volumes:
      - chatwoot_${CLIENT_ID}_storage:/app/storage
      - chatwoot_${CLIENT_ID}_public:/app/public
      - chatwoot_${CLIENT_ID}_mailer:/app/app/views/devise/mailer
      - chatwoot_${CLIENT_ID}_mailers:/app/app/views/mailers
    networks:
      - general_network
    environment:
      - CHATWOOT_HUB_URL=https://oriondesign.art.br/setup#
      - INSTALLATION_NAME=${CLIENT_NAME}
      - SECRET_KEY_BASE=${SECRET_KEY}
      - FRONTEND_URL=https://${DOMAIN}
      - FORCE_SSL=true
      - DEFAULT_LOCALE=es
      - TZ=America/Mexico_City
      - REDIS_URL=redis://redis:6379
      - REDIS_PREFIX=${REDIS_PREFIX}
      - POSTGRES_HOST=postgres
      - POSTGRES_USERNAME=postgres
      - POSTGRES_PASSWORD=b6499d99cc634dcfba39a8173aa7c45b
      - POSTGRES_DATABASE=${DB_NAME}
      - ACTIVE_STORAGE_SERVICE=local
      - MAILER_SENDER_EMAIL=${SMTP_EMAIL} <${SMTP_EMAIL}>
      - SMTP_DOMAIN=gmail.com
      - SMTP_ADDRESS=smtp.gmail.com
      - SMTP_PORT=465
      - SMTP_SSL=true
      - SMTP_USERNAME=${SMTP_EMAIL}
      - SMTP_PASSWORD=${SMTP_PASSWORD}
      - SMTP_AUTHENTICATION=login
      - SMTP_ENABLE_STARTTLS_AUTO=true
      - SMTP_OPENSSL_VERIFY_MODE=peer
      - MAILER_INBOUND_EMAIL_DOMAIN=${SMTP_EMAIL}
      - SIDEKIQ_CONCURRENCY=10
      - RACK_TIMEOUT_SERVICE_TIMEOUT=0
      - RAILS_MAX_THREADS=5
      - WEB_CONCURRENCY=2
      - ENABLE_RACK_ATTACK=false
      - NODE_ENV=production
      - RAILS_ENV=production
      - INSTALLATION_ENV=docker
      - RAILS_LOG_TO_STDOUT=true
      - USE_INBOX_AVATAR_FOR_BOT=true
      - ENABLE_ACCOUNT_SIGNUP=false
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints:
          - node.role == manager
      resources:
        limits:
          cpus: "1"
          memory: 1024M
      labels:
        - traefik.enable=true
        - traefik.http.routers.chatwoot_${CLIENT_ID}_app.rule=Host(\`${DOMAIN}\`)
        - traefik.http.routers.chatwoot_${CLIENT_ID}_app.entrypoints=websecure
        - traefik.http.routers.chatwoot_${CLIENT_ID}_app.tls.certresolver=letsencryptresolver
        - traefik.http.routers.chatwoot_${CLIENT_ID}_app.priority=1
        - traefik.http.routers.chatwoot_${CLIENT_ID}_app.service=chatwoot_${CLIENT_ID}_app
        - traefik.http.services.chatwoot_${CLIENT_ID}_app.loadbalancer.server.port=3000
        - traefik.http.services.chatwoot_${CLIENT_ID}_app.loadbalancer.passhostheader=true
        - traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto=https
        - traefik.http.routers.chatwoot_${CLIENT_ID}_app.middlewares=sslheader@docker

  chatwoot_${CLIENT_ID}_sidekiq:
    image: sendingtk/chatwoot:latest
    command: bundle exec sidekiq -C config/sidekiq.yml
    volumes:
      - chatwoot_${CLIENT_ID}_storage:/app/storage
      - chatwoot_${CLIENT_ID}_public:/app/public
      - chatwoot_${CLIENT_ID}_mailer:/app/app/views/devise/mailer
      - chatwoot_${CLIENT_ID}_mailers:/app/app/views/mailers
    networks:
      - general_network
    environment:
      - CHATWOOT_HUB_URL=https://oriondesign.art.br/setup#
      - INSTALLATION_NAME=${CLIENT_NAME}
      - SECRET_KEY_BASE=${SECRET_KEY}
      - FRONTEND_URL=https://${DOMAIN}
      - FORCE_SSL=true
      - DEFAULT_LOCALE=es
      - TZ=America/Mexico_City
      - REDIS_URL=redis://redis:6379
      - REDIS_PREFIX=${REDIS_PREFIX}
      - POSTGRES_HOST=postgres
      - POSTGRES_USERNAME=postgres
      - POSTGRES_PASSWORD=b6499d99cc634dcfba39a8173aa7c45b
      - POSTGRES_DATABASE=${DB_NAME}
      - ACTIVE_STORAGE_SERVICE=local
      - MAILER_SENDER_EMAIL=${SMTP_EMAIL} <${SMTP_EMAIL}>
      - SMTP_DOMAIN=gmail.com
      - SMTP_ADDRESS=smtp.gmail.com
      - SMTP_PORT=465
      - SMTP_SSL=true
      - SMTP_USERNAME=${SMTP_EMAIL}
      - SMTP_PASSWORD=${SMTP_PASSWORD}
      - SMTP_AUTHENTICATION=login
      - SMTP_ENABLE_STARTTLS_AUTO=true
      - SMTP_OPENSSL_VERIFY_MODE=peer
      - MAILER_INBOUND_EMAIL_DOMAIN=${SMTP_EMAIL}
      - SIDEKIQ_CONCURRENCY=10
      - RACK_TIMEOUT_SERVICE_TIMEOUT=0
      - RAILS_MAX_THREADS=5
      - WEB_CONCURRENCY=2
      - ENABLE_RACK_ATTACK=false
      - NODE_ENV=production
      - RAILS_ENV=production
      - INSTALLATION_ENV=docker
      - RAILS_LOG_TO_STDOUT=true
      - USE_INBOX_AVATAR_FOR_BOT=true
      - ENABLE_ACCOUNT_SIGNUP=false
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints:
          - node.role == manager
      resources:
        limits:
          cpus: "1"
          memory: 1024M

volumes:
  chatwoot_${CLIENT_ID}_storage:
    external: true
  chatwoot_${CLIENT_ID}_public:
    external: true
  chatwoot_${CLIENT_ID}_mailer:
    external: true
  chatwoot_${CLIENT_ID}_mailers:
    external: true

networks:
  general_network:
    external: true
EOF

echo ""
echo "✅ Instalación completada."
echo "🔧 Archivo generado: $STACK_FILE"
echo "📤 Puedes copiar y pegar el contenido en Portainer para desplegar el stack."
