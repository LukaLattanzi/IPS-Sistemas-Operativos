#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sys/types.h>

int main() {

    int ret = fork();

    if(ret) {
        // PROCESO PADRE
        printf("PADRE - PID: %d, PID del hijo: %d\n", getpid(), ret);
        wait(NULL);
        printf("Chau \n");
    } else {
        // PROCESO HIJO
        printf("HIJO - PID: %d, PID del padre: %d\n", getpid(), getppid());
        printf("Hola \n");
    }

    return EXIT_SUCCESS;
}