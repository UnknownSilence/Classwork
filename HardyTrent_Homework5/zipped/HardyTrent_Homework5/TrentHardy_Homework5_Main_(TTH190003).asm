##############################################################################
#									     #
#	Name: Trent Hardy						     #
#	Net ID: TTH190003						     #
#	Assignment: Homework 5 - Compression Program			     #
#	Date: 11/19/2021						     #
#	Class: CS/SE 2340.003						     #
#									     #
##############################################################################


# MAIN FILE
#=============================================================================

#Run-length encoding (RLE) is a very simple form of lossless data compression in
#which runs of data (that is, sequences in which the same data value occurs in many
#consecutive data elements) are stored as a single data value and count, rather than as the
#original run. This is most useful on data that contains many such runs.

#Psuedocode (https://iq.opengenus.org/run-length-encoding/):
#def RunLengthEncoding(s):
#    code=""
#    i=0
#    while i<len(s):
#        w=s[i]
#        count=0
#        while i<len(s) and s[i]==w:
#            i+=1
#            count+=1
#        code=code+w+str(count)
#    return code



# Include Macros file

.include "TrentHardy_Homework5_Macros_(TTH190003).asm"
	
	
# Establish data
	
	.data
	
fileName:			.space	20
space: 				.asciiz "\n"

inputBuffer:			.space	1024

errorOpenMsg:			.asciiz	"Error opening file. Program terminating."

promptFileNameMsg:		.asciiz	"Please enter a filename to compressData or <enter> to exit: "

printOrigDataMsg:		.asciiz	"Original data:"

printCompDataMsg:		.asciiz	"Compressed data:"

printUncompDataMsg:		.asciiz	"UncompressDataed data:"

printOrigFileSizeMsg:		.asciiz	"Original file size: "

printCompFileSizeMsg:		.asciiz	"Compressed file size: "


# Code

	.text
main:
	# Allocate 1024 bytes of dynamic memory
	allocateMemory 1024
	
	# Save pointer to the area
	move $s3, $v0
	
# Main Driving function loop

#The main program is a loop in which you ask the user for a filename. If they
#enter nothing for the filename, exit the program. Otherwise:
loop:	
	la	$t5, promptFileNameMsg	# Load the promptFileNameMsg into $t5
	
	printString $t5			# Use printString macro to display $t5
	getString fileName		# Use getString macro to get the file name from user input
	
	la	$t0, fileName		# Load adress of fileName at the index in $t0
	lbu	$t1, ($t0)		# Load value of the address into $t1
	
	beq	$t1, $0, exit		# Check if $t1 == $0. If so, goto exit (no value entered)
	
	jal	fixFileName		# Handle edge cases of string parsing (ensure file name is valid with no excess characters)
	la 	$a0, fileName		# Load fixed fileName
	
	#Open the file for reading. If the file does not exist, print an error
	#message and terminate the program. 

	openFile			# Use openFile macro to open the file of the given fileName

	blt	$v0, $0, fileError	# Check if $v0 < $0. (Check if file doesn't exit). If it doesnt, goto fileError function
	
	move	$s0, $v0		# Set $s0 to the contents of $v0. (file name)
	move	$a0, $s0		# Set $a0 to the contents of $s0. (file name)
	
	readFile			# use readFile macro to read the file with the given file name.
	
	move	$s1, $v0		# Set $s1 to $v0. (read file system call #14) [opened file]
	move	$a0, $s0		# Set $a0 to $s0. (read file system call #14) [opened file]
	
	#Close the file.
	
	closeFile			# use closeFile macro the close the opened file.
	
	la	$t5, printOrigDataMsg	# Load address of printOrigDataMsg into $t5
	
	la	$t9, space		# Load address of space (newline) into $t9
	printString $t9			# use printString macro to print a newline charater
	
	#Invoke the print string macro to output the original data to the
	#console.
	
	printString $t5			# use printString macro to print contents of $t5. (original data message)
	printChar 10			# use printChar macro to print character
	
	printString $s3			# use printString macro to print contents of $s3. (pointer of allocated dynamic memory area)
	printChar 10			# use printChar macro to print character
	
	la	$a0, ($s3)		# Load value of address $s3 into $a0.
	la	$a1, inputBuffer	# Load address of inputBuffer into $a1
	move	$a2, $s1		# Store $s1 to $a2
	
	#Call the compression function. Save the size of the compressed data in
	#memory.
	
	jal	compressData		# Goto compressDataion function to compressData data for RLE
	
	move	$s2, $v0		# Store $v0 to $s2. (compressed data)
	la	$t5, printCompDataMsg	# Load address of printCompDataMsg into $t5
	
	#Call a function to print the compressed data.
	
	printString $t5			# Use printString macro to print contents of $t5
	printChar 10			# Use printChar macro to print character
	
	la	$t5, inputBuffer	# Load address of inputBuffer into $t5
	
	printString $t5			# Use printString macro to print contents of $t5
	printChar 10			# Use printChar macro to print character
	
	#Call the uncompress function, which uncompresses to the console. 
	
	la	$t5, printUncompDataMsg	# Load address of printUncompDataMsg into $t5
	
	printString $t5			# Use printString macro to print contents of $t5
	printChar 10			# Use printChar macro to print character
	
	jal	uncompressData		# Call function to print uncompressed data
	
	printChar 10			# Use printChar macro to print character
	
	#Print the number of bytes in the original and compressed data
	
	la	$t5, printOrigFileSizeMsg	# Load address of printOrigFileSizeMsg into $t5
	
	printString $t5			# Use printString macro to print contents of $t5
	printInt $s1			# Use printInt macro to print $s1 (the original file size)
	printChar 10			# Use printChar macro to print character
	
	la	$t5, printCompFileSizeMsg	# Load address of printCompFileSizeMsg into $t5
	
	printString $t5			# Use printString macro to print contents of $t5
	printInt $s2			# Use printInt macro to print $s1 (the compressed file size)	
	printChar 10			# Use printChar macro to print character
	
	j	loop			# Repeat loop
	
	j	exit			# Failsafe


