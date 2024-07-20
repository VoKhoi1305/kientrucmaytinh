.data 
	I: .word 2
	J: .word 1
	M: .word 4
	N: .word 4
.text
	la $t8, I
	la $t9, J
	lw $s0, 0($t8)
	lw $s1, 0($t9) 
	la $t6, M
	la $t7, N
	lw $s5, 0($t6)
	lw $s6, 0($t7) 
	addi $s2, $0, 3 # x
	addi $s3, $0, 4 #y
	addi $s4, $0, 5 #z
	add $t1, $s0, $s1 # i+j
	add $t2, $s5, $s6 # m+n
if:	
	
	slt $t0, $t1, $t2 # i+j < m+n
	bne $t0 , $0 else 
	addi $s2, $s2, 1
	addi $s4, $0, 1
	j end
else: 
	subi  $s3, $s3 , 1
	sll $s4, $s4, 1
end:
