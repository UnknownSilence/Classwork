##############################################################################
#									     #
#	Name: Trent Hardy						     #
#	Net ID: TTH190003						     #
#	Assignment: Homework 3 - BMI Calculator		    		     #
#	Date: 10/6/2021							     #
#	Class: CS/SE 2340.003						     #
#									     #
##############################################################################


		.data
prompt1:	.asciiz "What is your Name? "
prompt2:	.asciiz "Please enter your height in inches: "
prompt3:	.asciiz "Please enter your weight in pounds (round to a whole number) "

baseMsg:	.asciiz ", your bmi is: "

firstMsg:	.asciiz "\nThis is considered underweight."
secondMsg:	.asciiz "\nThis is normal weight. "
thirdMsg:	.asciiz "\nThis is considered overweight."
fourthMsg:	.asciiz "\nThis is considered obese."

name:		.space 20

bmiCheck1:	.float 18.5
bmiCheck2:	.float 25
bmiCheck3:	.float 30





		.text
main:
		# Ask user to input name through prompts
		la $a0, prompt1		# Display string with the prompt1 data
		li $v0, 4		# call print string syscall (#4)

		syscall

		# Store the user's given name data

		li $v0, 8		# call read string syscall (#8)
		la $a1, 20		# Load 20 into address a1 (max length)
		la $a0, name		# Load name into address a0

		syscall
		
		li $t0, 0		# Load 0 into address t0 to remove newline character

else:
		lb $t1, name($t0)	# Load byte of name at address t0 into t1
		addi $t0, $t0, 1	# Increment t0 by 1
		bnez $t1, else		# if t1 != 0, goto not_done
		beq $t2, $t0, done	# if t2 == t0, goto done
		addiu $t0, $t0, -2	# t0 = t0 - 2
		sb $zero, name($t0)	# store byte to memory

done:

		# HANDLING HEIGHT:


		# Prompt the user's given height data
		la $a0, prompt2		# Display string with the prompt2 data
		li $v0, 4		# call print string syscall (#4)

		syscall

		# Read/Store the user's given height data

		li $v0, 5		# call read integer syscall (#5)
		syscall
		move $s0,$v0		# move data between registers



		# HANDLING WEIGHT:


		# Prompt the user's given weight data

		la $a0, prompt3		# Display string with the prompt2 data
		li $v0, 4		# call print string syscall (#4)
		
		syscall

		# Read/Store the user's given weight data

		li $v0, 5		# call read integer syscall (#5)
		syscall
		move $s1, $v0		# move data between registers
		
		
		
		
		
		# HANDLING CALCULATIONS:
		

		# Calculate Height
		mul $s0,$s0,$s0		# height = height * height

		# Calculate Weight

		mul $s1,$s1,703		# weight = weight * 703





		# HANDLE FLOATING NUMBERS:
		
		
		# Place floating values into f-registers suitable for instructions with decimals (floats)
		mtc1 $s0 $f20		# copy s0 to f20
		cvt.s.w $f20 $f20	# convert 32 bits in f20 to a float and store in f20
		mtc1 $s1 $f21		# copy s1 to f21
		cvt.s.w $f21 $f21	# convert 32 bits in f21 to a float and store in f21

		# Divide
		div.s $f12, $f21, $f20	# Handle floating divison with single precision

		# Display Results of BMI calculation

		la $a0 name		# Load name into address a0
		li $v0 4		# call print string syscall (#4) to print name
		syscall

		la $a0 baseMsg		# Load baseMsg into address a0
		li $v0 4		# call print string syscall (#4) to print baseMsg
		syscall

		li $v0 2		# call print float syscall (#2)
		syscall





		# Check Relations


		# Use conditional to check if the BMI is less than 18.5: if ( bmi < 18.5)
		l.s $f0, bmiCheck1		# Load single float bmiCheck1 into address f0
		c.lt.d $f12, $f0		# AND Double precision comparison
		bc1t underWeight		# Branch to underWeight if flag is set by the AND double precision comparison. (Flag is set and not 0)



		# Use conditional to check if the BMI is less than 25: if ( bmi < 25)
		l.s $f0, bmiCheck2		# Load single float bmiCheck2 into address f0
		c.lt.d $f12, $f0		# AND Double precision comparison
		bc1t normalWeight		# Branch to normalWeight if flag is set by the AND double precision comparison. (Flag is set and not 0)



		# Use conditional to check if the BMI is less than 25: if ( bmi < 30)
		l.s $f0, bmiCheck3		# Load single float bmiCheck3 into address f0
		c.lt.d $f12, $f0		# AND Double precision comparison
		bc1t overWeight			# Branch to overWeight if flag is set by the AND double precision comparison. (Flag is set and not 0)



		# No previous conditions have been satisfied:
		j obese 			# Otherwise goto obese

underWeight:
		# Display the first message for the underWeight result.
		li $v0, 4			# call print string syscall (#4)
		la $a0, firstMsg		# Load firstMsg into address a0
		syscall

		j exit				# End of the line. Jump to exit to terminate program and avoid running other labels.

normalWeight:
		# Display the second message for the normal weight result.
		li $v0, 4			# call print string syscall (#4)
		la $a0, secondMsg		# Load secondMsg into address a0
		syscall

		j exit				# End of the line. Jump to exit to terminate program and avoid running other labels.
	
overWeight:
		# Display the third message for the overWeight result.
		li $v0, 4			# call print string syscall (#4)
		la $a0, thirdMsg		# Load thirdMsg into address a0
		syscall

		j exit				# End of the line. Jump to exit to terminate program and avoid running other labels.

obese:
		# Display the fourth message for the obesity result.
		li $v0, 4			# call print string syscall (#4)
		la $a0, fourthMsg		# Load fourthMsg into address a0

		syscall
		
		# Jump is not needed since this is (ELSE)

exit:
		li	$v0, 10 # Exit program
		syscall