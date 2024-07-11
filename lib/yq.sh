#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do CLI processador de YAML.
if test -z "$(which yq)"
then
  sudo snap install yq --stable
else
  echo "O CLI processador de YAML já está instalado."
fi