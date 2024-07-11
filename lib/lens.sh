#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Lens Desktop.
if test -z "$(which lens-desktop)"
then
  curl -fsSL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lens-archive-keyring.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | sudo tee /etc/apt/sources.list.d/lens.list > /dev/null
  sudo apt update && sudo apt install lens --yes
else
  echo "O Lens Desktop já está instalado."
fi