#The compression function implements the RLE algorithm above and stores
#the compressed data in the heap. Before the function call, set $a0 to the
#address of the input buffer, set $a1 to the address of the compression buffer,
#set $a2 to the size of the original file. The function should “return” the size of
#the compressed data in $v0. 	


compressData:
	move	$t0, $a0		# Input buffer address
	move	$t1, $a1		# Compressed data buffer address
	li	$t9, 0			# Load 0 to $t9
compress:	
	li	$t8, 0			# Load 0 to $t8
compressionLoop:
	addi	$t8, $t8, 1		# $t8 = $t8 + 1 (counter)
	addi	$t9, $t9, 1		# $t9 = $t9 + 1 (counter)
	
	lbu	$t2, ($t0)		# Load byte unsigned of $t0 into $t2
	lbu	$t3, 1($t0)		# Load byte unsigned of 1($t0) into $t3
	
	addi	$t0, $t0, 1		# $t0 = $t0 + 1
	
	beq	$t2, $t3, compressionLoop	# Check if $t2 == $t3. If it is, goto compressionLoop again. Otherwise...
	
	sb	$t2, ($t1)		# Store byte of $t1 into $t2
	
	addi	$t1, $t1, 1		# $t1 = $t1 + 1
	
	beq	$t2, 10, compress	# Check if $t2 == 10. If it is, goto compress loop again. Otherwise...
	
	# ASCII of 0 = 48
	
	addi	$t8, $t8, 48		# $t8 = $t8 + 48. (convert to ASCII)
	sb	$t8, ($t1)		# Store byte of ($t1) into $t8
	addi	$t1, $t1, 1		# $t1 = $t1 + 1
	
	bne	$t9, $a2, compress	# If $t9 != $a2, goto compress loop again. Otherwise...
	
	sub	$v0, $t1, $a1		# $v0 = $t1 - $a1 (return argument = $t1 - $a1)
	
	jr	$ra			# Jump and return to return address ($ra) with function result in $v0

	
	
#The uncompress function will repeat characters as indicated in the
#compressed file. For example, if the compressed file is ‘A2B3C1’ it will print

uncompressData:
	la	$t0, inputBuffer	# Load address of input buffer into $t0
	li	$t3, 0			# Load 0 into $t3
loop1:
	lbu	$t1, ($t0)		# Load byte unsigned of ($t0) into $t1
	addi	$t0, $t0, 1		# $t0 = $t0 + 1 (counter)
	
	lbu	$t2, ($t0)		# Load byte unsigned of $(t0) into $t2. (indexing)
	
	# ASCII of 0 = 48
	
	addi	$t2, $t2, -48		# Convert value from ASCII to numerical
	addi	$t3, $t3, 1		# $t3 = $t3 + 1
loop2:	
	printChar $t1			# Use printChar macro to print characters $t1
	
	beq	$t1, 10, loop1		# Check if $t1 == 10. If it is, jump and loop through loop1.
	addi	$t2, $t2, -1		# $t2 = $t2 - 1 (counter)
	
	bgt	$t2, 0, loop2		# Check if $t2 > loop 2. If it is,jump and loop through loop2.
	addi	$t0, $t0, 1		# $t0 = $t0 + 1 (counter)
	
	blt	$t3, $a2, loop1		# Check if $t3 < $a2. If it is, jump and loop through loop1.
	add	$v0, $0, $t9		# $v0 = $0 + $t9. (Return argument = $t9 + 0)
	
	jr	$ra			# Jump and return to function call with return address ($ra) and function result ($v0)
	

# Helper function to adjust file name to prevent parsing issues

fixFileName:
	la	$t0, fileName		# Load fileName to $t0
fixName:	
	lbu	$t1, ($t0)		# Loab the byte unsigned of $t0 into $t1
	addi	$t0, $t0, 1		# $t0 = $t0 + 1
	bne	$t1, 10, fixName	# Check if $t1 != 10. If it isn't goto fixName and loop.
	addi	$t0, $t0, -1		# $t0 = $t0 - 1
	sb	$0, ($t0)		# store byte of $t0 into $0
	jr	$ra			# Jump and return to function call with return address ($ra)
	
	
# Function for when an error occurs with opening file

fileError:
	la	$a0, errorOpenMsg
	li	$v0, 4
	syscall
	j	exit
	
# Helper function to exit program
	
exit:
	li $v0, 10
	syscall
