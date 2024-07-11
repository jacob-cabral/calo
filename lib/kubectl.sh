#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Kubectl.
if test -z "$(which kubectl)"
then
  sudo snap install kubectl --stable --classic
else
  echo "O Kubectl já está instalado."
fi