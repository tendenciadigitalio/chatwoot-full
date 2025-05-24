# Chatwoot Full Installer (versión reforzada)

Esta versión incluye:
- Verificación previa de base de datos en PostgreSQL
- Soporte para leer contraseña desde `portainer_pass.txt`
- Mensajes más claros de validación del token JWT
- Depuración en caso de error con el stack

## Uso:

1. Opcional: crear archivo `portainer_pass.txt` con tu contraseña (modo automático)
2. Ejecutar:

```bash
bash <(curl -s https://raw.githubusercontent.com/tendenciadigitalio/chatwoot-full/main/chatwoot-full.sh)
```

