#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Virtual Machine Manager.
if test -z "$(which virt-manager)"
then
  sudo apt install virt-manager --yes
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
else
  echo "O Virtual Machine Manager já está instalado."
fi