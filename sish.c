/*********************************************************
CS/SE 3377 Sys. Prog. In Unix and Other Env.
Project 1
Due: March 25th, 2022

Authors/Partners:

Trent Hardy (TTH190003) - SECTION: 3377.005
Steve Alvarado (SXA163330) - SECTION:  3377.003
**********************************************************/
#define  _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <inttypes.h>

// Variable Declarations
pid_t pid;
static char* cmdArguments[100];
static char  history[100][100];
int command_pipe[2];
int historyRecords = 0;
char* command;
size_t size = 100;
static int pipingCalls = 0;


// Prototype Declarations
static int executeCmd(char* cmd, int inputValue, int isFirstCmd, int isLastCmd);
static int piping(int inputValue, int isFirstCmd, int isLastCmd);
static void updateHistoryRecord(char *cmd);
static char* filterInput(char* input);


// Driver Function
int main()
{
    // Loop the program to continuously prompt console input
    while (1) {

        // Display a prompt awaiting input
        printf("sish> ");

        // Read line from console
        if (!getline(&command, &size, stdin)) // Check if input is valid
        {
          return 0;
        }
            
  
        // Initialize variables
        int inputValue = 0;
        int isFirstCmd = 1; // == TRUE (determines whether the specificed command is the first command)

        // Compare command string to determine if it is "cd"
        if (strcmp(command, "cd") == 0)
        {
          continue;
        }

        // For easier-to-understand code, substring/subchars are used in place of tokens approach...
          
        // Initialize "hist" to the first occurence of substring "history" in a given command
        char* hist = strstr(command, "history");

        if (hist != NULL ) // If the command contains history...
        {
          
          // Initialize a temporary char array
          char temporaryValue[100] = "";
          // copy the given command into the char array
          strcpy(temporaryValue, command);
          // Initialize *hasParam to the first occurence of the ' ' character in the temporaryValue character string. (This effectively tokenizes in a simpler way)
          char *hasParam = strchr(temporaryValue,' ');
          
          // Use the filterInput() helper function to remove whitespace and clean the character array.
          char *pointer = filterInput(temporaryValue);
          // Set the last position of the temporaryValue character array to a null terminator
          temporaryValue[strlen(temporaryValue)-1] = '\0';
          
          // Compare pointer to determine if it the "history" string. If so...
          if (strcmp(pointer, "history") == 0)
          {
            // initialize a temporary iterator value
            int iterVal = 0;
            // use the iterator to loop through all history records.
            for ( iterVal = historyRecords - 1 ; iterVal >= 0 ; iterVal--)
              {
                // For every record in the history, print the record.
                printf("%d %s", iterVal, history[iterVal]);
              }
            // Call the updateHistoryRecord() helper function to add a new record to the history now that this command is executed.
            updateHistoryRecord(command);
            continue;
          }
          else if (strcmp(pointer, "history -c") == 0)           // If the pointer is NOT "history, but instead "history -c", then...
          {
            // clear the history

            // set the number of history records to ZERO
            historyRecords = 0;
            // Use memset to reallocate and set the memory of the pointer to 0.
            memset(history, 0, sizeof(history));

            // After history is cleared, add this command's record to the newly cleared history records.
            updateHistoryRecord(command);
            continue;
          }
          
          if (hasParam != NULL) // If the command has additional parameters, (effectively tokens)
          {
            // Initialize param character array
            char param[100] = "";
            // copy the contents of hasParam + 1 to param
            strcpy(param, hasParam + 1);
            // Add this record to the history and update it.
            updateHistoryRecord(command);
            
            // Initialize temporary variables
            int i;
            int isDigitflag;
           
            // Loop through para charcter array.
            for (i  = 0 ; i < strlen(param); i++)
              // 
              if (isdigit(param[i]) == 0 ) // 0 = FALSE. (parameter at i is not a digit and thus the cmd isn't executed.)
              // This is checking for cmds like "history 0" where records at a specific index are found and re-executed.
              {
                isDigitflag = 1; // track with flag
                break;
              }
              
            if (isDigitflag != 1) // So long as the flag tracker isn't 0. (Thus is a digit...) then...
            {
              // parse param for an integer index
              int index = atoi(param);
              // Ensure index isn't invalid/ out of bounds
              if (index > (historyRecords-1) || index < 0)
              {
                printf("Offset is not valid...\n");
                continue;
              }
              // copy the history record at the index into the command value
              strcpy(command, history[index]);
            }
          }
        }
        
        if (strcmp(command,"\n") != 0 ) // As long as the comparison of the command and "\n" isn't true... (AKA command != "\n")
        {
          // add new record to history
          updateHistoryRecord(command);
        }
        

        // Initialize pointers
        char* cmd = command;
        // Initialize next pointer to the occurence of the "|" in the cmd. (AKA the piping symbol)
        char* next = strchr(cmd, '|');


        // As long as there is piping...
        while (next != NULL)
        {
            // Set next pointer to a null terminator
            *next = '\0';
            // reset the inputValue by executing the command.
            inputValue = executeCmd(cmd, inputValue, isFirstCmd, 0); // The fourth parameter (0) indicates that this ISNT the last cmd.

            // Set cmd to the pointer after next
            cmd = next + 1;
            // set cmd to the next occurence of "|" in the cmd. (AKA the next pipe)
            next = strchr(cmd, '|');
            // Adjust the isFirstCmd value to 0 to verify that the consecutive command entries are no longer the first cmd. (0 == FALSE)
            isFirstCmd = 0;
        }

        // reset the inputValue by executing the command
        inputValue = executeCmd(cmd, inputValue, isFirstCmd, 1); // The fourth parameter (1) indicates that this IS the last cmd.


        // Clear the pipes like a good plumber:

        int j; // initialze temporary iterator value
        // Loop through every piping call
        for (j = 0; j < pipingCalls; ++j)
          {
            // Use wait to block calling process until child process is finsihed
            wait(NULL);
          }
        // Once every piping call is processed, reset pipingCalls to 0
        pipingCalls = 0;
    }
    return 0;
}

