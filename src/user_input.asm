
	#Return values in v0 and v1. v0 = row. v1 = column

	userInputStack:
		addi $sp, $sp, -16
		sw   $s0, 12($sp)
		sw   $s1,  8($sp)
		sw   $s2,  4($sp)
		sw   $ra,  ($sp)
	userInput:
		addi $s2, $0, 7			#NUMBER LIMIT FOR ROWS AND COLUMNS (0-7. 8 ROWS AND 8 COLUMNS) 
		li $v0, 4
		la $a0 promtCoor
		syscall				#print row string
		
		la $a0, coordinates		#save string in "coordinates"
		li $a1, 3			#limit user input to two letters
		li $v0, 8			
		syscall				#promt user (just the first two characters will be saved into row)

		#inpuit validation
		#column
		addi $t0, $0, 1
		lb $s1, coordinates($t0)	# load user input col into $s1
		addi $t0, $0, 56		#largest number the user can input
		bgt $s1, $t0, badInput		#if user input > 8, then badInput
		
		addi $t0, $0, 49
		blt $s1, $t0, badInput		#if userInput < 1, then bad input
		addi $s1, $s1, -49		#user input -1 (max 7)
		
		#row
		lb $s0, coordinates($0)		#load user input row into $s0
		
		addi $t0, $0, 65
		blt $s0, $t0, badInput		#if input < 65(A), invalid

		addi $t0, $0, 104
		bgt $s0, $t0, badInput		#if input > 104(h), invalid
		
		
		addi $t0, $0, 96
		bgt $s0, $t0, lowerCase

		addi	$t0, $0, 72
		bgt	$s0, $t0, badInput
		
		upperCase:			#change the letter to integer if uppercase
			addi $s0, $s0, -65
			bgt $s0, $s2, badInput
			j validateCoordinates
		
		lowerCase:				#change the letter to integer if lowercase
			addi	$s0, $s0, -97	
			bgt	$s0, $s2, badInput	#if new integer value is bigger than 7, then bad input
			j validateCoordinates
		
	badInput:
		li	$v0, 4
		la	$a0, userMoveMsg		
		syscall
		
		la	$a0, coordinates		
		syscall		
								
		la	$a0, invalidInput
		syscall
		b 	userInput
	
	validateCoordinates:
		add	$v0, $s0, $0
		add	$v1, $s1, $0
		lw	$s0, 12($sp)
		lw	$s1,  8($sp)
		lw	$s2,  4($sp)
	        lw	$ra,  ($sp)
                addi	$sp, $sp, 16               # restore stack pointer
		jr	$ra	
