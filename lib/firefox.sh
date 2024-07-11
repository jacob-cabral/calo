#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Firefox.
if test -z "$(which firefox)"
then
  sudo snap install firefox --stable
else
  echo "O Firefox já está instalado."
fi