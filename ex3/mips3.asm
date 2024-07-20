.data
A: .word 1, 2, 3, 4, 5 ,6, 7 ,8 ,9 ,10 # Initialize array A with zeros

.text
main:
	lui $s2, 0x1001
	addi $s1, $0, -1
	addi $s3, $0, 9
	addi $s4, $0, 1
	sub $t5, $s3, 1


loop:
	add $s1,$s1,$s4 #i=i+step
	add $t1,$s1,$s1 #t1=2*s1
	add $t1,$t1,$t1 #t1=4*s1
	add $t1,$t1,$s2 #t1 store the address of A[i]
	lw $t0,0($t1) #load value of A[i] in $t0
	add $s5,$s5,$t0 #sum=sum+A[i]
	slt $t4, $t5, $s1 # n < i 
	beq $t4,$0,loop #if i != n, goto loop

done:
# The final sum is stored in $s5