static int executeCmd(char* cmd, int inputValue, int isFirstCmd, int isLastCmd)
{
    // Use helper function to filter the cmd and remove white space
    cmd = filterInput(cmd);
    // set the next char pointer to the first character occurence of ' ' in the cmd
    char* next = strchr(cmd, ' ');
    // Initialize a temporary value to 0.
    int tmpVal = 0;

    while(next != NULL) // As long as there is a next...
     {
        next[0] = '\0'; // set the first position of next to a null terminator
        //set the arguments at the index position of tmpVal to the cmd.
        cmdArguments[tmpVal] = cmd;
        // Increment the tempVal position (index)
        ++tmpVal;
        // Use helper function to filter cmd and remove white space of the pointer position after next
        cmd = filterInput(next + 1);
        // reset the next char pointer to the first character occurence of ' ' in the cmd
        next = strchr(cmd, ' ');
    }

    if (cmd[0] != '\0') // If the first position of 0 isn't a null terminator...
    {
        // set the argument at tempVal position (index) to cmd
        cmdArguments[tmpVal] = cmd;
        // set the next char pointer to the first character occurence of '\n' in the cmd
        next = strchr(cmd, '\n');
        // set the first character position of next to a null terminator
        next[0] = '\0';
        // Increment the positon (index AKA tmpVal)
        ++tmpVal;
    }
    // Set the arguments at the tmpVal position to NULL
    cmdArguments[tmpVal] = NULL;


    if (cmdArguments[0] != NULL) // As long as the first command argument isn't NULL...
    {
        // If the first command argument is exit...
        if (strcmp(cmdArguments[0], "exit") == 0)
        {
          // exit the shell/program
          exit(0);
        }
        
        // If the first command argument is cd...
        if (strcmp(cmdArguments[0], "cd") == 0)
        {
          // If the second command argument is NULL. aka no specified directory...
          if (cmdArguments[1] == NULL)
          {
            // Handle error
            printf("Invalid directory...\n");
          }
          return 0;
        }
      
        // Increment piping calls since new cmd is being added to pipeline
        pipingCalls += 1;
        // call the piping function to handle the command and return the result.
        return piping(inputValue, isFirstCmd, isLastCmd);
    }
    else { // The command is empty/unrecognized/invalid.
      // Handle Error
      printf("Please enter a valid command...\n");
    }
 
    return 0;
}

static int piping(int inputValue, int isFirstCmd, int isLastCmd)
{

    // Initialize piping
    int pipes[2];
    pipe(pipes);

    // set pid to a new fork child process
    pid = fork();

    if (pid == 0) // If its the first child proces...
    {
      // Check to ensure that it's the first command, not the last command, and it's input value is 0.

      // READING = 0
      // WRITING = 1

        if (isFirstCmd == 1 && isLastCmd == 0 && inputValue == 0)
        {
            // Duplicate file descriptor
            // pipes[1] == WRITE
            dup2(pipes[1], STDOUT_FILENO);

        }
        // Check to ensure that it's NOT the first command, NOT the last command, and it's input value is NOT 0. (AKA a middle process)
         else if (isFirstCmd == 0 && isLastCmd == 0 && inputValue != 0)
        {
            // Duplicate file descriptor
            // inputValue = READ
            dup2(inputValue, STDIN_FILENO);

            // Duplicate file descriptor
            // pipes[1] == WRITE
            dup2(pipes[1], STDOUT_FILENO);
        } else
        {
          // Duplicate file descriptor
          // inputValue = READ
            dup2(inputValue, STDIN_FILENO);
        }
        // Error handling for failed child
        if (execvp(cmdArguments[0], cmdArguments) == -1) // If its not a valid command...
        {
          printf("Command not found...\n");
          exit(EXIT_FAILURE);
        }
    }

    if (inputValue != 0) // If the inputValue isn't 0. (Not reading)
    {
      // Close the pipe
      close(inputValue);
    }   

    // Close the WRITE pipe
    close(pipes[1]);

    if (isLastCmd == 1) // If the cmd IS the last command...
    {
      // close the READ pipe
      close(pipes[0]);
    }

    // return the READ pipeline...
    return pipes[0];
}

static char* filterInput(char* input)
{
  // Loop through character pointer and remove whitespace
    while (isspace(*input)) ++input;
    return input;
}

static void updateHistoryRecord(char *cmd)
{

  if (historyRecords == 100) // Check if history is at max capacity
  {
    // Initialize temporary iterator
    int i = 0;
    // Loop through all records in history
    for ( i = 0 ; i < 99 ; i++)
    {
      // copy the contents of the next record in the history into the previous record. (Avoids overflow)
      strcpy(history[i], history[i+1]);
    }    
  }
  else // history ISNT at max capacity
  {
    // copy the command and add it as a record to the history at the next open slot.
    strcpy(history[historyRecords], cmd);
    // Increment the number of records to update the list
    historyRecords++;
  }
}













