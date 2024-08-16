#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Importação da função de definição da necessidade de reiniciar o sistema operacional.
source util/reboot-needed.sh

# Instalação do Docker.
if test -z "$(which docker)"
then
# Importação da chave PGP oficial do Docker.
sudo apt install ca-certificates curl --yes
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Configução do repositório APT do Docker.
cat <<- EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable
EOF
# Instalação da versão mais recente do Docker.
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --yes
# Inclusão do usuário atual como membro do grupo do Docker.
sudo usermod --append --groups docker $USER
# Definição do diretório raiz dos dados do Docker.
cat <<- EOF | sudo tee /etc/docker/daemon.json
{
  "data-root": "/var/lib/docker"
}
EOF
sudo systemctl restart docker.service
# Definição da necessidade de reiniciar o sistema operacional.
setRebootNeeded
else
echo "O Docker já está instalado."
fi