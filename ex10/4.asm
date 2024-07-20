.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?
 # Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 # =1 if the display has already to do
 # Auto clear after sw
.text
 li $k0, KEY_CODE
 li $k1, KEY_READY
 
 li $s0, DISPLAY_CODE
 li $s1, DISPLAY_READY
loop: nop
 
WaitForKey: lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
 nop
 beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
 nop
 #-----------------------------------------------------
ReadKey: lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE
 nop
 #-----------------------------------------------------
WaitForDis: lw $t2, 0($s1) # $t2 = [$s1] = DISPLAY_READY
 nop
 beq $t2, $zero, WaitForDis # if $t2 == 0 then Polling 
 nop 
 #-----------------------------------------------------
 
 #-----------------------------------------------------
check: 
checkE:
 beq $t3, 1, CheckX
 beq $t0, 101, Having
CheckX:
 beq $t3, 2, CheckI
 beq $t0, 120, Having 
CheckI:
 beq $t3, 3, CheckT
 beq $t0, 105, Having 
CheckT:
 beq $t3, 4, Exit
 beq $t0, 116, Having
Not:
addi $t3, $zero, 0 
 #----------------------------------------------------- 
 ShowKey: sw $t0, 0($s0) # show key
 nop 
 beq $t3, 4, Exit 
 j loop
 nop
 
 Having: addi $t3, $t3, 1
 j ShowKey
 Exit: 
 li $v0, 10 
 syscall 
