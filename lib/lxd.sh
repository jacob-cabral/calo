#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Importação da função de definição da necessidade de reiniciar o sistema operacional.
source util/reboot-needed.sh

# Instalação do LXD.
if test -z "$(which lxd)"
then
  # Instalação da versão estável do LXD.
  sudo snap install lxd --stable
  # Inclusão do usuário atual como membro do grupo do LXD.
  sudo usermod --append --groups lxd $USER
  # Definição da necessidade de reiniciar o sistema operacional.
  setRebootNeeded
else
  echo "O LXD já está instalado."
fi