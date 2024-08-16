#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do SDKMAN.
if [[ ! -d "$SDKMAN_DIR" ]] || [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]
then
curl -s "https://get.sdkman.io?rcupdate=false" | bash
cat << EOF | sudo tee /etc/profile.d/sdkman.sh
# SDKMAN! Configuration
export SDKMAN_DIR="\$HOME/.sdkman"
[[ -s "\$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "\$SDKMAN_DIR/bin/sdkman-init.sh"
EOF
if test -z "$(grep 'sdkman.sh' $HOME/.bashrc)"
then
  printf "\n%s\n%s\n" "# SDKMAN! Configuration" "source /etc/profile.d/sdkman.sh" >> $HOME/.bashrc
fi
source ~/.bashrc
else
  echo "O SDKMAN já está instalado."
fi