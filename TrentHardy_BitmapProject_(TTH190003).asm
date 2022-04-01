##############################################################################
#									     #
#	Name: Trent Hardy						     #
#	Net ID: TTH190003						     #
#	Assignment: Get Creative with Bitmap - Retro Snake Game  	     #
#	Date: 11/7/2021						     	     #
#	Class: CS/SE 2340.003						     #
#									     #
##############################################################################

# Tools Used: Bitmap Display & Keyboard and Display MMIO Simulator

# Bitmap Seetings:

# Unit Width in Pixels: 8
# Unit Height in Pixels: 8
# Display Width in Pixels: 512
# Display Height in Pixels: 512
# Base Address for Display: 0x10008000 ($gp)


.eqv WIDTH 64

.eqv HEIGHT 64

# Colors used in BitMap:
.eqv	snakeBodyColor	 	0x8F00FF		# Purple
.eqv	gameBackgroundColor 	0xFFFFFF		# White
.eqv	gameBorderDeathColor	0xFF0000		# Red
.eqv	gameTargetColor		0x00FF00		# Green (Apples?)



.data

# Directions (ASCII Values) (WASD-based)
#playerMovingUp:	 	119
#playerMovingDown:	115
#playerMovingLeft:	 97
#playerMovingRight:	100



# Message Prompts
gameOverMsg:				.asciiz "GAME OVER! Your score is: "
retryPromptMsg:				.asciiz "Play Again?"



# Track the player's score
playerScore: 				.word 0

# Track Targets on BitMap
targetCoordPosX:			.word 0
targetCoordPosY:			.word 0



# Track the Snake's velocity/speed
snakeVelocity:				.word 75



# Track the scores increment rate. (Increase point amount as game progresses)
playerScoreIncrementRate:		.word 1



# Track the difficulty level for the game.
difficultyLevelTracker: 		.word 10, 25, 50, 100, 500

# 10 - Easy
# 25 - Medium
# 50 - Hard
# 100 - Super Hard
# 500 - Nightmare

# Track the current difficulty level based on player's progress
playerDifficultyLevel:			.word 0



# Default Snake Data
snakeHeadDirection:			.word 119	# Track orientation of the snakes head. (movement direction)
snakeTailDirection:			.word 119	# Track orientation of the snake's tail

snakeHeadPointerX: 			.word 31	# Track x-value of the snake's head for bitmap manipulation
snakeHeadPointerY:			.word 31	# Track y-value of snake's head for bitmap manipulation

snakeTailPointerX:			.word 31	# Track x-value of the snake's head for bitmap manipulation
snakeTailPointerY:			.word 37	# Track the y-value of snake's head for bitmap manipulation.

# Array index/value trackers
arrayIndexValue:			.word 0
arrayLocationValue:			.word 0

# Track the addresses for the bitmap coordinates when direction is updated. (Make tail follow head's vector direction.)
snakeHeadDirectionAddressTrackingList:	.word 0:500



# Track Direction' (Updated Direction)
primeDirectionTracker:			.word 0:500	# Direction' = New Direction







.text

main:
	# Game Main Driver Setup
	li $a1, gameBackgroundColor	# Load background color
	li $a0,	WIDTH			# Load WIDTH of bitmap display
	
	mul $a2, $a0, $a0		# $a2 = WIDTH * WIDTH (Total Pixel Count)
	mul $a2, $a2, 4			# $a2 = $a2 * 4 (Align addresses)
	
	add $a2, $a2, $gp		# Since using $gp, add the base address to $a2
	add $a0, $gp, $zero		# $a0 = $gp + 0. (Counting with $gp)
	
colorFunction:
	# Looping Function to color
	beq $a0, $a2, setupGame		# Check if $a0 == $a2, if it does, setup the game properly. Otherwise...
	
	sw $a1, 0($a0)			# Base Addressing to save Color
	addi $a0, $a0, 4		# $a0 = $a0 + 4. (Counting for loop)
	
	j colorFunction			# goto colorFunction. (repeats until condition goes to setupGame)


setupGame:
	# Configure and setup the game and bitmap (Default Initialization)
	
	# Setup Snake
	li $t0, 31
	
	sw $t0, snakeHeadPointerX
	sw $t0, snakeHeadPointerY
	sw $t0, snakeTailPointerX
	
	li $t1, 37
	sw $t1, snakeTailPointerY
	
	li $t2, 119
	sw $t2, snakeHeadDirection
	sw $t2, snakeTailDirection
	
	li $t4, 75
	sw $t4, snakeVelocity
	
	
	# Setup Player
	
	li $t3, 1
	sw $t3, playerScoreIncrementRate
	
	sw $zero, arrayIndexValue
	sw $zero, arrayLocationValue
	sw $zero, playerDifficultyLevel
	sw $zero, playerScore
	
	
	# Reset Function result registers
	li $v0, 0
	
	# Reset Function argument registers
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	
	# Reset general t purpose registers
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	
	# Reset general s purpose registers
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	


setupGameMap:

	li $t1, 0			# Load Y coordinates
	
	
setupSnake:

	# Draw snake at stored locations on BitMap
	
	# Setup with 8X8 pixels
	
setupSnakeHead:
	# Draw snake's head on BitMap
	
	lw $a0, snakeHeadPointerX 	# Load snake head's X coordinate to $a0
	lw $a1, snakeHeadPointerY 	# Load snake head's Y coordinate to $a1
	
	jal findCoords 			# Find address of coordinates
	
	move $a0, $v0 			# Store coords address in $a0
	
	li $a1, snakeBodyColor 		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point.
	
