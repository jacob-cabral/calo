#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do pgModeler (PostgreSQL Database Modeler).
if test -z "$(which pgmodeler)"
then
  sudo apt install pgmodeler --yes
else
  echo "O pgModeler (PostgreSQL Database Modeler) já está instalado."
fi