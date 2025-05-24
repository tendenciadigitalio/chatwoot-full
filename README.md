# Chatwoot Full Installer + Post Setup

Este script:
- Pide los datos del cliente
- Genera el archivo YAML del stack
- Lo sube automáticamente a Portainer (URL fija)
- Ejecuta migraciones (`db:prepare`) y opcionalmente `db:seed` en el contenedor principal

## Uso desde el servidor:

```bash
bash <(curl -s https://raw.githubusercontent.com/tendenciadigitalio/chatwoot-full/main/chatwoot-full.sh)
```

