# Chatwoot Full Installer + AutoDeploy a Portainer

Este script:
- Pide datos del cliente (CLIENT_ID, dominio, correo)
- Genera el stack YAML personalizado
- Se conecta a Portainer vía API
- Sube y crea el stack automáticamente

## Ejecución:

```bash
bash <(curl -s https://raw.githubusercontent.com/tendenciadigitalio/chatwoot-full/main/chatwoot-full.sh)
```

Verifica el stack en: https://tuportainer.com/#/stacks
