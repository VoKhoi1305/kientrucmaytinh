.data 
	largest: .asciiz "largest: "
	smallest: .asciiz "smallest: "
	phay: .asciiz ","
	break1: .asciiz "\n"
	
.text 
main: 
	li $s0, 23 
	li $s1, 2
	li $s2, 35
 	li $s3, 34
	li $s4, 412
	li $s5, 1
	li $s6, 14
	li $s7, -0
	
	jal save
	# t1 = max
	# t2 = indexmax
	# t3 = min
	# t4 = index min
	
	li $v0, 4
	la $a0, largest
	syscall
	
	li $v0,1
	add $a0,$0, $t1
	syscall
	
	li $v0, 4
	la $a0, phay
	syscall
	
	li $v0,1
	add $a0,$0, $t2
	syscall
	
	li $v0, 4
	la $a0, break1
	syscall
	
	li $v0, 4
	la $a0, smallest
	syscall
	
	li $v0,1
	add $a0,$0, $t3
	syscall
	
	li $v0, 4
	la $a0, phay
	syscall
	
	li $v0,1
	add $a0,$0, $t4
	syscall
	
	li $v0, 10
	syscall
end_main:

swap_max: 
	addi $t1, $t5, 0
	addi $t2, $t0, 0
	j set_max
swap_min:
	addi $t3, $t5, 0
	addi $t4, $t0, 0
	j set_min

save:	addi $fp, $sp, 0
	addi $sp, $sp, -32
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	sw $s3, 8($sp)
	sw $s4, 12($sp)
	sw $s5, 16($sp)
	sw $s6, 20($sp)
	sw $s7, 24($sp)
	sw $ra, 28($sp)
	addi $t1, $s0, 0
	li $t2, 0
	addi $t3, $s0, 0
	li $t4, 0
	
find:
	addi $sp, $sp, 4
	lw $t5, -4($sp)
	sub $a0, $fp,$sp
	beq $a0, $0, done
	addi $t0, $t0, 1
	sub $t8, $t1, $t5
	slt $t8, $0, $t8
	beq $t8, $0, swap_max 
set_max:
	sub $t8, $t5, $t3
	slt $t8, $0, $t8
	beq $t8, $0, swap_min
set_min:
	j find	
	
done:
	lw $ra, -4($sp)
	jr $ra
	