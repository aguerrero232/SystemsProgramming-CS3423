#include "assign8.h"

int main(int argc, char *argv[]) {
    int fdM[2], i, iExitStatus = 0, commandcount = 0;
    long lWaitPid, lForkPid; 
    char cmd[2][9999], cur[9999];
    Command c, commands[2];
    memset(&cur[0], 0, sizeof(cur));
    memset(&cmd[0], 0, sizeof(cmd));
    // -------------------------------------- seperating the commands -----------------------------------------------------
    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], ",") != 0){
            strcat(cur, strtok(argv[i], " "));
            strcat(cur, " ");
        }
        if (strcmp(argv[i], ",") == 0 || i + 1 == argc) {
            strcat(cmd[commandcount++], cur);
            memset(&cur[0], 0, sizeof(cur));
        }
    }
    // ---------------- get commands args seperated into command struct each with argv[], and argc. -----------------------
    for (i = 0; i < 2; i++)
        commands[i] = parsecommand(cmd[i], c);
    // ---------------- make some children to pipe a command into another -------------------------------------------------
    // create the pipe
    if (pipe(fdM) == -1){
        printf("pipe not created: %s", strerror(errno));
        exit(1);
    }
    // Both the parent and child continue here
    switch(lForkPid = fork()){
        case -1:
            printf("fork failed: %s", strerror(errno));
            exit(1);
        case 0:  // child process - the writer
            close(fdM[0]); 
           // do stuff here 
            if (dup2(fdM[1], STDOUT_FILENO) == -1) {
                printf("Failed to rediect stdout for %s: %s\n", commands[0].cmd, strerror(errno));
                exit(1);
            }
            execvp(commands[0].argv[0], commands[0].argv);
            printf("Failed to exec %s: %s", commands[0].rawCmd, strerror(errno));
            close(fdM[1]);
            break;
    
        default: // parent process - the reader
            close(fdM[1]);
            // do stuff here
            if (dup2(fdM[0], STDIN_FILENO) == -1) {
                printf("Failed to rediect stdin for %s: %s\n", commands[1].cmd, strerror(errno));
                exit(1);
            } 
            execvp(commands[1].argv[0], commands[1].argv); //
            printf("Failed to exec %s: %s", commands[1].rawCmd,strerror(errno));       
            close(fdM[0]);
            lWaitPid = wait(&iExitStatus);
    }
    return 0;
}