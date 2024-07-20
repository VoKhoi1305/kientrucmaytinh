.data
A: .space 100
Aend: .word
msg1: .asciiz "nhap so luong phan tu"
msg2: .asciiz "nhap phan tu "
msg3: .asciiz "\n"
br: .asciiz " "
.text
main: 	
	la $a3, A
	j insert
after_insert:
	la $a0,A
	la $a1,Aend
	la $t8, ($t0)
	mul $t7, $t0, 4
	add $a1,$a0,$t7
	add $a1, $a1, -4
	j sort
after_sort: li $v0, 10 #exit
 syscall
end_main:

print:
	beq $t9, $t8, after_print
	la $a0, A
	mul $t6, $t9, 4
	add $t7, $a0, $t6
	lw $a0, 0($t7)
	
	li $v0,1
	syscall
	
	li $v0 ,4 
	la $a0, br
	syscall
	
	addi $t9, $t9, 1
	j print
	
insert: 
	li $v0, 4
	la $a0,msg1
	syscall
	
	li $v0, 5
	syscall
	
	la $t0, ($v0)
	li $t1,0

loop_in:
	beq $t1,$t0,after_insert
	
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0,5
	syscall
	
	sw $v0, 0($a3)
	addi $t1, $t1, 1
	add $a3, $a3, 4
	j loop_in
sort: beq $a0,$a1,done #single element list is sorted
 j max #call the max procedure
after_max: 
lw $t0,0($a1) #load last element into $t0
 sw $t0,0($v0) #copy last element to max location
 sw $v1,0($a1) #copy max value to last element
 addi $a1,$a1,-4 #decrement pointer to last element
 li $v0,4 
 la $a0,msg3
 syscall
 li $t9,0
 j print
after_print:
 j sort #repeat sort for smaller list
done: j after_sort
#---------------------------------------------------------------------

#Procedure max
#function: fax the value and address of max element in the list
#$a0 pointer to first element
#$a1 pointer to last element
#---------------------------------------------------------------------
max:
la $a0, A
addi $v0,$a0,0 #init max pointer to first element
lw $v1,0($v0) #init max value to first value
addi $t0,$a0,0 #init next pointer to first
loop:
beq $t0,$a1,ret #if next=last, return
addi $t0,$t0,4 #advance to next element
lw $t1,0($t0) #load next element into $t1
slt $t2,$t1,$v1 #(next)<(max) ?
bne $t2,$zero,loop #if (next)<(max), repeat
addi $v0,$t0,0 #next element is new max element
addi $v1,$t1,0 #next value is new max value
j loop #change completed; now repeat
ret:
j after_max
