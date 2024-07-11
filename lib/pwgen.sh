#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do PWgen.io (Password Generator).
if test -z "$(which pwgen)"
then
  sudo apt install pwgen --yes
else
  echo "O PWgen.io (Password Generator) já está instalado."
fi