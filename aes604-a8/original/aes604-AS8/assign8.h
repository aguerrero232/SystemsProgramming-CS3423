#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/wait.h>
#include <stdlib.h>

typedef struct{
    char rawCmd[9999];
    char *cmd;
    char *argv[9999];
} Command;

Command parsecommand(char *rawCommand, Command c){ 
    int i = 0;
    memset(c.rawCmd, 0, sizeof(c.rawCmd));
    strcat(c.rawCmd, rawCommand); // setting the whole thing to the structs rawCmd field just in case i need the whole thing
    char *ptr = strtok(rawCommand, " ");
    c.cmd = ptr; // gets the base cmd
    while (ptr != NULL)
    { // every element after the first will be an arg (if there are any!) but we need argv[0] to be the base command for execvp
        c.argv[i++] = ptr;
        ptr = strtok(NULL, " ");
    }
    c.argv[i++] = NULL;
    return c;
}