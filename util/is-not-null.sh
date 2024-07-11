#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Definição da função que valida valores não nulos.
isNotNull() {
  variableName=$1

  if test -z "${variableName}"
  then
    echo "O nome da variável é obrigatório."
    exit 1
  else
    variableValue="${!variableName}"

    if test -z "${variableValue}"
    then
      echo "O valor da variável ${variableName} deve ser informado, não podendo ser nulo ou vazio."
      exit 1
    fi
  fi
}