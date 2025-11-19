#!/bin/bash

# Obtém o perfil de energia ativo no momento
CURRENT_PROFILE=$(powerprofilesctl get)

# Alterna para o próximo perfil em um ciclo
case "$CURRENT_PROFILE" in
  "power-saver")
    powerprofilesctl set balanced
    ;;
  "balanced")
    powerprofilesctl set performance
    ;;
  "performance")
    powerprofilesctl set power-saver
    ;;
  *)
    # Como padrão, volta para o modo equilibrado
    powerprofilesctl set balanced
    ;;
esac
