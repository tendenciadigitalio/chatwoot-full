# Crear volúmenes para Chatwoot en Docker

Este script permite crear los volúmenes necesarios para una instancia de Chatwoot, útil antes de desplegar el stack desde Portainer.

## 🔧 ¿Qué hace?

Crea los siguientes volúmenes:

- `chatwoot_storage` → Archivos de conversaciones
- `chatwoot_public` → Logos e imágenes públicas
- `chatwoot_mailer` → Plantillas de email para Devise
- `chatwoot_mailers` → Plantillas de otros emails
- `chatwoot_pgdata` → Base de datos PostgreSQL
- `chatwoot_redisdata` → Caché Redis

## 🧪 ¿Cuándo usarlo?

Antes de desplegar tu stack en Portainer. Portainer no puede crear automáticamente volúmenes externos si están declarados sin datos en el YAML.

## 🚀 ¿Cómo ejecutarlo?

```bash
bash create-chatwoot-volumes.sh
```

Este comando debe ejecutarse en tu servidor Docker.

## ✅ Requisitos

- Tener Docker instalado y corriendo
- Tener permisos de administrador

