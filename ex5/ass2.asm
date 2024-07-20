.data
	mess1: .asciiz "The sum of "
	mess2: .asciiz " and "
	mess3: .asciiz " is "  
.text	
	addi $s0, $0, 13
	addi $s1, $0, 5
	add $s2, $s1, $s0
	
	addi $v0, $0, 4 #print string 
	la $a0, mess1
	syscall
	
	addi $v0, $0, 1 #print num 
	add $a0, $0, $s0
	syscall
	
	addi $v0, $0, 4 #print string 
	la $a0, mess2
	syscall
	
	addi $v0, $0, 1 #print num 
	add $a0, $0, $s1
	syscall
	
	addi $v0, $0, 4 #print string 
	la $a0, mess3
	syscall
	
	addi $v0, $0, 1 #print num 
	add $a0, $0, $s2
	syscall
	
	