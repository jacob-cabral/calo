#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do LXD.
if test -z "$(which lxd)"
then
  sudo snap install lxd --stable
else
  echo "O LXD já está instalado."
fi