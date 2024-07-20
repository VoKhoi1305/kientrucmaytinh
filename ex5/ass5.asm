.data
	string: .space 20
	message1: .asciiz "nhap ki tu thu "
	message2: .asciiz "\n"
	message3: .asciiz " chuoi ket qua "

.text 	
	li $t0, 20	# max length
	li $s0, 0	#i 
	li $t7, 10	# \n
	la $s1, string 

getchar: 
	beq $s0, $t0, end_get
	
	li $v0, 4
	la $a0, message1
	syscall
	
	addi $t2, $s0, 1
	li $v0, 1
	add $a0, $t2, $0
	syscall
	
	li $v0, 12
	syscall
	add $t1, $v0, $0
	beq $t1, $t7, end_get
	
	li $v0, 4
	la $a0, message2
	syscall
	
	add $s7, $s1, $s0 #address of string[i]
	sb $t1, 0($s7)
	addi $s0, $s0, 1 # i++
	j getchar
	
end_get:
	li $v0, 4
	la $a0, message3
	syscall
printf:
	li $v0, 11
	lb $a0, 0($s7)
	syscall
	
	beq $s7,$s1, end #if addrvstring[last] = addstring[first] branch to end
	addi $s7, $s7, -1 
	j printf

end:
	