#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Trivy.
if test -z "$(which trivy)"
then
  sudo apt install wget apt-transport-https gnupg lsb-release --yes
  wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
  sudo apt update
  sudo apt install trivy --yes
else
  echo "O Trivy já está instalado."
fi