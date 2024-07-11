#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação dos utilitários clientes do PostgreSQL.
if test -z "$(which psql)"
then
  sudo apt install postgresql-client libpq-dev --yes
else
  echo "Os utilitários clientes do PostgreSQL já estão instalados."
fi