##############################################################################
#									     #
#	Name: Trent Hardy						     #
#	Net ID: TTH190003						     #
#	Assignment: Homework 4 - MMIO with MARS (Parts 1-2 ONLY)	     #
#	Date: 10/20/2021						     #
#	Class: CS/SE 2340.003						     #
#									     #
##############################################################################


# width of screen in pixels

# Centering on bitmap:

# 256 / 4 = 64

.eqv WIDTH 64

# height of screen in pixels

.eqv HEIGHT 64


# Colors:
.eqv RED 0x00FF0000
.eqv GREEN 0x0000FF00
.eqv BLUE 0x000000FF
.eqv WHITE 0x00FFFFFF
.eqv YELLOW 0x00FFFF00
.eqv CYAN 0x0000FFFF
.eqv MAGENTA 0x00FF00FF

.data

colors: .word MAGENTA, CYAN, YELLOW, BLUE, GREEN, RED, WHITE # color list

.text

	addi 	$s1, $0, WIDTH		# s1 = X = WIDTH/2
	sra 	$s1, $s1, 1		# shift right arithmetic (divide by 2)
	
	addi 	$s2, $0, HEIGHT		# s2 = Y = HEIGHT/2
	sra 	$s2, $s2, 1		# shift right arithmetic (divide by 2)

	li $t3, 0x10008000		#t3 = first Pixel
	li $t0, 0			# Load index zero



firstLoop:

	mul $t2, $s2, 256		# Find the index of y
	add $t1, $t0, $s1		# Load the address used for the center point

	mul $t1, $t1, 4			# t1 = t1 * 4
	add $t1, $t1, $t2		# t1 = t1 + t2

	addu $t1, $t3, $t1		# adds xy to first pixel
	mul $a2, $t0, 4			# t1 = t1 * 4 (get the addresss of the color)

	lw $a2, colors($a2)		# load word from colors list at memory location of a2 to a2
	sw $a2, ($t1)			# save word of color at memory location (red)

	add $t0, $t0, 1			# t0 = t0 + 1

	blt $t0, 7, firstLoop		# if t0 < 7, goto firstLoop

	li $t0, 0			# Load index of zero



secondLoop:

	add $t2, $s2, 7			# t2 = s2 + 7. (gets the next line)
	
	mul $t2, $t2, 256		# find the index of y
	add $t1, $t0, $s1		# Load the address used for the center point
	
	mul $t1, $t1, 4			# t1 = t1 * 4
	add $t1, $t1, $t2		# t1 = t1 + t2
	
	addu $t1, $t3, $t1		# add xy to the first pixel
	mul $a2, $t0, 4			# Find the addresss of the color
	
	lw $a2, colors($a2)		# load word from colors list at memory location of a2 to a2
	sw $a2, ($t1)			# save word of color at memory location (red)
	
	add $t0, $t0, 1			# t0 = t0 + 1
	
	blt $t0, 7, secondLoop		# if t0 < 7, goto secondLoop

	li $t0,0			# Load index of zero



thirdLoop:

	add $t2, $s2, $t0		# t2 = s2 + $t0 (gets the next line)
	
	mul $t2, $t2, 256		# find the index of y
	mul $t1, $s1, 4			# t1 = s1 * 4
	
	add $t1, $t1, $t2		# load xy
	addu $t1, $t3, $t1		# add xy to first pixel
	
	mul $a2, $t0, 4			# Find the addresss of the color
	
	lw $a2, colors($a2)		# load word from colors list at memory location of a2 to a2
	sw $a2, ($t1)			# save word of color at memory location (red)
	
	add $t0, $t0, 1			# t0 = t0 + 1
	
	blt $t0, 7, thirdLoop		# if t0 < 7, goto thirdLoop


	li $t0, 0			# Load index of zero



fourthLoop:

	add $t2, $s2,$t0		# t2 = s2 + t0 (gets the next line)
	
	mul $t2, $t2, 256		# find the index of y
	add $t1, $s1, 7			# t1 = s1 + 7. (gets the next line)
	
	mul $t1, $t1, 4			# t1 = t1 * 4
	add $t1, $t1, $t2		# load xy
	
	addu $t1, $t3, $t1		# add xy to first pixel
	
	mul $a2, $t0, 4			# Find the addresss of the color
	
	lw $a2, colors($a2)		# load word from colors list at memory location of a2 to a2
	sw $a2, ($t1)			# save word of color at memory location (red)
	
	add $t0, $t0, 1			# t0 = t0 + 1
	
	blt $t0, 8, fourthLoop		# if t0 < 7, goto thirdLoop
	
	# No zero index needs to be loaded on final loop
	
	
exit:	li	$v0, 10		# Terminate program
	syscall
