#!/bin/bash

# Ejercicio 4: Compresión tar.bz2

# --- 1. Solicitar al usuario el directorio y nombre de archivo ---
read -rp "Ingrese el path absoluto al directorio: " dir
read -rp "Ingrese el nombre para el archivo comprimido (sin extensión): " nombre

# --- 2. Validar que el directorio exista ---
if [ ! -d "$dir" ]; then
    echo "Error: El directorio no existe."
    exit 1
fi

# --- 3. Calcular el tamaño del directorio sin comprimir ---
# du -sb da el tamaño total en bytes (-s = summary, -b = bytes)
tam_dir=$(du -sb "$dir" | cut -f1)

# --- 4. Crear el archivo comprimido en formato tar.bz2 ---
archivo="${nombre}.tar.bz2"
tar -cjf "$archivo" -C "$(dirname "$dir")" "$(basename "$dir")"

# --- 5. Calcular el tamaño del archivo comprimido ---
tam_comp=$(stat -c%s "$archivo")

# --- 6. Mostrar resultados en KB/MB legibles ---
echo "--------------------------------------"
echo "Tamaño del directorio original: $(numfmt --to=iec-i --suffix=B $tam_dir)"
echo "Tamaño del archivo comprimido:  $(numfmt --to=iec-i --suffix=B $tam_comp)"
echo "Archivo generado: $archivo"
echo "--------------------------------------"
