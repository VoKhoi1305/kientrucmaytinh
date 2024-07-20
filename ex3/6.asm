.data
A: .word -32, 31, 12, 13, -2 , 16 ,24, 32, 21, 32# Initialize array A 
.text
main:
	la $s2, A
	addi $s1, $0, -1
	addi $s3, $0, 10
	addi $s4, $0, 1
	addi $s5, $0,0 #gt max
	addi $s6, $0, 0 #index
loop:
	add $s1,$s1,$s4 #i=i+step
	add $t1,$s1,$s1 #t1=2*s1
	add $t1,$t1,$t1 #t1=4*s1
	add $t1,$t1,$s2 #t1 store the address of A[i]
	lw $t0,0($t1) #load value of A[i] in $t0 
	slt $t3, $0, $t0 # 0 < A[i] ?? 1: nothing 0: absolute
	beq $t3, $0, absolute   
	j check

absolute:
	sub $t0, $0, $t0
	j check
	
check: 
	slt $t4, $s5, $t0 # max < |a[i]|  1:gan 0:nothing
	bne $t4, $0, do
	bne $s1,$s3,loop 
	beq $s1,$s3, done
do:	
	add $s5, $0, $t0
	add $s6, $0, $t1
	bne $s1,$s3,loop #if i != n, goto loop
	beq $s1,$s3, done
done: