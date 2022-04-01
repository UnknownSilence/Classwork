##############################################################################
#									     #
#	Name: Trent Hardy						     #
#	Net ID: TTH190003						     #
#	Assignment: Homework 2 - MIPS Control Structures		     #
#	Date: 9/19/2021							     #
#	Class: CS/SE 2340.003						     #
#									     #
##############################################################################



		.data
charCount:	.word 0
wordCount:	.word 0
		
maxWords:	.word 100

inputStr: 	.space 100

inputPrompt:	.asciiz "Enter some text: "	# Prompt message to display

msg1:		.asciiz " words "		# String to format output
msg2:		.asciiz " characters \n"	# String to format output with endline.
exitMsg:	.asciiz "Goodbye."		# String to format output
endMsg:		.asciiz "Message: "		# String to format output
	
		.text

loop1:
	# Display System Dialog Box and prompt the user to input a string(s)
		la $a0, inputPrompt		# load address of asciiz inputPrompt into a0 register
		la $a1, inputStr		# load adress of space inputStr into a1 register
		lw $a2, maxWords		# load the word maxWords into a2 register
		li $v0, 54			# call dialog syscall (#54)
		syscall
	
	# Branching to check state of the Dialog Box. (Option chosen)
		beq $a1, -2, done1		# User clicked Cancel.
		beq $a1, -3, done1		# User provided a blank input or clicked "OK"
		
	# Function call passing parameters inputStr and maxWords
		la $a0, inputStr		# load adress of inputStr into a0 register
		lw $a1, maxWords		# Load word maxWords to retrieve data
		jal counting			# jump and link to counting flag to imitiate a function.
		
	# Take the counting values and store them in memory to preserve data.
		sw $v0, charCount
		sw $v1, wordCount

	# Display the string given by the user.
		la $a0, inputStr		# Display string
		li $v0, 4			# call print string syscall (#4)
		syscall

	# Display the word count of the given string.
		lw $a0, wordCount		# Load word wordCount into a0 register to retrieve data to display.
		li $v0, 1			# call print integer syscall (#1)
		syscall
		
		la $a0, msg1			# Load address of msg1 into a0 register to display.
		li $v0, 4			# call print string syscall (#4)
		syscall

	# Display the character count of the given string. (Spaces are counted as characters)
		lw $a0, charCount		# Load word charCount into a0 register to retrieve data to display.
		li $v0, 1			# call print integer syscall (#1)
		syscall

		la $a0, msg2			# Load address of msg2 into a0 register to retrieve data to display.
		li $v0, 4			# call print string syscall (#4)
		syscall
	
		b loop1				# Unconditional branch to loop1 (jump)
done1:
	# Display the "Goodbye" message when you finish.
		la $a0, endMsg			# Load address of endMsg into a0 to retrieve data to display
		la $a1, exitMsg			# Load address of exitMsg into a1 to retrieve data to display.
		li $v0, 59			# call messageDialogString syscall (#59) to display data
		syscall
	# Terminate/Exit
		li $v0, 10			# call exit syscall (#10) to terminate.
		syscall


# Counting Fuction
# 2 Parameters: address of inputString and maxWords (length)
# Returns: number of characters (charCount) into register v0 and number of words (wordCount) into register v1

counting:

	# Save s0 register on the stack
		addi $sp, $sp, -4		# Grow stack by 1 (allocate 4 bytes) (PUSH)
		sw $s1, 0($sp)			# Save the value of word s0 on stack using stack pointer.
		move $s1, $a0			# Move value of regiser a0 into register s0
		li $t1, 0 			# Load Immediate Character count into register t1. ($t1 = 0)
		li $t2, 1			# Load Immediate Word count into register t2. ($t2 = 1)
loop2:
		lb $t3, ($s1)			# Load byte $t3 into t3 with contents of memory $s1
		beq $t3, '\n', done2		# Branch to 'GoTo' done2 IF the value of register $t3 is a newline character ('\n')
		beq $t3, '\0', done2		# Branch to 'GoTo' done2 IF the value of register $t3 is a null terminator character ('\0')
		add $t1, $t1, 1			# Counter to increment value of register $t1 (count) by one. (Ex: iteration++)
		beq $t3, ' ', addWord		# Branch to 'GoTo' addWord IF the value of register $t3 is an empty space. (Increases word count every time a space character is found)
		b gotoNext			# Unconditional branch to gotoNext (jump)
addWord:
		addi $t2, $t2, 1		# Add Immediate to add the value of the constant register $t2 and the number one. This increases word count. (Ex: Value = Value + 1)
gotoNext:
		addi $s1, $s1, 1		# Add Immediate to add the value of the constant register $s1 and the number one. This increases character count. (Value = Value + 1)
		b loop2				# Unconditional branch to loop2 (jump)
done2:
	# Retrieve value from stack
		lw $s1, 0($sp)			# Load word from stack into s0 register.
		add $sp, $sp, 4			# Deallocat the 4 bytes to POP off the stack.
		
	# Return the function result values into the registers v0 and v1.
		move $v0, $t1			# Move value of regiser t1 into register v0 (charCount)
		move $v1, $t2			# Move value of regiser t2 into register v1 (wordCount)
		jr $ra				# Jump register to return address to imitate a function call returning to call point.
