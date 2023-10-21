#!/bin/bash

# Ruta de la carpeta que deseas sincronizar
CARPETA_ORIGEN="/path/backups/"
# Ruta de la carpeta de destino en el servidor remoto
CARPETA_DESTINO="usuario@dominio:/path_destino/backups/"
# Puerto personalizado
PUERTO="xxxx"
# Ruta al archivo de certificado personalizado
CERTIFICADO="/home/usuario/certificado"
# Nombre del dominio dinámico
DOMINIO_DINAMICO="dominio.com"
# Obtén la dirección IP actual del dominio dinámico
DIRECCION_IP=$(nslookup $DOMINIO_DINAMICO | grep 'Address' | tail -n1 | awk '{print $2}')
# Agrega una regla iptables para permitir la conexión de salida al dominio dinámico en el puerto específico
iptables -A INPUT -p tcp -m tcp --sport $PUERTO -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -d $DIRECCION_IP --dport $PUERTO -j ACCEPT

# Ejecuta la sincronización con rsync y especifica el comando para utilizar el certificado
rsync -avz -e "ssh -p $PUERTO -i $CERTIFICADO" $CARPETA_ORIGEN $CARPETA_DESTINO

# Elimina la regla iptables una vez que la sincronización ha terminado
iptables -D INPUT -p tcp -m tcp --sport $PUERTO -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -D OUTPUT -p tcp -d $DIRECCION_IP --dport $PUERTO -j ACCEPT
