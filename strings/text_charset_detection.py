import encodings.aliases

# Define el texto de entrada y la salida esperada
texto = "PrÃ³ximo dÃ­a recogida..."
salida_esperada = "Próximo día recogida..."

# Lista de charsets a probar
charsets = ['utf-8', 'latin-1', 'iso-8859-1', 'windows-1252', 'utf-16', 'utf-32']

# Obtener una lista de los charsets disponibles
#charsets = set(encodings.aliases.aliases.values())

# Imprimir la lista de charsets
#for charset in charsets:
#    print(charset)

# Función para decodificar el texto con un charset y verificar si coincide con la salida esperada
def probar_charset(charset):
    try:
        texto_decodificado = texto.encode(charset).decode('utf-8')
        if texto_decodificado == salida_esperada:
            print(f'Charset correcto: {charset}')
    except UnicodeDecodeError as e:
        print(f'Error en el charset {charset}: {e}')

# Probar cada charset de la lista
for charset in charsets:
    probar_charset(charset)
