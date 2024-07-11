#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Kubeseal.
if test -z "$(which kubeseal)"
then
  KUBESEAL_VERSION='0.25.0'
  wget "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION:?}/kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz"
  tar -xvzf kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz kubeseal
  sudo install -m 755 kubeseal /usr/local/bin/kubeseal
  rm -r kubeseal*
else
  echo "O Kubeseal já está instalado."
fi