setupSnakeBody:
	# Draw Snake's main body on BitMap
	
	lw $a0, snakeHeadPointerX 	# Load snake head's X coordinate to $a0
	lw $a1, snakeHeadPointerY 	# Load snake head's Y coordinate to $a1
	
	add $a1, $a1, 1			# Add 1 to $a1. (next)
	jal findCoords 			# Find address of coordinates
	
	move $a0, $v0 			# Store coords address in $a0
	
	li $a1, snakeBodyColor 		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point.
	
	

	lw $a0, snakeHeadPointerX 	# Load snake head's X coordinate to $a0
	lw $a1, snakeHeadPointerY 	# Load snake head's Y coordinate to $a1
	
	add $a1, $a1, 2			# Add 2 to $a1. (next)
	jal findCoords 			# Find address of coordinates
	
	move $a0, $v0 			# Store coords address in $a0
	
	li $a1, snakeBodyColor 		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point.
	
	
	
	lw $a0, snakeHeadPointerX 	# Load snake head's X coordinate to $a0
	lw $a1, snakeHeadPointerY 	# Load snake head's Y coordinate to $a1
	
	add $a1, $a1, 3			# Add 3 to $a1. (next)
	jal findCoords 			# Find address of coordinates
	
	move $a0, $v0 			# Store coords address in $a0
	
	li $a1, snakeBodyColor 		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point.
	
	
	
	lw $a0, snakeHeadPointerX 	# Load snake head's X coordinate to $a0
	lw $a1, snakeHeadPointerY 	# Load snake head's Y coordinate to $a1
	
	add $a1, $a1, 4			# Add 4 to $a1. (next)
	jal findCoords 			# Find address of coordinates
	
	move $a0, $v0 			# Store coords address in $a0
	
	li $a1, snakeBodyColor 		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point.
	
	
	
	
	lw $a0, snakeHeadPointerX 	# Load snake head's X coordinate to $a0
	lw $a1, snakeHeadPointerY 	# Load snake head's Y coordinate to $a1
	
	add $a1, $a1, 5			# Add 5 to $a1. (next)
	jal findCoords 			# Find address of coordinates
	
	move $a0, $v0 			# Store coords address in $a0
	
	li $a1, snakeBodyColor 		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point.
	
	
	
	lw $a0, snakeHeadPointerX 	# Load snake head's X coordinate to $a0
	lw $a1, snakeHeadPointerY 	# Load snake head's Y coordinate to $a1
	
	add $a1, $a1, 6			# Add 6 to $a1. (next)
	jal findCoords 			# Find address of coordinates
	
	move $a0, $v0 			# Store coords address in $a0
	
	li $a1, snakeBodyColor 		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point.
	
setupSnakeTail:
	# Draw Snake's tail on BitMap (last coordinate of snake)
	
	lw $a0, snakeTailPointerX 	# Load snake tail's X coordinate to $a0
	lw $a1, snakeTailPointerY 	# Load snake head's Y coordinate to $a1
	
	jal findCoords			# Find address of coordinates
	
	move $a0, $v0			# Store coords address in $a0
	
	li $a1, snakeBodyColor 		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
	
	
	
# Establish GAME OVER boundries using borders (Death borders)
	

drawLeftBorder:
	# Loop to Draw The Left Death Border
	
	move $a1, $t1			# Store coordinate-y
	li $a0, 0			# load 0 into $a0 (x) (LEFT OF BITMAP)
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	move $a0, $v0			# Store coordinates to $a0 (x)
	
	li $a1, gameBorderDeathColor	# Load border color to $a1
	jal drawCoordPoint		# Call Helper function to draw the pixel at coordinate with the border color.
	
	add $t1, $t1, 1			# Update the y coordinate position by 1 for next loop iteration.
	
	bne $t1, 64, drawLeftBorder	# Use loop to traverse the entire HEIGHT of bitmap (64) and loop the drawing.
	
	li $t1, 0			# Load the Y coordinate to use for right death border.
	
	

	
drawRightBorder:
	# Loop to Draw the Right death border
	
	move $a1, $t1			# Store coordinate-y
	li $a0, 63			# Load the x-coord to 63 (RIGHT OF BITMAP) WIDTH=64. (64-1=63)
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	move $a0, $v0			# Store coordinates to $a0
	
	li $a1, gameBorderDeathColor	# Load border color to $a1 for helper function
	jal drawCoordPoint		# Call Helper function to draw the pixel at coordinate with the border color.
	
	add $t1, $t1, 1			# Update the y coordinate position by 1 for next loop iteration.
	
	bne $t1, 64, drawRightBorder	# Use loop to traverse the entire HEIGHT of bitmap (64) and loop the drawing.	
	
	li $t1, 0			# Load the X coordinate to use for top death border.
	
	
		
drawTopBorder:
	# Loop to draw the Top Death Border
	
	move $a0, $t1			# Store coordinate-x
	li $a1, 0			# load 0 into $a1 (y) (TOP OF BITMAP)
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	move $a0, $v0			#  Store coordinates to $a0 (x)
	
	li $a1, gameBorderDeathColor	# Load border color to $a1
	jal drawCoordPoint		# Call Helper function to draw the pixel at coordinate with the border color.
	
	add $t1, $t1, 1 		# Update the x coordinate position by 1 for next loop iteration.
	
	bne $t1, 64, drawTopBorder 	# Use loop to traverse the entire width of bitmap (64) and loop the drawing.
	
	li $t1, 0			# Load the x coordinate to use for bottom border.

	
	
	
drawBottomBorder:
	move $a0, $t1			# Store coordinate-x
	li $a1, 63			# Load the Y-coord to 63 (BOTTOM OF BITMAP) WIDTH=64. (64-1=63)
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	move $a0, $v0			# Store coordinates to $a0
	
	li $a1, gameBorderDeathColor	# Load border color to $a1
	jal drawCoordPoint		# Call Helper function to draw the pixel at coordinate with the border color.
	
	add $t1, $t1, 1			# Update the x coordinate position by 1 for next loop iteration.
	
	bne $t1, 64, drawBottomBorder	# Use loop to traverse the entire width of bitmap (64) and loop the drawing.
	
	
	
# Generate randomized targets for snake to eat

generateTargets:
	# Use randomizer
	
	li $v0, 42			# syscall 42 generates a random integer. 
	li $a1, 62			# Establish the range of the random integer generated. 62 is upper limit and thus the generated integer x is less than 62.
	syscall
					# Possible values: 0,1,2,3..........59,60,61
	
	addi $a0, $a0, 1		# Update the x-coordinate position to prevent issues with border collision.
	
	sw $a0, targetCoordPosX		# Store the x-coordinate position for the generated target. (randomized value)
	syscall
	
	addi $a0, $a0, 1		# Update the y-coordinate position to prevent issues with border collision.
	
	sw $a0, targetCoordPosY		# Store the y-coordinate position for the generated target. (randomized value)
	
	jal updateDifficultyLevel
	


validatePlayerInput:
	
	# Check for any updates to the snake's vector direction
	lw $a0, snakeVelocity
	jal wait

	lw $a0, snakeHeadPointerX	# Load snake Head's x-coord to Sa0
	lw $a1, snakeHeadPointerY	# Load snake Head's y-coord to Sa0
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	add $a2, $v0, $zero		# Update $a2 = $v0 + 0

	# Get keyboard input
	
	li $t0, 0xffff0000
	lw $t1, ($t0)
	
	andi $t1, $t1, 0x0001		# Bit-wise AND of $t1, and 0x0001.
	beqz $t1, findDirection		# If there is no updated input, continue to point snake in same vector direction.
	
	lw $a1, 4($t0)			# Store the direction of the vector. (snake's head)
	
validateDirection:	
	lw $a0, snakeHeadDirection 	# Load vector direction of snake head to $a0

	jal validateDirectionInput	# Call function to determine if direction is valid for the snake's given state. (EX: Can't turn backwards on itself)
	
	beqz $v0, validatePlayerInput	# If the given direction isn't valid, ignore and attempt new direction input validation
	
	sw $a1, snakeHeadDirection	# If the direction is valid, store the updated direction into $a1 to track
	lw $t7, snakeHeadDirection	# store the old direction into $t7 to track

			
findDirection:

	# Find vector direction for snake to travel
	
	# Based on ASCII values for WASD keys
	
	beq  $t7, 97, playerMovingLeft		# 97 = A = Moving LEFT
	
	beq  $t7, 100, playerMovingRight	# 100 = D = Moving RIGHT
	
	beq $t7, 119, playerMovingUp		# 119 = W = Moving UP
	
	beq  $t7, 115, playerMovingDown		# 115 = S = Moving DOWN

	j validatePlayerInput		# Loop to check for valid input if none of the above are entered.
	
playerMovingUp:

	# Move upward (Update snake head)
	
	
	# Detect and Check for collision before updating movement.
	
	lw $a0, snakeHeadPointerX	# Load x-value of snake's head into $a0
	lw $a1, snakeHeadPointerY	# Load y-value of snake's head into $a1
	
	lw $a2, snakeHeadDirection	# Load the snake's vector direction into $a2
	
	jal detectGameOverCollision	# Call function to detect if any game-ending collisions occur.
	
	
	# Redraw snake head on BitMap with updated coordinate position.

	lw $t0, snakeHeadPointerX	# Load x-value of snake's head into $t0
	lw $t1, snakeHeadPointerY	# Load y-value of snake's head into $t1
	
	addi $t1, $t1, -1		# Update y position and move it up.		
	
	add $a0, $t0, $zero		# $a0 = $t0 + 0
	add $a1, $t1, $zero		# $a1 = $t1 + 0
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	add $a0, $v0, $zero		# $a0 = $v0 + 0. (update $a0 with coords address)
	
	li $a1, snakeBodyColor		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point

	sw  $t1, snakeHeadPointerY	# Store y-value of snake's hed into $t1
	
	j updateSnakeTail		# Update tail to match updated head
	
playerMovingDown:

	# Move downward (Update snake head)
	
	
	# Detect and Check for collision before updating movement.
	lw $a0, snakeHeadPointerX	# Load x-value of snake's head into $a0
	lw $a1, snakeHeadPointerY	# Load y-value of snake's head into $a1
	
	lw $a2, snakeHeadDirection	# Load the snake's vector direction into $a2
	
	jal detectGameOverCollision	# Call function to detect if any game-ending collisions occur.
	
	# Redraw snake head on BitMap with updated coordinate position.
	
	lw $t0, snakeHeadPointerX	# Load x-value of snake's head into $t0
	lw $t1, snakeHeadPointerY	# Load y-value of snake's head into $t1
	
	addi $t1, $t1, 1		# Update y position and move it down.
	
	add $a0, $t0, $zero		# $a0 = $t0 + 0
	add $a1, $t1, $zero		# $a1 = $t1 + 0
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	add $a0, $v0, $zero		# $a0 = $v0 + 0. (update $a0 with coords address)
	
	li $a1, snakeBodyColor		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
	
	sw  $t1, snakeHeadPointerY	# Store y-value of snake's hed into $t1
	
	j updateSnakeTail		# Update tail to match updated head

playerMovingLeft:
	# Move left (Update snake head)
	
	
	# Detect and Check for collision before updating movement.
	lw $a0, snakeHeadPointerX	# Load x-value of snake's head into $a0
	lw $a1, snakeHeadPointerY	# Load y-value of snake's head into $a1
	
	lw $a2, snakeHeadDirection	# Load the snake's vector direction into $a2
	
	jal detectGameOverCollision	# Call function to detect if any game-ending collisions occur.
	
	# Redraw snake head on BitMap with updated coordinate position.
	
	lw $t0, snakeHeadPointerX	# Load x-value of snake's head into $t0
	lw $t1, snakeHeadPointerY	# Load y-value of snake's head into $t1
	
	addi $t0, $t0, -1		# Update x position and move it left.
	
	add $a0, $t0, $zero		# $a0 = $t0 + 0
	add $a1, $t1, $zero		# $a1 = $t1 + 0
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	add $a0, $v0, $zero		# $a0 = $v0 + 0. (update $a0 with coords address)
	
	li $a1, snakeBodyColor		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
	
	sw  $t0, snakeHeadPointerX	# Store x-value of snake's hed into $t0
	
	j updateSnakeTail 		# Update tail to match updated head

playerMovingRight:
	# Move right (Update snake head)
	
	
	# Detect and Check for collision before updating movement:
	lw $a0, snakeHeadPointerX	# Load x-value of snake's head into $a0
	lw $a1, snakeHeadPointerY	# Load y-value of snake's head into $a1
	
	lw $a2, snakeHeadDirection	# Load the snake's vector direction into $a2
	
	jal detectGameOverCollision	# Call function to detect if any game-ending collisions occur.
	
	# Redraw snake head on BitMap with updated coordinate position.
	
	lw $t0, snakeHeadPointerX	# Load x-value of snake's head into $t0
	lw $t1, snakeHeadPointerY	# Load y-value of snake's head into $t1
	
	addi $t0, $t0, 1		# Update x position and move it right.
	
	add $a0, $t0, $zero		# $a0 = $t0 + 0
	add $a1, $t1, $zero		# $a1 = $t1 + 0
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	add $a0, $v0, $zero		# $a0 = $v0 + 0. (update $a0 with coords address)
	
	li $a1, snakeBodyColor		# Load the color of the snake's body into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
	
	
	sw  $t0, snakeHeadPointerX	# Store x-value of snake's hed into $t0
	
	j updateSnakeTail		# Update tail to match updated head


			
updateSnakeTail:	

	lw $t2, snakeTailDirection	# Load the snake tail's vector direction
	
	# Check the tail's movement type and branch:
	
	# $t2 Based on ASCII values for WASD keys
	
	beq  $t2, 97, updateTailLeft	# 97 = A = Moving LEFT
		
	beq  $t2, 100, updateTailRight	# 100 = D = Moving RIGHT
	
	beq  $t2, 119, updateTailUp	# 119 = W = Moving UP
	
	beq  $t2, 115, updateTailDown	# 115 = S = Moving DOWN
	



updateTailUp:
	# Update tail movement up

	# Find BitMap coordinates for next updated direction.
	lw $t8, arrayLocationValue	# Load the array location value into $t8
	la $t0, snakeHeadDirectionAddressTrackingList	# Load the list (array) of snake head direction addresses into $t0
	
	add $t0, $t0, $t8		# $t0 = $t0 + $t8
	
	lw $t9, 0($t0)			# Load the value at the address position of the array to $t9
	
	lw $a0, snakeTailPointerX 	# Load the snake tail's x-coordinate position into $a0.
	lw $a1, snakeTailPointerY	# Load the snake tail's y-coordinate position into $a1.
	
	# Check if the index of the array is valid 
	beq $s1, 1, updateLengthUp	# Length for tail "up" movement needs to increase, otherwise...

	addi $a1, $a1, -1		# No change in length: thus tail position is updated. (Y value)
	
	sw $a1, snakeTailPointerY	# Store updated tail position (Y) into $a1
	
updateLengthUp:
	li $s1, 0 			# Update $s1 to 0 (false) to keep logic valid
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	add $a0, $v0, $zero		# # $a0 = $v0 + 0. (update $a0 with coords address)
	
	bne $t9, $a0, drawTailUp 	# Check if $t9 = $a0 and if a change in direction is required
	
	la $t3, primeDirectionTracker	# update the vector direction
	
	add $t3, $t3, $t8		# $t3 = $t3 + $t8
	
	lw $t9, 0($t3)			# Load the value at the address position of $t3 to $t9
	sw $t9, snakeTailDirection	# Store the snake tail's vector direction in $t9
	
	addi $t8, $t8, 4		# $t8 = $t8 + 4. (update index)
	
	bne $t8, 396, saveUpLocation	# check if index is valid
	
	li $t8, 0			# Set $t8 index to 0 if invalid
saveUpLocation:
	sw $t8, arrayLocationValue 	# Store the array's location value in to $t8
drawTailUp:
	li $a1, snakeBodyColor		# Load the snake's body color into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
	
	# Get ride of pixels behind snake as it moves.
	
	lw $t0, snakeTailPointerX	## Load the snake tail's x-coordinate position into $t0.
	lw $t1, snakeTailPointerY	# Load the snake tail's y-coordinate position into $t1.
	
	addi $t1, $t1, 1		# $t1 = $t1 + 1. (update movement)
	
	add $a0, $t0, $zero		# $a0 = $t0 + 0
	add $a1, $t1, $zero		# $a1 = $t1 + 0
	
	jal findCoords			# Call Helper function to get address of coordinates	
	add $a0, $v0, $zero		# $a0 = $v0 + 0. (add coords to $a0)
	
	# reDraw behind snake to remove past spots
	li $a1, gameBackgroundColor	# Load game's background color into $a1. (Blank null space)
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
		
	j drawTarget			# Update the targets

updateTailDown:
# Update tail movement down
	
	# Find BitMap coordinates for next updated direction.
	lw $t8, arrayLocationValue	# Load the array location value into $t8
	la $t0, snakeHeadDirectionAddressTrackingList	# Load the list (array) of snake head direction addresses into $t0
	
	add $t0, $t0, $t8		# $t0 = $t0 + $t8
	
	lw $t9, 0($t0)			# Load the value at the address position of the array to $t9
	
	lw $a0, snakeTailPointerX  	# Load the snake tail's x-coordinate position into $a0.
	lw $a1, snakeTailPointerY	# Load the snake tail's y-coordinate position into $a1.
	
	beq $s1, 1, updateLengthDown	# Length for tail "up" movement needs to increase, otherwise...
	
	addi $a1, $a1, 1		# No change in length: thus tail position is updated. (Y value)
	
	sw $a1, snakeTailPointerY	# Store updated tail position (Y) into $a1
	
