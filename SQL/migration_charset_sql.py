#!/bin/python3

import mysql.connector
import yaml
import sys

# Verificar que se pasen al menos 4 argumentos (nombre del script + 3 argumentos)
if len(sys.argv) < 4:
    print("Uso: python migration_charset_sql.py <tabla> <id_tabla> <columna1> <columna2> ...")
    sys.exit(1)

# Obtener los argumentos de línea de comandos
tabla = sys.argv[1]
id_tabla = sys.argv[2]
columnas_mal_codificadas = sys.argv[3:]

# Cargar la configuración desde el archivo YAML
with open('config_db.yaml', 'r') as config_file:
    config = yaml.safe_load(config_file)

# Establecer la conexión a la base de datos
conexion = mysql.connector.connect(
    host=config['database']['host'],
    user=config['database']['user'],
    password=config['database']['password'],
    database=config['database']['database']
)

# Crea un cursor para ejecutar consultas SQL
cursor = conexion.cursor()

# Nombre de la tabla y columna problemática
tabla = tabla
id_tabla = id_tabla

# Crea una lista de columnas mal codificadas que deseas actualizar
columnas_mal_codificadas = columnas_mal_codificadas

# Lista de listas para almacenar las cadenas problemáticas de cada columna
cadenas_problematicas_por_columna = []

# Itera a través de las columnas
for columna_mal_codificada in columnas_mal_codificadas:
    # Define una consulta SQL para seleccionar todos los registros de la tabla
    sql = f"SELECT {id_tabla}, {columna_mal_codificada} FROM {tabla}"

    # Ejecuta la consulta
    cursor.execute(sql)

    # Asegúrate de que todos los resultados se lean y procesen completamente
    #cursor.fetchall()
    result = cursor.fetchall()

    # Lista para almacenar las cadenas problemáticas de esta columna
    cadenas_problematicas = []

    # Itera a través de los registros y realiza las actualizaciones
    for (id_row, texto_mal_codificado) in result:
        # Muestra el texto original antes de la corrección
        print(f'Texto original: {texto_mal_codificado}')

        try:
            # Corrige la codificación y actualiza la columna en la base de datos
            texto_decodificado = texto_mal_codificado.encode('latin-1').decode('utf-8')
            update_sql = f"UPDATE {tabla} SET {columna_mal_codificada} = %s WHERE {id_tabla} = %s"
            cursor.execute(update_sql, (texto_decodificado, id_row))
        except UnicodeEncodeError as e:
            print(f"Error de decodificación: {e}")
            # Agrega la cadena problemática a la lista de esta columna
            cadenas_problematicas.append(texto_mal_codificado)
            continue

    # Agrega la lista de cadenas problemáticas de esta columna a la lista general
    cadenas_problematicas_por_columna.append(cadenas_problematicas)

    # Al final del bucle de la columna, puedes imprimir las cadenas problemáticas
    print(f"Cadenas problemáticas de la columna {columna_mal_codificada}:")
    for cadena in cadenas_problematicas:
        print(cadena)

# Cierra el cursor y confirma los cambios en la base de datos
cursor.close()
conexion.commit()

# Cierra la conexión
conexion.close()
