.data
A: .word 1, 4, 6, 4, 5 ,-1, 4 ,5 ,12 ,130 # Initialize array A 

.text
main:
	la $s2, A
	addi $s1, $0, -1
	addi $s3, $0, 10
	addi $s4, $0, 1	

loop:
	add $s1,$s1,$s4 #i=i+step
	add $t1,$s1,$s1 #t1=2*s1
	add $t1,$t1,$t1 #t1=4*s1
	add $t1,$t1,$s2 #t1 store the address of A[i]
	lw $t0,0($t1) #load value of A[i] in $t0
	add $s5,$s5,$t0 #sum=sum+A[i]
	bne $s1,$s3,loop #if i != n, goto loop

done:

