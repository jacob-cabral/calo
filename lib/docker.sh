#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Docker.
if test -z "$(which docker)"
then
sudo apt install --yes docker docker-buildx docker-clean docker-compose-v2 docker-doc docker.io
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