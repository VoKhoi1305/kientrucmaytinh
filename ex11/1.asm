
.eqv IN_ADRESS_HEXA_KEYBOARD       0xFFFF0012 
.eqv OUT_ADRESS_HEXA_KEYBOARD      0xFFFF0014
.data 
	endline: .asciiz "\n" 
.text 
main:            
li  $t1, IN_ADRESS_HEXA_KEYBOARD 
li  $t2, OUT_ADRESS_HEXA_KEYBOARD 
li  $t3, 0x01 # check row 4 with key C, D,E, F 
li  $t4, 0x02 # check row 4 with key C, D,E, F 
li  $t5, 0x04 # check row 4 with key C, D,E, F 
li  $t6, 0x08 # check row 4 with key C, D,E, F


polling:         

sb $t4,0($t1 )   # must reassign expected row 
nop
lb $a0,0($t2)    # read scan code of key button 
nop
bne $a0, $zero,print
sb $t5,0($t1 )   # must reassign expected row 
nop
lb $a0,0($t2)    # read scan code of key button 
nop
bne $a0, $zero, print
sb $t6,0($t1 )   # must reassign expected row 
nop
lb $a0,0($t2)    # read scan code of key button 
nop
bne $a0, $zero, print
sb $t3,0($t1 )   # must reassign expected row 
nop
lb $a0,0($t2)    # read scan code of key button 
nop


j print
print:      
li $v0, 34        # print integer (hexa) 
syscall 
nop
la $a0, endline 
li $v0, 4 
 syscall 
 nop
sleep:       
li $a0,   3000       # sleep 100ms 
li $v0,   32 
syscall  
nop      
back_to_polling: 
j polling          # continue polling 
