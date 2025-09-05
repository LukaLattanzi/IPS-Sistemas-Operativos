#include <stdio.h>    // Para printf()
#include <unistd.h>   // Para fork() y getpid()
#include <sys/wait.h> // Para wait()
#include <stdlib.h>   // Para EXIT_SUCCESS (opcional)

int main()
{
    int p = fork();
    if (p == 0)
        for (;;)
            ;
    wait(NULL);
    printf("Mi pid es %d", getpid());
    return 0;
}