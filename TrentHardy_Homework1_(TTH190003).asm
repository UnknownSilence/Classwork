##############################################################################
#									     #
#	Name: Trent Hardy						     #
#	Net ID: TTH190003						     #
#	Assignment: Homework 1 - MIPS Programming Basics		     #
#	Date: 9/5/2021							     #
#	Class: CS/SE 2340.003						     #
#									     #
##############################################################################

.data

msg1:		.asciiz	"\nWhat is Your name? "
msg2:		.asciiz "Please enter an integer between 1-100: "
resMsg:		.asciiz "Your Answers are: "

name:		.space  20

aVal:		.word   0
bVal:		.word   0
cVal:		.word   0

res1:           .word   0
res2:           .word   0
res3:           .word   0





.text
main:

		# NAME HANDELING:
		
		# Display name prompt to user
                addi	$v0,$0, 4 # rt, rs,4 - display string to user
                la      $a0, msg1 # load address of msg1
                syscall
                
                # Read name given by user input
                addi    $v0,$0, 8 # rt, rs,8 - get string from user
                la      $a0, name # - load adress of name
                addi    $a1,$0, 20 # 20 - length of name
                syscall
                
                
                
                
                
                # FIRST INTEGER HANDELING:
                
                # Display the FIRST integer prompt
                addi    $v0,$0, 4 # rt, rs,4 - display string to user
                la      $a0, msg2 # - load adress of msg2
                syscall
                
                # Read the FIRST integer given by user input
                addi    $v0,$0, 5 # rt, rs,5 - get integer from user
                syscall
                
                # Save the value of the FIRST integer into memory register: aVal
                sw      $v0, aVal
                
                
                
                
                
                # SECOND INTEGER HANDELING:
                
                # Display the SECOND integer prompt
                addi    $v0,$0, 4 # rt, rs,4 - display string to user
                la      $a0, msg2 # - load adress of msg2
                syscall
                
                # Read the SECOND integer given by user input
                addi    $v0,$0, 5 # rt, rs,5 - get integer from user
                syscall
                
                # Save the value of the SECOND integer into memory register: bVal
                sw      $v0, bVal
                
                
                
                
                
                
                # THIRD INTEGER HANDELING:
                
                # Display the THIRD integer prompt
                addi    $v0,$0, 4 # rt, rs,4 - display string to user
                la      $a0, msg2 # - load adress of msg2
                syscall
                
                # Read the THIRD integer given by user input
                addi    $v0,$0,5 # rt, rs,5 - get integer from user
                syscall
                
                # Save the value of the THIRD integer into memory register: bVal
                sw      $v0, cVal
                
                
                
                
                
                # LOADING STORED DATA:
                
                lw      $t1, aVal # load aVal into register $t1
                lw      $t2, bVal # load bVal into register $t2
                lw      $t3, cVal # load cVal into register $t3
                
                
                
                
                
                # FIRST CALCULATION - (res1):
                
                # Formula: res1 = (2a - c + 4)
                add     $t4,$t1,$t1	# Calculation for 2a: ($t4 = $t1 + $t1) AKA (res = a + a): [$t4 = 2a], [$t1 = a]
                sub     $t4,$t4,$t3	# Calculation for 2a-c: ($t4 = 2a) Thus ($t4 = $t4 - $t3) AKA (2a-c = (2a) - c): [$t3 = c]
                addi    $t4,$t4, 4	# Calculation for (2a - c + 4): ($t4 = 2a-c) Thus ($t4 + $t4 + 4) AKA (2a-c+4 = (2a-c) + 4): [$t4 = 2a-c+4]
                sw      $t4, res1	# Save result of (2a-c+4) to memory with res1 - first calculation result
               
                
                
                
                
                # SECOND CALCULATION - (res2):
                
                # Formula: res2 = (b - c + (a - 2))
                sub     $t4,$t2,$t3     # Calculation for b-c: ($t4 = $t2 - $t3) AKA (res = b - c): [$t4 = (b-c)]
                addi    $t5,$t1,-2      # Calculation for a-2: ($t5 = $t1 + (-2)) AKA (res = a + (-2)): [$t5 = (a-2)]
                add     $t4,$t4,$t5     # Calculation for ((b-c) + (a-2)): ($t4 = $t4 + $t5) AKA (res = (b-c) + (a-2)): [$t4 = (b-c) + (a-2)]
                sw      $t4, res2        # Save result of (b-c+(a-2)) to memory with res2 - second calculation result
                
                
                
                
                
                # THIRD CALCULATION - (res2):
                
                # Formula: res3 = ( (a + 3) - ( b - 1) + (c + 3) )
                addi    $t4,$t1,3       # Calculation for a+3: ($t4 = $t1 + 3) AKA (res = a + 3): [$t4 = (a+3)]
                addi    $t5,$t2,-1      # Calculation for b-1: ($t5 = $t2 + (-1)) AKA (res = b + (-1)): [$t5 = (b-1)]
                addi    $t6,$t3,3       # Calculation for c+3: ($t6 = $t3 + 3) AKA (res = c + 3): [$t6 = (c+3)]
                sub     $t4,$t4,$t5     # Calculation for ((a+3)-(b-1)): ($t4 = $t4 - $t5) AKA (res = (a+3) - (b-1)): [$t4 = ((a+3)-(b-1))]
                add     $t4,$t4,$t6     # Calculation for ((a+3)-(b-1)+(c+3)): ($t4 = $t4 + $t6) AKA (res = ((a+3)-(b-1)) + (c+3)): [$t4 = ((a+3)-(b-1)+(c+3))]
                sw      $t4, res3        # Save result of ((a+3)-(b-1)+(c+3)) to memory with res3 - third calculation result
                
                
                
                
 
                # DISPLAY RESULTS:
                
                # Print the name given by the user
                addi    $v0,$0, 4 # rt, rs,4 - display string to user
                la      $a0, name # load address of name
                syscall
                
                # Print the base result message
                addi    $v0,$0, 4 # rt, rs,4 - display string to user
                la      $a0, resMsg # load address of result message
                syscall
                
                # Print the result of the first calculation for the values given by the user
                addi    $v0,$0, 1 # rt, rs,1 - display integer to user
                lw      $a0, res1 # load memory data of first result
                syscall
                
                # For formatting, using ASCII: Print the SPACE character after first result
                addi    $v0,$0, 11 # rt, rs,11 - print character to user
                addi    $a0,$0, 0x20 # rt, rs, 0x20 - print the character of ASCII code: 0x20, to the user (SPACE character)
                syscall
                
                # Print the result of the second calculation for the values given by the user
                addi    $v0,$0, 1 # rt, rs,1 - display integer to user
                lw      $a0, res2 # load memory data of the second result
                syscall
                
                # For formatting, using ASCII: Print the SPACE character after the second result
                addi    $v0,$0, 11 # rt, rs,11 - print character to user
                addi    $a0,$0, 0x20 # rt, rs, 0x20 - print the character of ASCII code: 0x20, to the user (SPACE character)
                syscall
                
                # Print the result of the third calculation for the values given by the user
                addi    $v0,$0, 1 # rt, rs,1 - display integer to user
                lw      $a0, res3 # load memory data of the third result
                syscall
                
exit:
		li	$v0, 10 # Exit program
		syscall
                
##############################################################################
#	SAMPLE RUNS
##############################################################################

# RUN 1:

#	What is your name? Trent
#	Please enter an integer between 1-100: 1
#	Please enter an integer between 1-100: 9000
#	Please enter an integer between 1-100: 77
#	Trent
#	Your Answers are: -71 8922 -8915
#	-- program is finished running --





# RUN 2:

#	What is your name? Slater
#	Please enter an integer between 1-100: -50
#	Please enter an integer between 1-100: 2
#	Please enter an integer between 1-100: 109
#	Slater
#	Your Answers are: -205 -159 64
#	-- program is finished running --     





# RUN 3:

#	What is your name? Bob
#	Please enter an integer between 1-100: -50
#	Please enter an integer between 1-100: -2000
#	Please enter an integer between 1-100: -999
#	Bob
#	Your Answers are: 903 -1053 958
#	-- program is finished running --    
     
                     