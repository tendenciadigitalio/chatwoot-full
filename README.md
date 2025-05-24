# Instalador único de Chatwoot - Tipo Orion

Este script genera una instancia de Chatwoot para cada cliente.

## ¿Qué hace?

- Pide datos del cliente
- Crea el archivo `docker stack` personalizado
- Despliega el stack usando Docker Swarm
- Ejecuta `rails db:prepare` para preparar la base de datos

## Uso

```bash
bash <(curl -s https://raw.githubusercontent.com/tendenciadigitalio/chatwoot-full/main/chatwoot-full.sh)
```

Asegúrate de tener Docker Swarm y Traefik configurados previamente.
