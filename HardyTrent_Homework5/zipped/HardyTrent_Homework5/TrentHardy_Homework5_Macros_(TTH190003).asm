##############################################################################
#									     #
#	Name: Trent Hardy						     #
#	Net ID: TTH190003						     #
#	Assignment: Homework 5 - Compression Program			     #
#	Date: 11/19/2021						     #
#	Class: CS/SE 2340.003						     #
#									     #
##############################################################################


# MACRO FILE
#=============================================================================


# Macros to handle Strings

.macro printString (%string)
	li	$v0, 4
	la	$a0, (%string)
	syscall
.end_macro

.macro getString (%string)
	li	$v0, 8
	la	$a0, %string
	li	$a1, 30
	syscall
.end_macro



# Macros to handle Integers

.macro printInt (%number)
	li	$v0, 1
	add	$a0, $0, %number
	syscall
.end_macro



# Macros to handle Characters

.macro printChar (%value)
	li	$v0, 11
	add	$a0, $0, %value
	syscall 
.end_macro



# Macros to handle FILE IO

.macro openFile
	li 	$v0, 13
	li	$a1, 0
	li	$a2, 0
	syscall
.end_macro

.macro readFile
	li	$v0, 14
	la	$a1, ($s3)
	li	$a2, 1024
	syscall
.end_macro

.macro closeFile
	li	$v0, 16
	syscall
.end_macro



# Macros to handle Heap Memory

.macro allocateMemory (%value)
	li	$v0, 9
	li	$a0, %value
	syscall
.end_macro
