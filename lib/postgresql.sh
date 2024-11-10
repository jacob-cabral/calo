#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação dos utilitários clientes do PostgreSQL.
if test -z "$(which psql)"
then
  sudo curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor --output /etc/apt/trusted.gpg.d/postgresql.gpg
  sudo sh -c 'echo "deb[arch=amd64 signed-by=/etc/apt/trusted.gpg.d/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  sudo apt update
  sudo apt install postgresql-client-14 libpq-dev --yes
else
  echo "Os utilitários clientes do PostgreSQL já estão instalados."
fi