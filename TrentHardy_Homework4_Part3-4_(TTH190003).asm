##############################################################################
#									     #
#	Name: Trent Hardy						     #
#	Net ID: TTH190003						     #
#	Assignment: Homework 4 - MMIO with MARS (Parts 3-4)	    	     #
#	Date: 10/20/2021						     #
#	Class: CS/SE 2340.003						     #
#									     #
##############################################################################


# Instructions: 
#   Connect bitmap display:
#         set pixel dim to 4x4
#         set display dim to 256x256
#	use $gp as base address
#   Connect keyboard and run
#	use w (up), s (down), a (left), d (right), space (exit)
#	all other keys are ignored

# width of screen in pixels

# Centering on bitmap:

# 256 / 4 = 64

.eqv WIDTH 64

# height of screen in pixels

.eqv HEIGHT 64

# Colors used:
.eqv	RED 	0x00FF0000
.eqv	GREEN 	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	YELLOW 	0x00FFFF00
.eqv	CYAN	0x0000FFFF
.eqv	MAGENTA 0x00FF00FF

.data
colors: .word	MAGENTA, CYAN, YELLOW, BLUE, GREEN, RED # Colors list

.text

main:
	# set up starting position for box
	
	addi 	$a0, $0, WIDTH		# a0 = X = WIDTH/2
	sra 	$a0, $a0, 1		# shift right arithmetic (divide by 2)
	
	addi 	$a1, $0, HEIGHT		# a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1		# shift right arithmetic (divide by 2)
	
	la 	$a2, colors		# a2 = red (ox00RRGGBB)
	li	$t4, 0			# load 0 into t4

	
main_loop:	# Begin drawing
	jal 	draw_box

	
	# check for keyboard input
	
	lw $t0, 0xffff0000  #t1 holds if input available
    	beq $t0, 0, main_loop   #If no input, keep displaying
	
	# process keyboard input
	
	lw 	$s1, 0xffff0004
	beq	$s1, 32, exit	# input space
	beq	$s1, 119, up 	# input w
	beq	$s1, 115, down 	# input s
	beq	$s1, 97, left  	# input a
	beq	$s1, 100, right	# input d
	
	# invalid input.
	
	j	main_loop	# repeat
	
	# process valid input
	
up:	li	$a2, 0		# black out the box
	jal	draw_box	# jump and link to draw_box function
	addi	$a1, $a1, -1	# a1 = a1 - 1
	la	$a2, colors	#draw box at new location
	jal	draw_box	# jump and link to draw_box function
	j	main_loop	# jump to main_loop to repeat checking for input

down:	li	$a2, 0		#black out the box
	jal	draw_box	# jump and link to draw_box function
	addi	$a1, $a1, 1	# a1 = a1 - 1
	la	$a2, colors	#draw box at new location
	jal	draw_box	# jump and link to draw_box function
	j	main_loop	# jump to main_loop to repeat checking for input
	
left:	li	$a2, 0		#black out the box
	jal	draw_box
	addi	$a0, $a0, -1
	la	$a2, colors	#draw box at new location
	jal	draw_box
	j	main_loop	# jump to main_loop to repeat checking for input
	
right:	li	$a2, 0		#black out the box
	jal	draw_box	# jump and link to draw_box function
	addi	$a0, $a0, 1	# a0 = a0 - 1
	la	$a2, colors	#draw box at new location
	jal	draw_box	# jump and link to draw_box function
	
	j	main_loop	# jump to main loop to repeat checking for input

exit:	li	$v0, 10		# Terminate program
	syscall
	

# $a0 = X coordinate of center of box

# $a1 = Y coordinate of center of box

# $a2 = color list

draw_box:		
# Function to create the rainbow box

	addi	$sp, $sp, -4	# sp = sp - 4 (stack pointer)
	sw	$ra, ($sp)	# save address of stack pointer to return address

	addi	$t0, $a0, -3	# t0 = a0 - 3
	addi	$t1, $a1, -3	# t1 = a1 - 3
	add	$t3, $0, $0	# t3 = $0 + $0 (nothing)
	
firstBoxLoop:
# t7 = address = gp + 4*(x + y*width)
		
	mul	$t7, $t1, WIDTH	# t7 = y * WIDTH
	
	add	$t7, $t7, $t0	# add the X to t7
	
	mul	$t7, $t7, 4	# multiply by 4 to get word offset
	
	add	$t7, $t7, $gp	# add to base address
	
	jal	marquee		# changes to next color
	
	sw	$t5, ($t7)	# store the color at memory location
	addi	$t0, $t0, 1	# t0 = t0 + 1
	addi	$t3, $t3, 1	# t3 = t3 + 1
	
	bne	$t3, 6, firstBoxLoop	# if t3 != 67, goto firstBoxLoop()
	
	# Set the coords of top right corner
	
	addi	$t0, $a0, 3	# t0 = a0 + 3
	addi	$t1, $a1, -3	# t1 = a1 - 3
	add	$t3, $0, $0	# t3 = $a0 + $a0
	
