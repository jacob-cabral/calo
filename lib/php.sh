#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do PHP.
if test -z "$(which php)"
then
  sudo apt install php-cli php-pear --yes
else
  echo "O PHP já está instalado."
fi