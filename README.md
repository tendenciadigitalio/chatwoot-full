# Script para crear volúmenes de Chatwoot por cliente

Este script permite crear los volúmenes necesarios para una instancia personalizada de Chatwoot en Docker, identificados por cliente.

## 🚀 ¿Cómo funciona?

1. Te pide el nombre corto del cliente (ej. `basal`)
2. Crea estos volúmenes:

- `chatwoot_basal_storage`
- `chatwoot_basal_public`
- `chatwoot_basal_mailer`
- `chatwoot_basal_mailers`
- `chatwoot_basal_pgdata`
- `chatwoot_basal_redisdata`

Estos volúmenes deben coincidir con los definidos en tu archivo `stack-chatwoot-basal.yml` dentro de Portainer.

## ✅ Requisitos

- Tener Docker instalado
- Tener acceso al servidor
- La red `general_network` ya debe estar creada (según el YAML)

## 🧪 Uso

```bash
bash create-chatwoot-volumes.sh
```

Luego despliega el stack correspondiente en Portainer usando el `.yml` que utiliza los mismos nombres de volúmenes.

