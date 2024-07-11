#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do CLI do Goocle Cloud e do plugin de autenticação do GKE.
if test -z "$(which gcloud)"
then
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor --yes --output /usr/share/keyrings/cloud.google.gpg
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
  sudo apt update && sudo apt install google-cloud-cli google-cloud-sdk-gke-gcloud-auth-plugin --yes
else
  echo "O CLI do Goocle Cloud já está instalado."
fi