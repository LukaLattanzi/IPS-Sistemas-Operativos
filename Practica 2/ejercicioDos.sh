# Ejercicio 2: Día de cumpleaños
# El usuario debera ingresar en formato dd-mm-aaaa la fecha en que nació, el script deberá
# retornar el día de la semana de dicha fecha.
# La fecha introducida debe ser valida, el script verificará esto, pero no se debe realizar una
# programación mediante if’s validando días entre 1 y 31, si corresponde el número de días a
# tal mes, control de bisiestos, etc de forma programática, sino aprovechando comandos que
# pueden validar esto por nosotros. En caso de fecha inválida el script aborta comentando
# dicha situación.

set -u  # error si usamos variables no definidas (seguro para scripts sencillos)

# --- Entrada: si se pasa como argumento, lo usamos; si no, pedimos por teclado ---
if [ $# -ge 1 ]; then
  entrada="$1"                          # ejemplo: 23-01-2004
else
  read -rp "Ingresá tu fecha de nacimiento (dd-mm-aaaa): " entrada
fi

# --- Chequeo de FORMATO: dd-mm-aaaa con ceros a la izquierda obligatorios ---
# ^            : inicio de cadena
# (0[1-9]|[12][0-9]|3[01]) : día 01..09,10..29,30..31
# -            : guion literal
# (0[1-9]|1[0-2])          : mes 01..12
# -            : guion literal
# ([0-9]{4})               : año de 4 dígitos (0000..9999)
# $            : fin de cadena
if [[ ! "$entrada" =~ ^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-([0-9]{4})$ ]]; then
  echo "Formato inválido. Usá dd-mm-aaaa (con ceros). Ej: 05-09-2001"
  exit 1
fi

# --- Extraemos dd, mm, aaaa desde los grupos capturados del regex ---
dia="${BASH_REMATCH[1]}"
mes="${BASH_REMATCH[2]}"
anio="${BASH_REMATCH[3]}"

# --- Armamos en formato ISO (aaaa-mm-dd) que 'date' entiende perfecto ---
iso="${anio}-${mes}-${dia}"

# --- Validación CALENDARIO con 'date': si la fecha no existe, 'date' falla ---
# Intentamos primero con locale en español de Argentina.
# 2>/dev/null oculta mensajes de error (por ejemplo, si es fecha inválida).
if ! dia_semana=$(LC_TIME=es_AR.UTF-8 date -d "$iso" +%A 2>/dev/null); then
  # Si falló, probamos sin forzar locale (puede quedar en inglés u otro idioma).
  if ! dia_semana=$(date -d "$iso" +%A 2>/dev/null); then
    echo "Fecha inválida: $entrada"
    exit 1
  fi
fi

# --- Salida: imprimimos el día de la semana ---
# Ejemplos: lunes / Tuesday (según el locale disponible)
echo "Naciste un: $dia_semana"
