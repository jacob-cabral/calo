#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

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
# Intalação da versão mais recente do Docker.
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Inclusão do usuário atual como membro do grupo do Docker.
sudo usermod --append --groups docker $USER
cat <<- EOF | sudo tee /etc/docker/daemon.json
{
  "data-root": "/var/lib/docker"
}
EOF
sudo systemctl restart docker.service
echo "O Docker foi instalado com sucesso. Contudo, a sessão do usuário deve ser reiniciada, para que os recursos do Docker sejam disponibilizados sem a necessidade de acesso privilegiado (sudo)."
else
  echo "O Docker já está instalado."
fi