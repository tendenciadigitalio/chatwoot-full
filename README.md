# Chatwoot Volúmenes por Cliente

Este repositorio contiene un script Bash que permite crear volúmenes personalizados por cliente para una instancia de Chatwoot.

## 🚀 ¿Qué hace?

1. Pregunta el nombre del cliente.
2. Crea los volúmenes necesarios para ese cliente:
   - `chatwoot_<cliente>_storage`
   - `chatwoot_<cliente>_public`
   - `chatwoot_<cliente>_mailer`
   - `chatwoot_<cliente>_mailers`
   - `chatwoot_<cliente>_pgdata`
   - `chatwoot_<cliente>_redisdata`

## ✅ Requisitos

- Docker instalado
- Acceso al servidor donde se ejecuta el stack

## 🧪 Uso

### Opción 1: Desde el servidor

```bash
chmod +x create-chatwoot-volumes.sh
./create-chatwoot-volumes.sh
```

### Opción 2: Desde GitHub

```bash
bash <(curl -s https://raw.githubusercontent.com/tendenciadigitalio/chatwoot-volumes/main/create-chatwoot-volumes.sh)
```

> Reemplaza `tu-usuario` por tu nombre real de usuario en GitHub.

---
