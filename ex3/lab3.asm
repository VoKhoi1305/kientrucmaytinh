# s0 = ans 

.data 
A: .word -1110, 16, -3, -4, 35 , -96, 27 ,318 , 39 , 1200

#s2 dai chi 
#s1 i , S3 diem ket thuc, s4 step

.text 
	lui $s2, 0x1000
	ori $s2, 0xfffc
	addi $s1, $0, 0
	addi $s3, $0, 10
	addi $s4, $0, 1	
	lw $t7,4($s2) #load value of A[0] in $t7
	add $s0, $0, $t7 # ans = A[0}
loop:
	add $s1,$s1,$s4 #i=i+step
	add $t1,$s1,$s1 #t1=2*s1
	add $t1,$t1,$t1 #t1=4*s1
	add $t1,$t1,$s2 #t1 store the address of A[i]
	lw $t0,0($t1) #load value of A[i] in $t0 
	lw $t5,0($t1)
	slt $t3, $s0, $t0 # 0 < A[i] ?? 1: nothing 0: absolute
	beq $t3, $0, absolute   
	j check

check:
	slt $t8, $0, $s0 # 0< preans 0: absolute2 1:nothing 
	beq $t8, $0, absolute2

sosanh:
	slt $t4, $t6, $t0 # |ans| < |a[i]| 1: gan	0:nothing
	bne $t4, $0, gan
	bne $s1,$s3,loop #if i != n, goto loop
	beq $s1,$s3, done
	

absolute:
	sub $t0, $0, $t0
	j check
	
absolute2 :	
	sub $t6, $0, $s0
	j sosanh
	
gan:
	add $s0, $0, $t5
	bne $s1,$s3,loop #if i != n, goto loop
	beq $s1,$s3, done
done:
