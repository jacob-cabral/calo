#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do MinIO Client.
if test -z "$(which mc)"
then
  curl --output /tmp/mc https://dl.min.io/client/mc/release/linux-amd64/mc
  sudo install --mode=755 /tmp/mc /usr/local/bin/mc
  rm /tmp/mc
else
  echo "O MinIO Client já está instalado."
fi