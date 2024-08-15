#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do FortiClient.
if test -z "$(which forticlient)"
then
  jammySources=/etc/apt/sources.list.d/jammy.list

  if ! test -f ${jammySources}
  then
    echo "deb http://archive.ubuntu.com/ubuntu jammy main universe" | sudo tee ${jammySources}
    sudo apt update
  fi

  installer=/tmp/forticlient-vpn.deb
  curl --location --output $installer https://links.fortinet.com/forticlient/deb/vpnagent
  sudo dpkg --install $installer
  sudo apt install --fix-broken --yes
  rm $installer
  unset installer
else
  echo "O FortiClient já está instalado."
fi