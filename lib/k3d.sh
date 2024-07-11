#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do K3D.
if test -z "$(which k3d)"
then
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
  echo "O K3D já está instalado."
fi