updateLengthDown:
	li $s1, 0			# Update $s1 to 0 (false) to keep logic valid
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	add $a0, $v0, $zero		# # $a0 = $v0 + 0. (update $a0 with coords address)
	
	bne $t9, $a0, drawTailDown	# Check if $t9 = $a0 and if a change in direction is required
	
	la $t3, primeDirectionTracker	# update the vector direction
	
	add $t3, $t3, $t8		# $t3 = $t3 + $t8
	
	lw $t9, 0($t3)			# Load the value at the address position of $t3 to $t9
	sw $t9, snakeTailDirection	# Store the snake tail's vector direction in $t9
	
	addi $t8, $t8, 4		# $t8 = $t8 + 4. (update index)
	
	bne $t8, 396, saveDownLocation	# check if index is valid
	
	li $t8, 0			# Set $t8 index to 0 if invalid
	
saveDownLocation:
	sw $t8, arrayLocationValue  	# Store the array's location value in to $t8
	
drawTailDown:	

	li $a1, snakeBodyColor		# Load the snake's body color into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
		
	# Get ride of pixels behind snake as it moves.
	
	lw $t0, snakeTailPointerX	# Load the snake tail's x-coordinate position into $t0.
	lw $t1, snakeTailPointerY	# Load the snake tail's y-coordinate position into $t1.
	
	addi $t1, $t1, -1		# $t1 = $t1 - 1. (update movement)
	
	add $a0, $t0, $zero		# $a0 = $t0 + 0
	add $a1, $t1, $zero		# $a1 = $t1 + 0
	
	jal findCoords			# Call Helper function to get address of coordinates	
	add $a0, $v0, $zero		# $a0 = $v0 + 0. (add coords to $a0)
	
	# reDraw behind snake to remove past spots
	li $a1, gameBackgroundColor	# Load game's background color into $a1. (Blank null space)
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
	
	j drawTarget			# Update the targets

updateTailLeft:
# Update tail movement left

	# Find BitMap coordinates for next updated direction.
	lw $t8, arrayLocationValue	# Load the array location value into $t8
	la $t0, snakeHeadDirectionAddressTrackingList	# Load the list (array) of snake head direction addresses into $t0
	
	add $t0, $t0, $t8		# $t0 = $t0 + $t8
	
	lw $t9, 0($t0)			# Load the value at the address position of the array to $t9
	
	lw $a0, snakeTailPointerX	# Load the snake tail's x-coordinate position into $a0.
	lw $a1, snakeTailPointerY	# Load the snake tail's y-coordinate position into $a1.
	
	beq $s1, 1, updateLengthLeft	# Length for tail "up" movement needs to increase, otherwise...
	
	addi $a0, $a0, -1		# No change in length: thus tail position is updated. (X value)
	
	sw $a0, snakeTailPointerX	# Store updated tail position (X) into $a0
	
updateLengthLeft:

	li $s1, 0			# Update $s1 to 0 (false) to keep logic valid
	
	jal findCoords			# Call Helper function to get address of coordinates
	
	add $a0, $v0, $zero		# $a0 = $v0 + 0. (update $a0 with coords address)
	
	bne $t9, $a0, drawTailLeft	# Check if $t9 = $a0 and if a change in direction is required
	
	la $t3, primeDirectionTracker	# update the vector direction
	
	add $t3, $t3, $t8		# $t3 = $t3 + $t8
	
	lw $t9, 0($t3)			# Load the value at the address position of $t3 to $t9
	sw $t9, snakeTailDirection	# Store the snake tail's vector direction in $t9
	
	addi $t8, $t8, 4			# $t8 = $t8 + 4. (update index)
	
	bne $t8, 396, saveLeftLocation	# check if index is valid
	
	li $t8, 0			# Set $t8 index to 0 if invalid
	
saveLeftLocation:

	sw $t8, arrayLocationValue  	# Store the array's location value in to $t8
	
drawTailLeft:	

	li $a1, snakeBodyColor		# Load the snake's body color into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
			
	# Get ride of pixels behind snake as it moves.
	
	lw $t0, snakeTailPointerX	# Load the snake tail's x-coordinate position into $t0.
	lw $t1, snakeTailPointerY	# Load the snake tail's y-coordinate position into $t1.
	
	addi $t0, $t0, 1		# $t1 = $t1 + 1. (update movement)
	
	add $a0, $t0, $zero		# $a0 = $t0 + 0
	add $a1, $t1, $zero		# $a1 = $t1 + 0
	
	jal findCoords			# Call Helper function to get address of coordinates	
	add $a0, $v0, $zero		# $a0 = $v0 + 0. (add coords to $a0)
	
	# reDraw behind snake to remove past spots
	li $a1, gameBackgroundColor	# Load game's background color into $a1. (Blank null space)
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
		
	j drawTarget			# Update the targets

updateTailRight:
# Update tail movement right

	# Find BitMap coordinates for next updated direction.
	lw $t8, arrayLocationValue	# Load the array location value into $t8
	la $t0, snakeHeadDirectionAddressTrackingList	# Load the list (array) of snake head direction addresses into $t0
	
	add $t0, $t0, $t8		# $t0 = $t0 + $t8

	lw $t9, 0($t0)			# Load the value at the address position of the array to $t9

	lw $a0, snakeTailPointerX	# Load the snake tail's x-coordinate position into $a0.
	lw $a1, snakeTailPointerY	# Load the snake tail's y-coordinate position into $a1.
	

	beq $s1, 1, updateLengthRight	# Length for tail "right" movement needs to increase, otherwise...

	addi $a0, $a0, 1		# No change in length: thus tail position is updated. (X value)

	sw $a0, snakeTailPointerX	# Store updated tail position (X) into $a0
	
