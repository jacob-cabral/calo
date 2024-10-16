#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Flux CLI.
if test -z "$(which flux)"
then
  curl -s https://fluxcd.io/install.sh | sudo FLUX_VERSION=2.3.0 bash
else
  echo "O Flux CLI já está instalado."
fi