#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Obtém o arquivo de marcação da necessidade de reiniciar o sistema operacional.
getMarkupFile() {
  echo -n /tmp/.reboot.needed
}

# Verifica a necessidade de reiniciar o sistema operacional.
isRebootNeeded() {
  if test -f "$(getMarkupFile)"
  then
    echo "É necessário reiniciar o sistema operacional."
    exit 1
  fi
}

# Define a necessidade de reiniciar o sistema operacional.
setRebootNeeded() {
  touch "$(getMarkupFile)"
}