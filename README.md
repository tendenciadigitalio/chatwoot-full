# Chatwoot Full Installer

Este script automatiza completamente la instalación de una instancia de Chatwoot en servidores Docker Swarm que utilizan Portainer y Traefik.

## ¿Qué hace?

- Solicita los datos del cliente.
- Crea volúmenes Docker.
- Crea una base de datos en PostgreSQL.
- Genera el archivo YAML del stack para Portainer.

## Uso

```bash
bash <(curl -s https://raw.githubusercontent.com/TU_USUARIO/chatwoot-full/main/chatwoot-full.sh)
```

## Seguridad

Este script no expone ni accede remotamente a tu servidor. Solo se ejecuta bajo tu control.