updateLengthRight:

	li $s1, 0			# Update $s1 to 0 (false) to keep logic valid

	jal findCoords			# Call Helper function to get address of coordinates

	add $a0, $v0, $zero		# $a0 = $v0 + 0. (update $a0 with coords address)

	bne $t9, $a0, drawTailRight	# Check if $t9 = $a0 and if a change in direction is required

	la $t3, primeDirectionTracker	# update the vector direction

	add $t3, $t3, $t8		# $t3 = $t3 + $t8

	lw $t9, 0($t3)			# Load the value at the address position of $t3 to $t9
	sw $t9, snakeTailDirection	# Store the snake tail's vector direction in $t9

	addi $t8,$t8,4			# $t8 = $t8 + 4. (update index)

	bne $t8, 396, saveRightLocation	# check if index is valid
	
	li $t8, 0			# Set $t8 index to 0 if invalid
	
saveRightLocation:

	sw $t8, arrayLocationValue  	# Store the array's location value in to $t8
	
drawTailRight:	

	li $a1, snakeBodyColor		# Load the snake's body color into $a1
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
		

	lw $t0, snakeTailPointerX	# Load the snake tail's x-coordinate position into $t0.
	lw $t1, snakeTailPointerY	# Load the snake tail's y-coordinate position into $t1.

	
	addi $t0, $t0, -1		# $t1 = $t1 - 1. (update movement)
	
	add $a0, $t0, $zero		# $a0 = $t0 + 0
	add $a1, $t1, $zero		# $a1 = $t1 + 0
	
	jal findCoords			# Call Helper function to get address of coordinates	
	add $a0, $v0, $zero		# $a0 = $v0 + 0. (add coords to $a0)
	
	# reDraw behind snake to remove past spots
	li $a1, gameBackgroundColor	# Load game's background color into $a1. (Blank null space)
	jal drawCoordPoint		# Call Helper function to draw a pixel for the snakes body at the coordinate point
	
	j drawTarget			# Update the targets
	




drawTarget:

	# Determine target collision
	
	lw $a0, snakeHeadPointerX	# Load snake head's x-coordinate into $a0
	lw $a1, snakeHeadPointerY	# Load snake head's y-coordinate into $a1
	
	jal validateTargetCollision	# Call function to determine if collision occurs
	
	beq $v0, 1, updateLength	# If $v0 = 1, Length needs to increase, otherwise...

	# Draw Targets
	lw $a0, targetCoordPosX		# Load target's randomized x-coordinate
	lw $a1, targetCoordPosY		# Load target's randomized y-coordinate
	
	jal findCoords			# Call Helper function to get address of coordinates		
	
	add $a0, $v0, $zero		# $a0 = $v0 + 0
	li $a1, gameTargetColor		# load the color fo the target's into $a1
	
	jal drawCoordPoint		# Call function to draw target on BitMap using color.
	j validatePlayerInput		# Jump to validating player input
	
updateLength:
	li $s1, 1			# Update $s1 to 1 (true) to keep logic valid that snake length needs to increase
	j generateTargets		# jump to generating Targets





findCoords:
	# For the BitMap, coordinates need an address...
	# Take the $a0,$a1 addresses and find the cooresponding x,y coordinates address
	
	li $v0, WIDTH 			# get WIDTH
	
	mul $v0, $v0, $a1		# Multiply WIDTH by $a1 (Y)
	
	add $v0, $v0, $a0		# Add $a0 to resultant. (add X)
	
	mul $v0, $v0, 4			# Multiply $v0 by 4. $V0 = ((WIDTH * Y) + X) * 4) 
	
	add $v0, $v0, $gp		# Add the base address $gp to the result.
	
	jr $ra				# return $v0 (address for the coordinates)






	

validateDirectionInput:
	beq $a0, $a1, equals  	# Check if the input is equaal to the current vector direction
	
	
	beq $a0, 119, validateMovementDown	# While snake's moving down, check to see if down is pressed
	
	beq $a0, 115, validateMovementUp	# While snake's moving up, check to see if up is pressed
	
	beq $a0, 97, validateMovementRight	# While snake's moving right, check to see if right is pressed
	
	beq $a0, 100, validateMovementLeft	# While snake's moving left, check to see if left is pressed
	
	
	j validatedDirection 			# If input is invalid, get new input validated
	
	
# ASCII codes USED:

validateMovementLeft:
	beq $a1, 97, invalidMovement		# Check if "LEFT" (97)(A) is pressed while snake is moving rightwards
	j movementValidated			# Prevent issues. (No going back on itself)


validateMovementRight:
	beq $a1, 100, invalidMovement		# Check if "RIGHT (100)(A) is pressed while snake is moving leftwards
	j movementValidated			# Prevent issues. (No going back on itself)

validateMovementUp:
	beq $a1, 119, invalidMovement 		# Check if "UP" (119) (W) is pressed while snake is moving downwards
	j movementValidated			# Prevent issues. (No going back on itself)
	
validateMovementDown:
	beq $a1, 115, invalidMovement		# Check if "DOWN" (115)(S) is pressed while snake is moving upwards
	j movementValidated			# Prevent issues. (No going back on itself)



	

	
movementValidated:
	li $v0, 1				# Load 1 into $v0. (function arguments)
	
	
	beq $a1, 97, storeLeftDirection		# Store the location of leftwards direction change ("LEFT" - A)
	
	beq $a1, 100, storeRightDirection	# Store the location of rightwards direction change ("RIGHT" - D)
	
	beq $a1, 119, storeUpDirection 		# Store the location of upwards direction change ("UP" - W)
	
	beq $a1, 115, storeDownDirection	# Store the location of downwards direction change ("DOWN" - S)
	

	
	j validatedDirection			# Jump to validated Direction (valid)
		
