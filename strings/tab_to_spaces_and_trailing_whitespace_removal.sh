#!/bin/bash

# Verifica que se hayan proporcionado dos argumentos: directorio y tipo de archivo
if [ $# -ne 2 ]; then
    echo "Uso: $0 <directorio> <tipo_de_archivo>"
    exit 1
fi

# Obtén el directorio y el tipo de archivo como argumentos
directorio="$1"
tipo_archivo="$2"

# Función recursiva para convertir tabuladores en espacios y eliminar espacios en blanco al final de cada línea
function procesar_archivos {
    local dir="$1"
    local tipo="$2"
    for archivo in "$dir"/*; do
        if [ -d "$archivo" ]; then
            # Si es un directorio, llama a la función recursivamente
            procesar_archivos "$archivo" "$tipo"
        elif [ -f "$archivo" -a "${archivo##*.}" = "$tipo" ]; then
            # Si es un archivo del tipo especificado, realiza la conversión y limpieza
            vim -c "set tabstop=4" -c "execute 'argdo %s/\\t/    /g' | update" -c "execute 'argdo %s/\\s\\+$//e' | update" -c "wa" -c "q" "$archivo"
            echo "Conversión y limpieza completadas en $archivo"
        fi
    done
}

# Llama a la función recursiva
procesar_archivos "$directorio" "$tipo_archivo"

echo "Conversión y limpieza completadas en archivos de $directorio y subdirectorios con extensión $tipo_archivo."
