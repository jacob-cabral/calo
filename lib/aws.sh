#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do AWS CLI.
if test -z "$(which aws)"
then
  sudo snap install aws-cli --stable --classic
else
  echo "O AWS CLI já está instalado."
fi