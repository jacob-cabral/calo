#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Git.
if test -z "$(which git)"
then
  sudo apt install git --yes
else
  echo "O Git já está instalado."
fi