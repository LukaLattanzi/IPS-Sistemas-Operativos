#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <time.h>
#include <signal.h>

// Variable global para controlar la recepción de señales
int signal_received = 0;

// Handler para la señal SIGUSR1
void signal_handler(int sig)
{
    if (sig == SIGUSR1)
    {
        signal_received = 1;
        printf("Recibida la señal SIGUSR1\n");
    }
}

int main(int argc, char *argv[])
{
    pid_t pid1, pid2;
    int mes, año;

    // Verificar argumentos
    if (argc != 3)
    {
        printf("Uso: %s <mes> <año>\n", argv[0]);
        exit(1);
    }

    mes = atoi(argv[1]);
    año = atoi(argv[2]);

    printf("$ ./ejercicio4 %d %d\n", mes, año);

    // Crear el primer proceso hijo
    pid1 = fork();

    if (pid1 == 0)
    {
        // PRIMER HIJO: Ejecuta comando cal
        char mes_str[10], año_str[10];
        sprintf(mes_str, "%d", mes);
        sprintf(año_str, "%d", año);

        // Usar execl para ejecutar el comando cal
        execl("/usr/bin/cal", "cal", mes_str, año_str, (char *)NULL);

        // Si execl falla, intentar con la ruta alternativa
        execl("/bin/cal", "cal", mes_str, año_str, (char *)NULL);

        // Si ambos fallan, usar system como último recurso
        char comando[50];
        sprintf(comando, "cal %d %d", mes, año);
        system(comando);

        // El proceso hijo termina aquí
        exit(0);
    }
    else if (pid1 > 0)
    {
        // PROCESO PADRE
        printf("Proceso padre esperando por hijo %d\n", pid1);

        // Crear el segundo proceso hijo
        pid2 = fork();

        if (pid2 == 0)
        {
            // SEGUNDO HIJO: Espera señal SIGUSR1
            printf("Proceso padre esperando por hijo %d\n", getpid());
            printf("(enviar señal desde otra terminal mediante comando kill)\n");

            // Configurar el handler para SIGUSR1
            signal(SIGUSR1, signal_handler);

            // Esperar hasta recibir la señal
            while (!signal_received)
            {
                sleep(1); // Evitar consumo excesivo de CPU
            }

            printf("Hijo %d terminado\n", getpid());
            exit(0);
        }
        else if (pid2 > 0)
        {
            // PROCESO PADRE - Esperar ambos hijos

            int status;
            pid_t finished_child;

            // Esperar que terminen ambos procesos hijo
            for (int i = 0; i < 2; i++)
            {
                finished_child = wait(&status);
                printf("Proceso padre %d terminando...\n", getpid());
            }
        }
        else
        {
            perror("Error al crear segundo hijo");
            exit(1);
        }
    }
    else
    {
        perror("Error al crear primer hijo");
        exit(1);
    }

    return 0;
}