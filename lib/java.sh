#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do SDKMAN.
if [[ ! -d "$SDKMAN_DIR" ]] || [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]
then
  ./sdkman.sh
fi

# Instalação do OpenJDK.
# Depende do SDKMAN.
if test -z "$(which java)"
then
  sdk install java 17.0.8-tem
else
  echo "O OpenJDK já está instalado."
fi