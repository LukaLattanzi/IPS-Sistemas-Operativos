#!/bin/bash

# Ejercicio 1: Comando tac

# --- 1. Validar argumentos ---
if [ $# -ne 1 ]; then
    echo "Uso: $0 archivo.txt"
    exit 1
fi

# --- 2. Verificar que el archivo exista ---
archivo="$1"
if [ ! -f "$archivo" ]; then
    echo "Error: el archivo '$archivo' no existe."
    exit 1
fi

# --- 3. Contar líneas del archivo ---
lineas=$(wc -l < "$archivo")

# --- 4. Imprimir archivo invertido ---
# Bucle que va desde la última línea hasta la primera
for i in $(seq "$lineas" -1 1); do
    # head -n $i obtiene las primeras $i líneas
    # tail -n 1 se queda con la última de esas líneas
    head -n "$i" "$archivo" | tail -n 1
done
