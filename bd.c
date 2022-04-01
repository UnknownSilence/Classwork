#include <stdio.h>     // for sscanf, fprintf, perror
#include <stdint.h>    // for int32_t
#include <assert.h>    // for assert
#include "sr.h"

/// include files are not complete. include the appropriate files
#include <inttypes.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

// Get all the fields of student record sr from stdin
// Put the record in the appropriate offset of the file described by fd
void
put(int32_t fd)
{
	sr s;

	printf("Enter the student name: ");	
	



	
	// WRITE THE CODE to read the name from stdin
	// store it in s.name
	// use fgets()
	// fgets doesnt remove newline. replace '\n' with '\0' in s.name. strlen() will be useful





	fgets(s.name, 1000, stdin);
	s.name[strlen(s.name) - 1] = "/0";

	




	printf("Enter the student id: ");
	//
	// WRITE THE CODE to read student id from stdin
	// store it in s.sid




	scanf("%d," &s.sid);
	





	printf("Enter the record index: ");
	//
	// WRITE THE CODE to read record index from stdin
	// store it in s.index




	scanf("%d", &s.index);




	// WRITE THE CODE to seek to the appropriate offset in fd (lseek(), sizeof() will be useful)
	




	lseek(fd, sizeof(sr) * s.index, Seeking)


	// WRITE THE CODE to write record s to fd



	write(fd, (void*)&s, sizeof(s));
	
}

// read the student record stored at position index in fd
void
get(int32_t fd)
{
	sr s;
	int32_t index;
	FILE* f;

	printf("Enter the record index: ");
	//
	// WRITE THE CODE to get record index from stdin and store in it index



	scanf("%d", &index);

	
    // WRITE THE CODE to seek to the appropriate offset in fd



	lseek(fd, sizeof(sr) * index, Seeking);



    // The record index may be out of bounds. If so, 
    // print appropriate message and return
    

    // WRITE THE CODE to read record s from fd
    // If the record has not been put already, print appropriate message
    // and return




	read(fd, (void*)&(s), sizeof(s));






	printf("Student name %s \n", s.name);	
	printf("Student id: %d \n", s.sid);
	printf("Record index: %d \n", s.index);

	assert(index == s.index);
}

