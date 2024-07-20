.eqv SEVENSEG_LEFT 0xFFFF0011 # Dia chi cua den led 7 doan trai.
.eqv SEVENSEG_RIGHT 0xFFFF0010 # Dia chi cua den led 7 doan phai
.data
 array: .word 0x3F,0x06, 0x5B, 0x4F, 0x66,  0x6D, 0x7D, 0x07, 0x7F, 0x6F
.text
	li $s1, 10
	li $s3, 1
	li, $v0, 32
count_up:
	la $t1, array 
	add $t4, $t1, $t3 
	lw $a0, 0($t4)	 
	jal SHOW_7SEG_LEFT 
 	li $a0 , 1000
 	syscall
	addi $t2, $t2, 1
	sll $t3, $t2, 2
	add $t4, $t1, $t3 
	beq $t2, $s1, count_down
j count_up	
count_down:
	subi $t2, $t2, 1
	sll $t3, $t2, 2
	add $t4, $t1, $t3 
	lw $a0, -4($t4)
	jal SHOW_7SEG_LEFT 
 	li $a0 , 1000
 	syscall
 	beq $t2, $s3 count_up
 	j count_down
exit: li $v0, 10
 syscall
endmain:
#---------------------------------------------------------------
# Function SHOW_7SEG_LEFT : turn on/off the 7seg
# param[in] $a0 value to shown 
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_LEFT: 
# assign port's address
 li   $t0,  SEVENSEG_LEFT # assign port's address  
                 sb   $a0,  0($t0)        # assign new value   
                 nop 
                 jr   $ra 
                 nop 

#---------------------------------------------------------------
# Function SHOW_7SEG_RIGHT : turn on/off the 7seg
# param[in] $a0 value to shown 
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_RIGHT: 
li $t0, SEVENSEG_RIGHT # assign port's address
 sb $a0, 0($t0) # assign new value
jr $ra 