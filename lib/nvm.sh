#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Importação da função de definição da necessidade de reiniciar o sistema operacional.
source util/reboot-needed.sh

# Instalação do NVM.
if [[ ! -d "$NVM_DIR" ]] || [[ ! -s "$NVM_DIR/nvm.sh" ]]
then
  # Instalação da versão mais recente do NVM.
  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  # Definição da necessidade de reiniciar o sistema operacional.
  setRebootNeeded
else
  echo "O NVM já está instalado."
fi