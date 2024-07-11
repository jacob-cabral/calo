#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Discord.
if test -z "$(which discord)"
then
  sudo snap install discord
else
  echo "O Discord já está instalado."
fi