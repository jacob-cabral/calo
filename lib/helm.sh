#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Helm.
if test -z "$(which helm)"
then
  sudo snap install helm --stable --classic
else
  echo "O Helm já está instalado."
fi