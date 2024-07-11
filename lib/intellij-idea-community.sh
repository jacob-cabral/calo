#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do IntelliJ.
if test -z "$(which intellij-idea-community)"
then
  sudo snap install intellij-idea-community --stable --classic
else
  echo "O IntelliJ já está instalado."
fi