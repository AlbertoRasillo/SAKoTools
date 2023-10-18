#!/bin/bash

# URL de la lista de bloqueo de firehol.org
URL="https://iplists.firehol.org/files/firehol_level1.netset"

# Ruta al archivo de conjunto ipset
IPSET_FILE="firehol_level1.netset"

# Descarga la lista de bloqueo de firehol.org y procesa las direcciones IP
wget -q -O - $URL | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' > $IPSET_FILE

# Actualiza el conjunto ipset
ipset flush blacklist
ipset restore < $IPSET_FILE

# Aplica las reglas de iptables
#iptables -A INPUT -m set --match-set blacklist src -j DROP