storeUpDirection:
	lw $t4, arrayIndexValue			# Load array's index value
	
	la $t2, snakeHeadDirectionAddressTrackingList	# Load address of the coordinate for snake's direction change
	la $t3, primeDirectionTracker 			# Load address of new Direction'
	
	# Add index to the base value
	add $t2, $t2, $t4 			# $t2 = $t2 + $t4
	add $t3, $t3, $t4			# $t3 = $t3 + $t4
		
	sw $a2, 0($t2)				# Store $a2 (coordinates) into the array
	
	li $t5, 119				# Load ASCII 119 ("UP" - W) into $t5
	
	sw $t5, 0($t3)				# Store the snake head's direction in given index
	
	addi $t4, $t4, 4			# Increment array index for traversel
	
	bne $t4, 396, brakeUp			# check if $t4 is valid...
	
	li $t4, 0				# $t4 is invalid/out of bounds. Set to 0.
brakeUp:
	sw $t4, arrayIndexValue			# Store array's index value in $t4
	j validatedDirection			# Jump to the validated Direction. (valid)
	
storeDownDirection:
	lw $t4, arrayIndexValue			# Load array's index value
	
	la $t2, snakeHeadDirectionAddressTrackingList # Load address of the coordinate for snake's direction change
	la $t3, primeDirectionTracker 		# Load address of new Direction'
	
	# Add index to the base value
	add $t2, $t2, $t4 			# $t2 = $t2 + $t4
	add $t3, $t3, $t4			# $t3 = $t3 + $t4
	
	sw $a2, 0($t2)				# Store $a2 (coordinates) into the array
	
	li $t5, 115				# Load ASCII 115 ("DOWN" - S) into $t5
	
	sw $t5, 0($t3)				# Store the snake head's direction in given index

	addi $t4, $t4, 4			# Increment array index for traversel
	
	bne $t4, 396, brakeDown			# check if $t4 is valid...
	
	li $t4, 0				# $t4 is invalid/out of bounds. Set to 0.

brakeDown:	
	sw $t4, arrayIndexValue			# Store array's index value in $t4
	j validatedDirection			# Jump to the validated Direction. (valid)

storeLeftDirection:

	lw $t4, arrayIndexValue			# Load array's index value
	
	la $t2, snakeHeadDirectionAddressTrackingList # Load address of the coordinate for snake's direction change
	la $t3, primeDirectionTracker 		# Load address of new Direction'
	
	# Add index to the base value
	add $t2, $t2, $t4 			# $t2 = $t2 + $t4
	add $t3, $t3, $t4			# $t3 = $t3 + $t4

	sw $a2, 0($t2)				# Store $a2 (coordinates) into the array
	
	li $t5, 97				# Load ASCII 97 ("LEFT" - A) into $t5
	
	sw $t5, 0($t3)				# Store the snake head's direction in given index

	addi $t4, $t4, 4			# Increment array index for traversel

	bne $t4, 396, brakeLeft			# check if $t4 is valid...
	
	li $t4, 0				# $t4 is invalid/out of bounds. Set to 0.

brakeLeft:
	sw $t4, arrayIndexValue			# Store array's index value in $t4
	j validatedDirection			# Jump to the validated Direction. (valid)

storeRightDirection:

	lw $t4, arrayIndexValue			# Load array's index value
	
	
	la $t2, snakeHeadDirectionAddressTrackingList # Load address of the coordinate for snake's direction change
	la $t3, primeDirectionTracker 		# Load address of new Direction'
	
	# Add index to the base value
	add $t2, $t2, $t4 			# $t2 = $t2 + $t4
	add $t3, $t3, $t4			# $t3 = $t3 + $t4
	
	sw $a2, 0($t2)				# Store $a2 (coordinates) into the array
	
	li $t5, 100				# Load ASCII 100 ("RIGHT" - D) into $t5
	
	sw $t5, 0($t3)				# Store the snake head's direction in given index

	addi $t4, $t4, 4			# Increment array index for traversel
	
	bne $t4, 396, brakeRight		# check if $t4 is valid...
	
	li $t4, 0				# $t4 is invalid/out of bounds. Set to 0.

brakeRight:
	sw $t4, arrayIndexValue			# Store array's index value in $t4
	j validatedDirection			# Jump to the validated Direction. (valid)	
	
invalidMovement:
	li $v0, 0				# Set $v0 to 0. (false). MOVEMENT IS NOT VALID!
	j validatedDirection			# Jump to the validated Direction. (invalid)		
	
equals:
	li $v0, 1				# Set $v0 to 1. (true)
	
validatedDirection:
	jr $ra					# jump return to $ra (return address) of function call.
	

wait:
	# Timeout
	li $v0, 32				# Syscall 32 - Sleep
	syscall
	jr $ra					# Jump and return to $ra (return address) of function call.

validateTargetCollision:
	
	# No collision
	add $v0, $zero, $zero			# $v0 = 0 + 0 => 0
	
	lw $t0, targetCoordPosX			# Load target's x coordinate position to $t0
	lw $t1, targetCoordPosY			# Load target's y coordinate position to $t1
	

	
	beq $a0, $t0, checkTargetCollisionX	# Check if $a0 is equal to the target's x position. If so... (Is target's X equal to the snake's x?)
	
	# Otherwise...
	
	
	j endCollisionCheck
	
	# If $v0 = 1: COLLISION
	# If $v0 = 0: NO COLLISION
	
checkTargetCollisionX:
	
	# Is target's Y equal to the snake's Y?
	beq $a1, $t1, checkTargetCollisionY	# Check if $a1 = $t1.
	
	# If not, no collision occurs.
	j endCollisionCheck
	
checkTargetCollisionY:

	# Target's x and y are equivalent to snake's x and y. Collision occurs with target and target is consumed.
	
	lw $t5, playerScore			# Load playerScore to $t5
	lw $t6, playerScoreIncrementRate	# Load the increase rate of the player socre into $t6
	add $t5, $t5, $t6			# $t5 = $t5 + $t6 (playerScore = playerScore + playerScoreIncrementRate)
	sw $t5, playerScore			# Store playerScore in $t5


	
	li $v0, 1				# $v0 = 1. Collision occurs.
	
