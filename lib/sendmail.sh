#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Sendmail.
if test -z "$(which sendmail)"
then
  sudo apt install sendmail --yes
else
  echo "O Sendmail já está instalado."
fi