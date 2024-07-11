#!/bin/bash
set -e

# Configurar o hospedeiro como cliente do serviço DNS.
configuracaoDNS=/etc/systemd/resolved.conf
fallbackDNS=$(grep --regexp='^nameserver.\+' /etc/resolv.conf | grep --only-matching --regexp='[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
if [ -z $(grep --regexp=^DNS=$ip$ $configuracaoDNS) ]
then
  echo "Configuração do hospedeiro como cliente do serviço DNS."
  sudo sed --in-place --expression="s/^#\?\(DNS\)=.*$/\1=$ip/" $configuracaoDNS
  sudo sed --in-place --expression="s/^#\?\(FallbackDNS\)=.*$/\1=$fallbackDNS/" $configuracaoDNS
  sudo sed --in-place --expression="s/^#\?\(Domains\)=.*$/\1=$dominio/" $configuracaoDNS
  sudo systemctl restart systemd-resolved.service
else
  echo "Hospedeiro já configurado como cliente do serviço DNS."
fi