#include <stdio.h>     // Para printf()
#include <unistd.h>    // Para fork() y getpid()
#include <sys/types.h> // Para pid_t (opcional pero recomendado)

/*
 * ANÁLISIS DEL PROGRAMA: CREACIÓN EXPONENCIAL DE PROCESOS
 *
 * Este programa demuestra la creación exponencial de procesos usando fork() en un bucle.
 * IMPORTANTE: No usa wait(), por lo que TODOS los procesos hijo se convertirán en ZOMBIES
 * cuando terminen antes que sus padres.
 */

/*
 * FUNCIONAMIENTO DE LOS PROCESOS:
 *
 * El bucle for(i=0; i<3; i++) se ejecuta en TODOS los procesos (padre e hijos).
 * Cada proceso que ejecuta fork() se duplica: uno continúa como padre, otro como hijo.
 *
 * CRECIMIENTO EXPONENCIAL:
 * - Inicio: 1 proceso (padre original)
 * - Iteración 0: 1 proceso hace fork() → 2 procesos (1 padre + 1 hijo)
 * - Iteración 1: 2 procesos hacen fork() → 4 procesos (2 padres + 2 hijos)
 * - Iteración 2: 4 procesos hacen fork() → 8 procesos (4 padres + 4 hijos)
 *
 * TOTAL: 8 procesos al final
 */

/*
 * ÁRBOL DE PROCESOS (ejemplo con PIDs hipotéticos):
 *
 *                    Proceso Original (PID: 1000)
 *                           |
 *                    [i=0: fork()]
 *                     /           \
 *            Padre (1000)      Hijo (1001)
 *                 |                 |
 *          [i=1: fork()]      [i=1: fork()]
 *           /         \        /         \
 *      P(1000)    H(1002)  P(1001)   H(1003)
 *         |          |        |         |
 *   [i=2: fork()][i=2: fork()][i=2: fork()][i=2: fork()]
 *      /    \      /    \     /    \     /    \
 *  P(1000) H(1004) P(1002) H(1005) P(1001) H(1006) P(1003) H(1007)
 *
 * RESULTADO: 8 procesos ejecutándose simultáneamente
 */

/*
 * PROBLEMA DE PROCESOS ZOMBIE:
 *
 * ¡ATENCIÓN! Este programa CREA PROCESOS ZOMBIE porque:
 * 1. No hay llamadas a wait() o waitpid()
 * 2. Los procesos hijo terminan rápidamente (solo hacen printf y return)
 * 3. Los procesos padre no "cosechan" el estado de salida de sus hijos
 * 4. Los hijos quedan en estado ZOMBIE hasta que sus padres terminen
 *
 * ZOMBIES CREADOS: Potencialmente 7 zombies (todos los hijos)
 * DURACIÓN: Los zombies persisten hasta que el proceso padre original termine
 */

/*
 * SALIDA DEL PROGRAMA:
 *
 * El printf("%d - %d\n",j, k) muestra:
 * - j = PID del proceso que ejecuta la línea (antes del fork)
 * - k = Valor de retorno del fork():
 *   * En el padre: PID del hijo recién creado (número positivo)
 *   * En el hijo: 0
 *
 * Se imprimirán 8 líneas en total (una por cada proceso)
 */

int main()
{
    int i, j, k;

    /* Bucle que se ejecuta en TODOS los procesos creados */
    for (i = 0; i < 3; i++)
    {
        /* j guarda el PID del proceso ANTES de hacer fork() */
        j = getpid();

        /* fork() duplica el proceso actual */
        k = fork();

        /* Esta línea se ejecuta en ambos procesos (padre e hijo) */
        /* j = PID del proceso, k = 0 en hijo, PID_hijo en padre */
        printf("%d - %d\n", j, k);
    }

    /* PROBLEMA: No hay wait() - los hijos se convierten en zombies */
    return 0;
}