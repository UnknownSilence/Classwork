#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Trent Hardy
// CS 337.005
// Assignment 6


/*
 * This program counts the number of sentences in a given string and
 * the number of tokens each sentence.
 * Terminates when user enters BYE
 */

int
main(int argc, char *argv[])
{

	// define the required variables
	char * sentence;
	char * token;

	char *buff;


	size_t maxSize = 500;
	char * input;

	int sentenceNum;
	int tokenNum;

	input = (char*)malloc(maxSize);
	
	while (1) {

		sentenceNum = 0;
		tokenNum = 0;
		printf("Enter the string: ");

		// use getline() to get the input string
		getline(&input, &maxSize, stdin);
	

		// The input string consists of several sentences separated by '.'
		sentence = strtok_r(input, ".", &buff);
		token = strtok_r(input, " ", &buff);

		if(strcmp(token, "BYE\n") == 0) {
			break;
		}

		else {
			while(sentence != NULL) 
			{



				tokenNum++;
				sentence = strtok_r(NULL, ".", &buff);
				
				
				
				while(token != NULL) 
				{
					tokenNum++;
					token = strtok_r(NULL, " ", &buff);
					
				}
				sentenceNum++;
				printf("sentence %d: tokens", sentenceNum);
				printf(" %d\n", tokenNum);

			}

		}

		printf("Number of sentences: %d\n", sentenceNum);




		
		

		

		// Each sentence consists of several tokens separated by ' ' (space).
		// Using strtok_r() find the number of sentences and the number of tokens
		// in each sentence. HINT: man strtok and look at the sample program at the end.
		// Print the results.
		// If the first token is BYE, break from the while loop (check strcmp/strncmp)

	}
	free(input);
    exit(EXIT_SUCCESS);
}

