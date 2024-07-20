.data 
	I: .word 2
	J: .word 1
.text
	la $t8, I
	la $t9, J
	lw $s0, 0($t8)
	lw $s1, 0($t9) 
	addi $s2, $0, 3 # x
	addi $s3, $0, 4 #y
	addi $s4, $0, 5 #z
if:
	slt $t0, $s0, $s1 # i<j 1: 
	bne $t0 , $0 else # ans != 0
	addi $s2, $s2, 1
	addi $s4, $0, 1
	j end
else: 
	subi  $s3, $s3 , 1
	sll $s4, $s4, 1
end:
