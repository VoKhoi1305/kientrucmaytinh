# tao 1 led 
#lsao de nhap 123 hien 23
#bien dem s1, neu s1 >1 dich so cu sang trai chen so moi vao phai
#Chen kieu j 
#  luu bien dem dem o dau L1 
# s1>1 => goi trai , luu so moi o phai
.eqv SEVENSEG_LEFT 0xFFFF0011 # Dia chi cua den led 7 doan trai
.eqv SEVENSEG_RIGHT   0xFFFF0010 # Dia chi cua den led 7 doan phai
.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014 
.data
Message: .asciiz "Oh my god. Someone's presed a button.\n"
.text
main: 
	li $t1, IN_ADRESS_HEXA_KEYBOARD
	li $t3, 0x80
	sb    $t3,   0($t1)
	li $s1,0x0#dem
  
 
 xor $s0,$s0,$s0 
Loop: addi $s0, $s0, 1 
prn_seq:addi $v0,$zero,1
add $a0,$s0,$zero
syscall
prn_eol:addi $v0,$zero,11
li $a0,'\n'
syscall
sleep: addi $v0,$zero,32
li $a0,300 
syscall    

    b       Loop
end_main:
.ktext 0x80000180
addi $v0, $zero, 4 # show message
 la $a0, Message
syscall
IntSR:
addi $sp,$sp,4
sw $ra,0($sp)
addi $sp,$sp,4
sw $at,0($sp)
addi $sp,$sp,4
sw $v0,0($sp)
addi $sp,$sp,4
sw $a0,0($sp)
addi $sp,$sp,4
sw $t1,0($sp)
addi $sp,$sp,4
sw $t3,0($sp) #-------------------------------------------------------- # Processing #--------------------------------------------------------

	
get_cod:

#
li $t1,IN_ADRESS_HEXA_KEYBOARD
li $t3, 0x88 # check row 4 and re-enable bit 7 
sb $t3, 0($t1) # must reassign expected row
li $t1, OUT_ADRESS_HEXA_KEYBOARD
lb $a0, 0($t1)
bne $a0, $zero, L1
#
li $t1,IN_ADRESS_HEXA_KEYBOARD
li $t3, 0x84 # check row 4 and re-enable bit 7 
sb $t3, 0($t1) # must reassign expected row
li $t1, OUT_ADRESS_HEXA_KEYBOARD
lb $a0, 0($t1)
bne $a0, $zero, L1
#
li $t1,IN_ADRESS_HEXA_KEYBOARD
li $t3, 0x82 # check row 4 and re-enable bit 7 
sb $t3, 0($t1) # must reassign expected row
li $t1, OUT_ADRESS_HEXA_KEYBOARD
lb $a0, 0($t1)
bne $a0, $zero, L1
#
li $t1,IN_ADRESS_HEXA_KEYBOARD
li $t3, 0x81 # check row 4 and re-enable bit 7 
sb $t3, 0($t1) # must reassign expected row
li $t1, OUT_ADRESS_HEXA_KEYBOARD
lb $a0, 0($t1)
L1:
addi $s1,$s1,0x1
#dich o day

	bne $s1,0x1,SHOW_7SEG_LEFT
	beq $a0,0x11,biendoi0
	beq $a0,0x21,biendoi1
	beq $a0,0x41,biendoi2
	beq $a0,0xffffff81,biendoi3
	beq  $a0,0x12,biendoi4
	beq $a0,0x22,biendoi5
	beq $a0,0x42,biendoi6
	beq $a0,0xffffff82,biendoi7
	beq $a0,0x14,biendoi8
	beq $a0,0x24,biendoi9
L2:	add $a1,$zero,$a0
	
	
	jal SHOW_7SEG_RIGHT
	nop

next_pc:
	mfc0 $at, $14
	addi $at, $at, 4
	mtc0 $at, $14
restore:
	lw $t3, 0($sp) 
	addi $sp,$sp,-4
	lw $t1, 0($sp) 
	addi $sp,$sp,-4 
	lw $a0, 0($sp) 
	addi $sp,$sp,-4 
	lw $v0, 0($sp)
 	addi $sp,$sp,-4 
 	lw $ra, 0($sp) 
 	addi $sp,$sp,-4
return: eret	 
	

SHOW_7SEG_LEFT:
	li $t0, SEVENSEG_LEFT
	sb   $a1,  0($t0) 	
	nop
	j L2
	nop
SHOW_7SEG_RIGHT:
	li $t0, SEVENSEG_RIGHT
	sb   $a1,  0($t0) 
	nop
	jr   $ra
	nop
biendoi0:	
	addi $a0,$zero,0x3f
	j L2
biendoi1:
	addi $a0,$zero,0x6
	j L2
biendoi2:
	addi $a0,$zero,0x5b
	j L2
biendoi3:
	addi $a0,$zero,0x8f
	j L2
biendoi4:
	addi $a0,$zero,0x66
	j L2
biendoi5:	
	addi $a0,$zero,0x6d
	j L2
biendoi6:	
	addi $a0,$zero,0x7d
	j L2
biendoi7:	
	addi $a0,$zero,0x7
	j L2
biendoi8:	
	addi $a0,$zero,0x7f
	j L2
biendoi9:	
	addi $a0,$zero,0x6f
	j L2

