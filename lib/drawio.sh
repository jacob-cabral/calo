#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Draw.io.
if test -z "$(which drawio)"
then
  curl --silent https://api.github.com/repos/jgraph/drawio-desktop/releases/latest | jq --raw-output '.assets[].browser_download_url | select(test(".+drawio\\-amd64\\-.+\\.deb"))' | wget --input-file -
  package=$(ls . | grep --regexp="drawio\-amd64\-.\+\.deb")
  sudo dpkg --install $package
  rm --force $package
  unset package
else
  echo "O Draw.io já está instalado."
fi