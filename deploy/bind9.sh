#!/bin/bash
set -e
echo "Implantação do serviço DNS (Bind9)."
prefixlen=$(ip -json address show $ifname | jq -r '.[].addr_info[] | select(.family = "inet").prefixlen')
cidr=$ip/$prefixlen
ipReverso=$(echo $ip | sed --expression='s/^\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\).\+$/\3.\2.\1/')
octeto=$(echo $ip | sed --expression='s/^\([0-9]\{1,3\}\).\+$/\1/')
# Provisionar o contêiner.
sudo lxc init ubuntu:22.04 nomes --config=limits.cpu=1 --config=limits.cpu.allowance=50% --config=limits.memory=256MiB
# Adicionar a interface de rede ao contêiner.
sudo lxc config device add nomes eth0 nic nictype=bridged parent=$ifname
# Iniciar o contêiner e aguardar por 30 s a ativação dos seus serviços.
sudo lxc start nomes
sleep 30
# Configurar a interface de rede.
sudo lxc exec nomes -- sudo sh -c "cat << EOF > /etc/netplan/50-cloud-init.yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    version: 2
    ethernets:
        eth0:
            addresses:
            - $cidr
            routes:
            - to: default
              via: $gateway
            nameservers:
                addresses:
                - 1.0.0.1
                - 1.1.1.1
                - 8.8.4.4
                - 8.8.8.8
                - 9.9.9.9
                search:
                - $dominio
EOF"
sudo lxc exec nomes -- sudo chmod --recursive o-r /etc/netplan
sudo lxc exec nomes -- sudo netplan apply
# Atualizar o sistema operacional.
sudo lxc exec nomes -- sudo apt update
sudo lxc exec nomes --env=NEEDRESTART_MODE=a --env=DEBIAN_FRONTEND=noninteractive -- sudo apt upgrade --yes
sudo lxc exec nomes --env=NEEDRESTART_MODE=a --env=DEBIAN_FRONTEND=noninteractive -- sudo apt autoremove --yes
sudo lxc exec nomes -- sudo apt autoclean
# Instalar e configurar o Bind9 (https://wiki.debian.org/Bind9).
sudo lxc exec nomes -- sudo apt install bind9 --yes
sudo lxc exec nomes -- sudo sh -c "cat << EOF > /etc/bind/named.conf.local
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include \"/etc/bind/zones.rfc1918\";

zone \"$dominio\" {
  type master;
  file \"/etc/bind/db.$dominio\";
};

zone \"$ipReverso.in-addr.arpa\" {
    type master;
    file \"/etc/bind/db.$octeto\";
};
EOF"
sudo lxc exec nomes -- sudo sh -c "cat << EOF > /etc/bind/named.conf.options
options {
  directory \"/var/cache/bind\";

  // If there is a firewall between you and nameservers you want
  // to talk to, you may need to fix the firewall to allow multiple
  // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

  // If your ISP provided one or more IP addresses for stable
  // nameservers, you probably want to use them as forwarders.
  // Uncomment the following block, and insert the addresses replacing
  // the all-0's placeholder.

  forwarders {
      1.0.0.1;
      1.1.1.1;
      8.8.4.4;
      8.8.8.8;
      9.9.9.9;
  };

  //========================================================================
  // If BIND logs error messages about the root key being expired,
  // you will need to update your keys.  See https://www.isc.org/bind-keys
  //========================================================================
  dnssec-validation no;

  listen-on { any; };
};
EOF"
sudo lxc exec nomes -- sudo sh -c "cat << EOF > /etc/bind/db.$dominio
;
; BIND arquivo de dados para o domínio $dominio.
;
\\\$TTL    604800
@                               IN      SOA     $dominio. root.$dominio. (
                                      1         ; Serial
                                 604800         ; Refresh
                                  86400         ; Retry
                                2419200         ; Expire
                                 604800 )       ; Negative Cache TTL
@                               IN      NS      nomes.$dominio.
@                               IN      A       $ip
nomes                           IN      A       $ip
$(printf "%-29s" $subdominio)   IN      A       $gateway
$(printf "*.%-29s" $subdominio) IN      CNAME   $subdominio
EOF"
sudo lxc exec nomes -- sudo sh -c "cat << EOF > /etc/bind/db.$octeto
;
; BIND arquivo de dados reversos para a rede.
;
\\\$TTL   604800
@   IN  SOA  nomes.$dominio. root.$dominio. (
                1   ; Serial
     604800   ; Refresh
      86400   ; Retry
    2419200   ; Expire
     604800 ) ; Negative Cache TTL
;
@   IN  NS   nomes.
10  IN  PTR  nomes.$dominio.
EOF"
# Reiniciar o serviço do Bind9 (https://wiki.debian.org/Bind9).
sudo lxc exec nomes -- sudo systemctl restart bind9.service
unset ifname gateway prefixlen cidr ipReverso octeto
echo "O Bind9 foi implantado com sucesso."