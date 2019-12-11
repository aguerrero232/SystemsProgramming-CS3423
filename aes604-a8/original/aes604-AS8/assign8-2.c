#include "assign8.h"

int main(int argc, char *argv[]) {
    int fdM[2], iReadFd, iWriteFd, i, iExitStatus = 0, commandcount = 0;
    long lWaitPid, lForkPid1, lForkPid2; 
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
    if (pipe(fdM) == -1) { // create the pipe
        printf("pipe not created: %s", strerror(errno));
        exit(1);
    }
    lForkPid1 = fork(); // create a child process
    // Both the parent and first child continue here
    switch (lForkPid1) {
        case -1: // fail
            printf("fork failed: %s", strerror(errno));
            exit(1);
        case 0: // child process 1
            if (dup2(fdM[1], STDOUT_FILENO) == -1) {
                printf("Failed to rediect stdout for %s: %s", commands[0].cmd, strerror(errno));
                exit(1);
            }
            close(fdM[0]); // ask why are closing both here  
            close(fdM[1]);
            execvp(commands[0].argv[0], commands[0].argv);
            printf("Failed to exec %s: %s", commands[0].rawCmd, strerror(errno));
        default:                // parent process
            lForkPid2 = fork(); // create child process 2
            // Both the parent and second child continue here
            switch (lForkPid2) {
                case -1:
                    printf("fork of second child failed: %s", strerror(errno));
                    exit(1);
                case 0: // child process 2
                    if (dup2(fdM[0], STDIN_FILENO) == -1) {
                        printf("Failed to rediect stdin for %s: %s", commands[1].cmd, strerror(errno));
                        exit(1);
                    }
                    close(fdM[0]);
                    close(fdM[1]);
                    execvp(commands[1].argv[0], commands[1].argv); //
                    printf("Failed to exec %s: %s", commands[1].rawCmd,strerror(errno));
                default: // parent process
                    close(fdM[0]);
                    close(fdM[1]);
                    for (i = 0; i < 2; i += 1) { // waiting on the children to terminate
                        iExitStatus = 0;
                        lWaitPid = wait(&iExitStatus);
                        if (lWaitPid == -1) {
                            printf("wait failed: %s\n", strerror(errno));
                            exit(1);
                        }
                    }
            }   
        }
    return 0;
}