#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Importação da função de definição da necessidade de reiniciar o sistema operacional.
source util/reboot-needed.sh

# Instalação do NVM.
if [[ ! -d "$NVM_DIR" ]] || [[ ! -s "$NVM_DIR/nvm.sh" ]]
then
  # Instalação da versão mais recente do NVM.
  curl --output - https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | sudo bash
  # Definição da necessidade de reiniciar o sistema operacional.
  setRebootNeeded
else
  echo "O NVM já está instalado."
fi