#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main()
{
    printf("PADRE INICIAL - PID: %d - Iniciando creación de 5 procesos hijo\n", getpid());

    pid_t pids[5];
    int i;

    // Crear 5 procesos hijo
    for (i = 4; i >= 0; --i)
    {
        printf("PADRE - Creando hijo %d...\n", i);
        pids[i] = fork();
        
        if (pids[i] == 0)
        {
            // Código del proceso hijo
            printf("HIJO %d - PID: %d, Padre PID: %d - Durmiendo por %d segundos\n", 
                   i, getpid(), getppid(), i + 1);
            sleep(i + 1);
            printf("HIJO %d - PID: %d - Terminando después de %d segundos\n", 
                   i, getpid(), i + 1);
            exit(0);
        }
        else
        {
            // Código del proceso padre
            printf("PADRE - Hijo %d creado con PID: %d\n", i, pids[i]);
        }
    }

    printf("PADRE - Todos los hijos creados. Esperando su finalización...\n");

    // Esperar a que terminen todos los hijos
    for (i = 4; i >= 0; --i)
    {
        printf("PADRE - Esperando al hijo %d (PID: %d)...\n", i, pids[i]);
        waitpid(pids[i], NULL, 0);
        printf("PADRE - Hijo %d (PID: %d) ha terminado\n", i, pids[i]);
    }

    printf("PADRE - Todos los hijos han terminado. Finalizando programa.\n");
    return 0;
}