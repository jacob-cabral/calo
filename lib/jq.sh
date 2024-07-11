#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do CLI processador de JSON.
if test -z "$(which jq)"
then
  sudo apt install jq --yes
else
  echo "O CLI processador de JSON já está instalado."
fi