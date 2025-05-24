# Chatwoot Full Installer (validación + URL personalizada)

Este script instala una instancia de Chatwoot y ahora:

- Solicita usuario, contraseña **y URL de Portainer**
- Verifica que el login sea exitoso
- Aborta si las credenciales o URL son incorrectas
- Evita sobrescribir stacks sin confirmación

## Uso

```bash
bash <(curl -s https://raw.githubusercontent.com/tendenciadigitalio/chatwoot-full/main/chatwoot-full.sh)
```

