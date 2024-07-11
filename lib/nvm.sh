#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do NVM.
if [[ ! -d "$NVM_DIR" ]] || [[ ! -s "$NVM_DIR/nvm.sh" ]]
then
  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
else
  echo "O NVM já está instalado."
fi