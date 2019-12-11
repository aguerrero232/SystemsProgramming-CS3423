#include "assign8.h"

int main(int argc, char *argv[]){
    long lForkPid, lWaitPid;
    int i, iCommandCount = 0, iExitStatus = 0;  
    char cmd[6][9999], cur[9999]; 
    Command commands[6], c; 
    memset(&cur[0], 0, sizeof(cur));
    memset(&cmd[0], 0, sizeof(cmd));
    // -------------------------------------- seperating commands -----------------------------------------------------
    for (i = 1; i < argc; i++){
        if (strcmp(argv[i], ",") != 0){
            strcat(cur, argv[i]);
            strcat(cur, " ");
        }
        if (strcmp(argv[i], ",") == 0 || i + 1 == argc){
            strcat(cmd[iCommandCount++], cur); 
            memset(&cur, 0, sizeof(cur));
        }
    }
    // ---------------- get commands args seperated into command struct each with a argv[], and argc of their own. --------
    for (i = 0; i < iCommandCount; i++)
        commands[i] = parsecommand(cmd[i], c);
    // ---------------- make some children .... you have the variable command count to tell you how many to make ----------
    for (i = 0; i < iCommandCount; i++){
        switch (lForkPid = fork()){
        case -1: // fail
            printf("fork failed: %s", strerror(errno));
            exit(1);
            break;
        case 0: // child process
            printf("PID: %ld, PPID: %ld, CMD: %s\n", (long)getpid(), (long)getppid(), commands[i].cmd);
            if (execvp(commands[i].argv[0], commands[i].argv) == -1){
                printf("Fork Failed: %s", strerror(errno));
                exit(1);
            }
        }
    }
    // ----------------------- this is where the parent waits for all the kids --------------------------------------------
    for (i = 0; i < iCommandCount; i++){
        if (lForkPid > 0){ // only the parent process will enter here cause the PID will be > 0
            iExitStatus = 0;
            lWaitPid = wait(&iExitStatus); // this is how you wait for children
            if (lWaitPid == -1)
                printf(" WAIT FAILED\n");
        }
    }
    return 0;
}