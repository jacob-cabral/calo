#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do DBeaver.
if test -z "$(which dbeaver-ce)"
then
  sudo snap install dbeaver-ce --stable
else
  echo "O DBeaver já está instalado."
fi