endCollisionCheck:
	jr $ra					# Jump and return to $ra (return address) of function
	
detectGameOverCollision:

	add $s3, $a0, $zero			# $s3 = $a0 + 0
	add $s4, $a1, $zero			# $s4 = $a1 + 0
	
	sw $ra, 0($sp)				# Store return address

	beq  $a2, 97,  validateLeftCollision	# Check if $a2 = ASCII 97 ("LEFT" - A). If so, validate.
	
	beq  $a2, 100, validateRightCollision	# Check if $a2 = ASCII 100 ("RIGHT" - D). If so, validate.

	beq  $a2, 119, validateUpCollision	# Check if $a2 = ASCII 119 ("UP" - W). If so, validate.
	
	beq  $a2, 115, validateDownCollision	# Check if $a2 = ASCII 115 ("DOWN" - S). If so, validate.
	

	
validateUpCollision:


	addiu $a1, $a1, -1			# $a1 = $a1 - 1. (Find coordinate above position)
	jal findCoords				# Call Helper function to get address of coordinates
		
	lw $t1, 0($v0)				# Load color at address on BitMap
	
	li $t2, snakeBodyColor			# Load snake's body color to $t2
	li $t3, gameBorderDeathColor		# Load border color to $t3
	
	beq $t1, $t2, endProgram		# If color and snake's body color are the same, death occurs.
	
	beq $t1, $t3, endProgram		# If the color and death color are the same, collision with border occurs.
	
	j endSnakeCollisionDetection		# No collision. No death. End of function.

validateDownCollision:

	addiu $a1, $a1, 1			# $a1 = $a1 + 1. (Find coordinate below position)
	jal findCoords				# Call Helper function to get address of coordinates
	
	lw $t1, 0($v0)				# Load color at address on BitMap
	
	li $t2, snakeBodyColor			# Load snake's body color to $t2
	li $t3, gameBorderDeathColor		# Load border color to $t3
	
	beq $t1, $t2, endProgram		# If color and snake's body color are the same, death occurs.
	
	beq $t1, $t3, endProgram		# If the color and death color are the same, collision with border occurs.
	
	j endSnakeCollisionDetection		# No collision. No death. End of function.

validateLeftCollision:

	addiu $a0, $a0, -1			# $a1 = $a1 - 1. (Find coordinate above position)
	jal findCoords				# Call Helper function to get address of coordinates
	
	lw $t1, 0($v0)				# Load color at address on BitMap
	
	li $t2, snakeBodyColor			# Load snake's body color to $t2
	li $t3, gameBorderDeathColor		# Load border color to $t3
	
	beq $t1, $t2, endProgram		# If color and snake's body color are the same, death occurs.
	
	beq $t1, $t3, endProgram		# If the color and death color are the same, collision with border occurs.
	
	j endSnakeCollisionDetection		# No collision. No death. End of function.

validateRightCollision:


	addiu $a0, $a0, 1			# $a1 = $a1 - 1. (Find coordinate above position)
	jal findCoords				# Call Helper function to get address of coordinates
	

	lw $t1, 0($v0)				# Load color at address on BitMap
	

	li $t2, snakeBodyColor			# Load snake's body color to $t2
	li $t3, gameBorderDeathColor		# Load border color to $t3
	
	beq $t1, $t2, endProgram		# If colors and snake's body color are the same, death occurs.
	
	beq $t1, $t3, endProgram		# If the color and death color are the same, collision with border occurs.
	
	j endSnakeCollisionDetection		# No collision. No death. End of function.

endSnakeCollisionDetection:

	lw $ra, 0($sp)				# Load return address into $r1. (restore)
	jr $ra					# Jump return to $ra (return address) from function call
	

updateDifficultyLevel:

	lw $t0, playerScore			# Load player's score (points)
	la $t1, difficultyLevelTracker		# Load the difficulty level array tracker
	lw $t2, playerDifficultyLevel		# Load the player's current difficulty level. (index in array)
	
	add $t1, $t1, $t2			# $t1 = $t1 + $t2. 
	lw $t3, 0($t1)				# Find difficulty level value at index of tracker array
	
	bne $t3, $t0, difficultyUpdated 	# Check if player's score isn't equal to the next difficulty level threshhold
	
	addi $t2, $t2, 4			# Update array index to traverse difficulty levels
	
	# Difficulty level increases as points increase
	sw $t2, playerDifficultyLevel		# Store the player's difficulty level into $t2
	lw $t0, playerScoreIncrementRate	# Load the playerScoreIncrementRate into $t0
	
	sll $t0, $t0, 1 			# $t0 = $t0 * 2
	
	lw $t1, snakeVelocity			# Load the snake's velocity into $t1
	
	addi $t1, $t1, -20			# Increase snake's velocity by 20. (subtracttion boosts velocity)
	
	sw $t1, snakeVelocity			# Store updated snake velocity into $t1

difficultyUpdated:
	jr $ra					# Jump and return to $ra (return address) of function call
	
	

drawCoordPoint:
	# Using BitMap, draw a coordinate point (pixel) with given color.
	sw $a1, ($a0) 	# Fill pixel
	jr $ra		# Return to function call

endProgram:   
	li $v0, 56				# Syscall 56 - MessageDialogInt	
	la $a0, gameOverMsg			# Load and display gameover message
	lw $a1, playerScore			# Load and display player score
	syscall
	
	li $v0, 50				# Syscall 50 - ConfirmDialog
	la $a0, retryPromptMsg			# Load and display the replay message prompt ($a0 = choice)
	syscall
	
	beqz $a0, main				# If yes, Jump to main and restart program

terminateProgram:
	li $v0, 10				# Syscall 10 - Exit (terminate execution)
	syscall