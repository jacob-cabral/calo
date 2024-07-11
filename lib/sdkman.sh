#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do SDKMAN.
if [[ ! -d "$SDKMAN_DIR" ]] || [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]
then
curl -s "https://get.sdkman.io" | bash
cat << EOF >> ~/.bashrc

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="\$HOME/.sdkman"
[[ -s "\$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "\$SDKMAN_DIR/bin/sdkman-init.sh"
EOF
source ~/.bashrc
else
  echo "O SDKMAN já está instalado."
fi