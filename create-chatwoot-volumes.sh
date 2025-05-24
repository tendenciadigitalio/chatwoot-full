#!/bin/bash
# Crea todos los volúmenes necesarios para Chatwoot manualmente
docker volume create chatwoot_storage
docker volume create chatwoot_public
docker volume create chatwoot_mailer
docker volume create chatwoot_mailers
docker volume create chatwoot_pgdata
docker volume create chatwoot_redisdata
