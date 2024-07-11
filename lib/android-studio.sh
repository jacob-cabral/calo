#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do Android Studio.
if test -z "$(which android-studio)"
then
  sudo snap install android-studio --stable --classic
else
  echo "O Android Studio já está instalado."
fi