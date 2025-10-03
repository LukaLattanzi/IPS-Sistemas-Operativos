#!/bin/bash

# Ejercicio 3: Días de vida

# --- 1. Solicitar fecha de nacimiento al usuario ---
if [ $# -ge 1 ]; then
    entrada=$1
else
    read -rp "Ingresa tu fecha de nacimiento (dd-mm-aaaa): " entrada
fi

# --- 2. Validar formato dd-mm-aaaa ---
if [[ ! $entrada =~ ^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-([0-9]{4})$ ]]; then
    echo "Formato inválido. Usa dd-mm-aaaa (con ceros). Ej: 05-10-2003"
    exit 1
fi

# --- 3. Extraer componentes de la fecha ---
dia="${BASH_REMATCH[1]}"
mes="${BASH_REMATCH[2]}"
anio="${BASH_REMATCH[3]}"

# --- 4. Convertir a formato ISO para validación ---
iso="${anio}-${mes}-${dia}"

# --- 5. Validar que la fecha exista en el calendario ---
if ! date -d "$iso" &>/dev/null; then
    echo "Error: la fecha $entrada no existe en el calendario"
    exit 1
fi

# --- 6. Verificar que la fecha no sea futura ---
fecha_timestamp=$(date -d "$iso" +%s)
fecha_actual=$(date +%s)

if [ $fecha_timestamp -gt $fecha_actual ]; then
    echo "Error: La fecha de nacimiento no puede ser futura"
    exit 1
fi

# --- 7. Calcular días transcurridos ---
dias=$(( (fecha_actual - fecha_timestamp) / 86400 ))

# --- 8. Mostrar resultado ---
echo "--------------------------------------"
echo "Fecha de nacimiento: $entrada"
echo "Días transcurridos: $dias días"
echo "--------------------------------------"
