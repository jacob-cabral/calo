#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Net Tools.
if test -z "$(which netstat)"
then
  sudo apt install net-tools --yes
else
  echo "O Net Tools já está instalado."
fi