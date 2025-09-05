#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>

int main() {
    int p = fork();
    if (p != 0) for(;;);
    if (p == 0)  execl("/bin/ls", "ls", "-l", NULL);
    printf("Mi pid es %d", getpid());
    return 0;
}