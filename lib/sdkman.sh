#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do SDKMAN.
if [[ ! -d "$SDKMAN_DIR" ]] || [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]
then
curl -s "https://get.sdkman.io?rcupdate=false" | bash
if test -z "$(grep 'SDKMAN' $HOME/.bashrc)"
then
cat << EOF | tee --append "$HOME/.bashrc"

# SDKMAN! Configuration
export SDKMAN_DIR="\$HOME/.sdkman"
[[ -s "\$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "\$SDKMAN_DIR/bin/sdkman-init.sh"
EOF
source "$HOME/.bashrc"
fi
else
  echo "O SDKMAN já está instalado."
fi