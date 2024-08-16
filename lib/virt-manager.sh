#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Importação da função de definição da necessidade de reiniciar o sistema operacional.
source util/reboot-needed.sh

# Instalação do Virtual Machine Manager.
if test -z "$(which virt-manager)"
then
  # Instalação da versão mais recente do Virtual Machine Manager e das suas dependências.
  sudo apt install --yes \
                   qemu-kvm \
                   libvirt-daemon \
                   bridge-utils \
                   virtinst \
                   libvirt-daemon-system \
                   virt-top \
                   libguestfs-tools \
                   libosinfo-bin \
                   qemu-system \
                   virt-manager
  # Inclusão do usuário atual como membro dos grupos kvm e libvirt.
  sudo usermod --append --groups kvm,libvirt $USER
  # Definição da necessidade de reiniciar o sistema operacional.
  setRebootNeeded
  echo "O Virtual Machine Manager foi instalado com sucesso."
else
  echo "O Virtual Machine Manager já está instalado."
fi