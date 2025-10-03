# Ejercicio 1: Comando tac
# a) Interpretar la página de manual del comando cat, realizar pruebas del comando
# b) Crear un script que imprima el contenido de un archivo de texto de manera invertida, es
# decir primero la última línea, luego la penúltima y así sucesivamente hasta imprimir en
# último lugar la primer línea.
# Nota: existen muchas formas de realizar esto, pueden ser útiles los comandos head y tail-

# Si no se pasa exactamente 1 argumento (el archivo) → mostrar uso y salir
if [ $# -ne 1 ]; then
  echo "Uso: $0 archivo.txt"
  exit 1
fi

archivo="$1"   # el nombre del archivo viene como primer argumento

# Verificar que el archivo exista
if [ ! -f "$archivo" ]; then
  echo "Error: el archivo '$archivo' no existe."
  exit 1
fi

# ------------------------------
# LÓGICA PARA INVERTIR EL ARCHIVO
# ------------------------------

# Contar cuántas líneas tiene el archivo con wc -l
lineas=$(wc -l < "$archivo")

# Bucle que va desde la última línea (lineas) hasta la primera (1)
for i in $(seq "$lineas" -1 1); do
  # head -n $i → muestra las primeras $i líneas
  # tail -n 1 → se queda con la última de esas $i
  # Resultado: la línea número $i
  head -n "$i" "$archivo" | tail -n 1
done
