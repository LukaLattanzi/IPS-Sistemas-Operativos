#!/bin/bash

# Ejercicio 2: Día de cumpleaños

# --- 1. Solicitar fecha al usuario ---
if [ $# -ge 1 ]; then
    entrada="$1"
else
    read -rp "Ingresá tu fecha de nacimiento (dd-mm-aaaa): " entrada
fi

# --- 2. Validar formato dd-mm-aaaa ---
if [[ ! "$entrada" =~ ^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-([0-9]{4})$ ]]; then
    echo "Formato inválido. Usá dd-mm-aaaa (con ceros). Ej: 05-09-2001"
    exit 1
fi

# --- 3. Extraer componentes de la fecha ---
dia="${BASH_REMATCH[1]}"
mes="${BASH_REMATCH[2]}"
anio="${BASH_REMATCH[3]}"

# --- 4. Convertir a formato ISO para validación ---
iso="${anio}-${mes}-${dia}"

# --- 5. Validar que la fecha existe en el calendario ---
if ! dia_semana=$(LC_TIME=es_AR.UTF-8 date -d "$iso" +%A 2>/dev/null); then
    if ! dia_semana=$(date -d "$iso" +%A 2>/dev/null); then
        echo "Fecha inválida: $entrada"
        exit 1
    fi
fi

# --- 6. Mostrar el día de la semana ---
echo "Naciste un: $dia_semana"