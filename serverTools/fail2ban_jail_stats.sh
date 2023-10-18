#!/bin/bash

# Lista de todos los jails
jails=$(sudo fail2ban-client status | awk -F":" '/Jail list/ {print $2}' | sed 's/,/ /g')

# Recorre la lista de jails y muestra estadísticas
for jail in $jails; do
  jail=$(echo $jail | xargs) # Eliminar espacios en blanco al inicio y final, si los hay
  echo "Estadísticas para el jail: $jail"
  sudo fail2ban-client status $jail
  echo "---------------------------"
done
