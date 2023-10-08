#!/bin/bash
# Para cada archivo, verifica si es un archivo regular y, si es así, 
# lo renombra para asegurarse de que su nombre esté en formato ASCII
# útilidad para resolver problemas con nombres ficheros

if [ $# -ne 1 ]; then
    echo "Uso: $0 directorio"
    exit 1
fi

directorio="$1"

for file in "$directorio"/*; do
    if [ -f "$file" ]; then
        new_file=$(echo "$file" | iconv -f UTF-8 -t ASCII//TRANSLIT)
        mv "$file" "$new_file"
    fi
done
