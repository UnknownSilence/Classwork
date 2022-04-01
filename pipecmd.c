#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>


void err_exit(char *msg);

int
main(int argc, char *argv[])
{
    int fd[2];
    pid_t cpid1, cpid2, cpid3;

    if (argc != 2) {
     fprintf(stderr, "Usage: %s <pathname>\n", argv[0]);
     exit(EXIT_FAILURE);
    }


    if (pipe(fd) == -1) 
        err_exit("pipe");

	cpid1 = fork();
	if (cpid1 < 0){
		err_exit("fork cpid1 failed");		
	}
	if (cpid1 == 0){ // child 1
		close(fd[0]); // not reading from pipe
		if (dup2(fd[1], STDOUT_FILENO) == -1){
			err_exit("dup2 failed in Child 1");
		}
		close(fd[1]); // write end is no longer required because dup2
		char* myargs[] = {"cat", argv[1], NULL}; 
		execvp(myargs[0], myargs);
		err_exit("execvp failed in Child 1");
	}
	// only parent gets here
    cpid2 = fork();
    if (cpid2 < 0){
        err_exit("fork cpid1 failed");
    }
	if (cpid2 == 0){
		close(fd[1]); // wc doesnt write to pipe
		if(dup2(fd[0], STDIN_FILENO) == -1){
        	err_exit("dup2 in child 2 failed");
		}
		close(fd[0]); // no longer required because dup2
		char* myargs[] = {"wc", NULL}; 
		execvp(myargs[0], myargs);
		err_exit("execvp failed in Child 1");
	}

    
cpid3 = fork();
if (cpid3 == -1)
err_exit("fork3");

if (cpid3 == 0) { /* child 3 */
close(pipefd[1]); /* close write end */
if (dup2(pipefd[0], STDIN_FILENO) != STDIN_FILENO)
err_exit("dup2 error to stdin");
close(pipefd[0]); /* don't need this after dup2 */

/* call exec with appropriate arguments*/
char *myargs[] = {"wc", 0};
execvp(myargs[0], myargs);
err_exit("execvp failed");
}




	close(fd[0]);
	close(fd[1]); // parent no longer needs
	waitpid(cpid1, NULL, 0); // wait for child 1 to terminate
	waitpid(cpid2, NULL, 0); // wait for child 2 to terminate
}

void err_exit(char *msg)
{
	perror(msg);
	exit(EXIT_FAILURE);
}

