#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do VS Code.
if test -z "$(which code)"
then
  sudo snap install code --stable --classic
else
  echo "O VS Code já está instalado."
fi