secondBoxLoop: 
# t7 = address = gp + 4*(x + y*width)

	mul	$t7, $t1, WIDTH	# y * WIDTH
	
	add	$t7, $t7, $t0	# add X
	
	mul	$t7, $t7, 4	# multiply by 4 to get word offset
	
	add	$t7, $t7, $gp	# add to base address
	
	jal	marquee		#changes to next color
	
	sw	$t5, ($t7)	# store the color at memory location
	addi	$t1, $t1, 1	# t1 = t1 + 1
	addi	$t3, $t3, 1	# t3 = t3 + 1
	
	bne	$t3, 6, secondBoxLoop	# if t3 != 6, goto secondBoxLoop()
	
	# Set the coords of bottom right corner
	
	addi	$t0, $a0, 3	# t0 = a0 + 3
	addi	$t1, $a1, 3	# 51 = a1 + 3
	add	$t3, $0, $0	# t3 = $0 + $0
	
thirdBoxLoop:
# t7 = address = gp + 4*(x + y*width)
		
	mul	$t7, $t1, WIDTH   # y * WIDTH
	
	add	$t7, $t7, $t0	  # add X
	
	mul	$t7, $t7, 4	  # multiply by 4 to get word offset
	
	add	$t7, $t7, $gp	  # add to base address
	
	jal	marquee		# changes to next color
	
	sw	$t5, ($t7)	# store color at memory location
	addi	$t0, $t0, -1	# t0 = t0 - 1
	addi	$t3, $t3, 1	# t3 = t3 + 1
	
	bne	$t3, 6, thirdBoxLoop	# if t3 != 6, goto thirdBoxLoop
	
	# Set the coords of bottom left corner
	
	addi	$t0, $a0, -3	# t0 = a0 - 3
	addi	$t1, $a1, 3	# t1 = a1 + 3
	add	$t3, $0, $0	# t3 = $0 + $0
	
fourthBoxLoop:		
# t7 = address = gp + 4*(x + y*width)

	mul	$t7, $t1, WIDTH	# y * WIDTH
	
	add	$t7, $t7, $t0	# add X
	
	mul	$t7, $t7, 4	# multiply by 4 to get word offset
	
	add	$t7, $t7, $gp	# add to base address
	
	jal	marquee		# changes to next color
	
	sw	$t5, ($t7)	# store the color at memory location
	addi	$t1, $t1, -1	# t1 = t1 - 1
	addi	$t3, $t3, 1	# t3 = t3 + 1
	
	bne	$t3, 6, fourthBoxLoop	# if t3 != 6, goto fourthBoxLoop()
	
	addi	$t4, $t4, -4	# causes marquee effect
	lw	$ra, ($sp)	# load word address of sp into return address
	addi	$sp, $sp, 4	# sp = sp + 4
	jr 	$ra		# jump and return to return address


# Transverse the color list to produce marquee effect

marquee:

	addi	$sp, $sp, -4
	sw	$ra, ($sp)

	beq	$a2, 0, clear	# if a2 == 0... goto clear()
	jal	wait		# pause between every pixel drawing
	ble	$t4, 20, shift	# if t4 <= 20 goto shift()
	add	$t4, $0, $0	# t4 = $0 + $0
	
shift:	
	add	$t5, $a2, $t4	# address of color index in t5
	lw	$t5, ($t5)	# loads the color from its adress

	addi	$t4, $t4, 4	# increment by one word boundary

endMarquee:
	lw	$ra, ($sp)	# load word of stack pointer to return address
	addi	$sp, $sp, 4	# sp = sp + 4
	jr 	$ra		# jump and return with return address
	
clear:
	li	$t5, 0		# BLACK
	j	endMarquee	# jump to endMarquee function
	
# Pause function to wait between pixel writes with a delay of 5 ms.
wait:	
	addi	$sp, $sp, -8	# sp = sp - 8 (stack pointer)
	sw	$ra, ($sp)	# save address of stack pointer to return address
	sw	$a0, 4($sp)	# save 4 address of stack pointer to a0
	
	li	$v0, 32		# load instruction 32 into v0 (sleep)
	li	$a0, 5		# load instruction 5 into a0
	syscall			# (sleep)
	
	lw	$ra, ($sp)	# load address of stack pointer into return address
	lw	$a0, 4($sp)	# load 4 address of stack pointer to a0
	addi	$sp, $sp, 8	# sp = sp + 8
	jr 	$ra		# jump and return with return address
