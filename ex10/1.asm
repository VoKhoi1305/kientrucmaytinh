.eqv MONITOR_SCREEN 0x10010000 #Dia chi bat dau cua bo nho man hinh
.eqv RED 0x00FF0000 #Cac gia tri mau thuong su dung
.eqv GREEN 0x0000FF00
.eqv BLUE 0x000000FF
.eqv WHITE 0x00FFFFFF
.eqv YELLOW 0x00FFFF00
.eqv NO 0x00000000
.text
 li $k0, MONITOR_SCREEN #Nap dia chi bat dau cua man hinh
  li $k1, MONITOR_SCREEN
li $t1,0
li $t2,28
loop:	
	sll $t3, $t1, 2
	addi $t1, $t1, 1
	sub $t3, $t2, $t3
	bgt $zero, $t3, endloop
	li $t0, NO
 	sw $t0, 0($k1) 
	nop
	add $k1, $k0, $t3
	li $t0, RED
 	sw $t0, 0($k1)
 	 addi $v0,$zero,32 # Keep running by sleeping in 2000 ms 
 	li $a0,200 
 	syscall 
 	nop
 	
	j loop

endloop:
 
