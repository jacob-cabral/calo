#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Importação de funções utilitárias.
source util/is-not-null.sh
source util/reboot-needed.sh

# Importação das funções de verificação e definição da necessidade de reiniciar o sistema operacional.

# Obtenção do diretório dos certificados SSL.
diretorioCertificados="$PWD"

# Validação dos nomes de domínio e subdomínio.
isNotNull dominio
isNotNull subdominio

# Definição dos diretórios raiz das configurações.
diretorioRaiz=$(dirname "$(realpath "$0")")
cd "${diretorioRaiz}"

# Atualização dos pacotes do sistema operacional.
sudo apt update && sudo apt upgrade --yes && sudo apt autoremove --yes && sudo apt autoclean

# Instalação das bibliotecas.
for file in $(ls lib)
do
  installer=lib/${file}
  chmod ug+x ${installer}
  ${installer}
done

# Verificar a necessidade de reiniciar.
isRebootNeeded

# Iniciar o LXD, se necessário.
if test -z "$(lxc storage list --format=json | jq '.[] | select(.name)')"
then
  echo "Iniciando o LXD."
  lxd init --minimal
else
  echo "O LXD está iniciado."
fi
# Implantação do Bind9 e configuração do domínio de exemplo.
estadoServidorNomes=$(lxc list nomes --format json | jq --raw-output '.[].status')
ifname=lxdbr0
gateway=$(ip -json address show $ifname | jq --raw-output 'limit(1; .[].addr_info[] | select(.family == "inet") | .local)')
ip=$(echo $gateway | sed --expression='s/^\(.\+\)\(\.[0-9]\{1,3\}\)$/\1.53/g')

if test -z "$estadoServidorNomes"
then
  echo "A implantação do serviço DNS está pendente."
  dominio=$dominio subdominio=$subdominio ifname=$ifname gateway=$gateway ip=$ip deploy/bind9.sh
  dominio=$dominio ip=$ip util/dns-client.sh
else
  if test "RUNNING" != "${estadoServidorNomes^^}"
  then
    echo "Iniciando o serviço DNS (Bind9)."
    lxc start nomes
    echo "O serviço DNS (Bind9) foi iniciado com sucesso."
  else
    echo "O serviço DNS (Bind9) está em execução."
    ipCluster=$(dig +short $subdominio.$dominio)
    if test -z "$ipCluster"
    then
      echo "A configuração do nome de domínio do cluster está pendente."
      exit 1
    fi
  fi
fi

# Implantação do cluster Kubernetes.
clusters=$(k3d cluster list --output=json | jq --raw-output '.[]')
isClusterCreated=""

if test ! -z "$clusters"
then
  clusters=$(echo $clusters | jq --raw-output '.name')
  for cluster in ${clusters[@]}
  do
    if test "$subdominio" == "$cluster"
    then
      isClusterCreated=true
      break
    fi
  done
fi

if test -z "$isClusterCreated"
then
  echo "Criação do cluster $subdominio."
  dominio=$dominio subdominio=$subdominio ipServidorNomes=$ip diretorioCertificados=$diretorioCertificados deploy/cluster.sh
else
  echo "O cluster $subdominio já existe."
  exit 0
fi