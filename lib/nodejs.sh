#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do NVM.
if [[ ! -d "$NVM_DIR" ]] || [[ ! -s "$NVM_DIR/nvm.sh" ]]
then
  lib/nvm.sh
  source ~/.nvm/nvm.sh
fi

# Instalação do NodeJS 16.
if test -z "$(which node)"
then
  nvm install 16
else
  echo "O NodeJS já está instalado."
fi