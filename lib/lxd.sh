#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do LXD.
if test -z "$(which lxd)"
then
  sudo snap install lxd --stable
  sudo usermod --append --groups lxd $USER
  echo "O LXD foi instalado com sucesso. Contudo, a sessão do usuário deve ser reiniciada, para que os recursos do LXD sejam disponibilizados sem a necessidade de acesso privilegiado (sudo)."
else
  echo "O LXD já está instalado."
fi