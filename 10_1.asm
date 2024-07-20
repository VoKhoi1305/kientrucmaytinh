.eqv SEVENSEG_LEFT 0xFFFF0011 # Dia chi cua den led 7 doan trai.
.eqv SEVENSEG_RIGHT 0xFFFF0010 # Dia chi cua den led 7 doan phai
.data A: .word 0x3F,0x06, 0x5B, 0x4F, 0x66,  0x6D, 0x7D, 0x07, 0x7F, 0x6F
.text
count_up:
 #li $v0, 32
 #li $t0, SEVENSEG_LEFT 
 #li $a0, 0x3F # 0
 #jal SHOW_7SEG_LEFT # show
 #li $a0 , 1000
 #syscall
 #li $a0, 0x06 #1
 #jal SHOW_7SEG_LEFT 
 # li $a0 , 1000
 #syscall
 # li $a0, 0x5B #2
 #jal SHOW_7SEG_LEFT 
 # li $a0 , 1000
 syscall
  li $a0, 0x4F #3
 jal SHOW_7SEG_LEFT 
  li $a0 , 1000
 syscall
  li $a0, 0x66	 #4
 jal SHOW_7SEG_LEFT 
  li $a0 , 1000
 syscall
 li $a0, 0x6D	#5
 jal SHOW_7SEG_LEFT
  li $a0 , 1000
 syscall
 li $a0, 0x7D	#6
 jal SHOW_7SEG_LEFT
  li $a0 , 1000
 syscall
 li $a0, 0x07 	#7
 jal SHOW_7SEG_LEFT
  li $a0 , 1000
 syscall
 li $a0, 0x7F	#8
 jal SHOW_7SEG_LEFT
  li $a0 , 1000
 syscall
 li $a0, 0x6F	#9
 jal SHOW_7SEG_LEFT
  li $a0 , 1000
 syscall
 li $a0, 0x7F	#8
 jal SHOW_7SEG_LEFT
  li $a0 , 1000
 syscall
 li $a0, 0x07 	#7
jal SHOW_7SEG_LEFT
 li $a0 , 1000
 syscall
li $a0, 0x7D	#6
jal SHOW_7SEG_LEFT
 li $a0 , 1000
 syscall
 li $a0, 0x6D	#5
 jal SHOW_7SEG_LEFT
  li $a0 , 1000
 syscall
 li $a0, 0x66	 #4
jal SHOW_7SEG_LEFT 
 li $a0 , 1000
 syscall
  li $a0, 0x4F #3
 jal SHOW_7SEG_LEFT 
  li $a0 , 1000
 syscall
   li $a0, 0x5B #2
 jal SHOW_7SEG_LEFT 
  li $a0 , 1000
 syscall
  li $a0, 0x06 #1
 jal SHOW_7SEG_LEFT 
  li $a0 , 1000
 syscall
 j count_up
 #li $a0, 0x7D # set value for segments
 #jal SHOW_7SEG_RIGHT # show 
exit: li $v0, 10
 syscall
endmain:
#---------------------------------------------------------------
# Function SHOW_7SEG_LEFT : turn on/off the 7seg
# param[in] $a0 value to shown 
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_LEFT: 
# assign port's address
 sb $a0, 0($t0) # assign new value 
jr $ra

#---------------------------------------------------------------
# Function SHOW_7SEG_RIGHT : turn on/off the 7seg
# param[in] $a0 value to shown 
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_RIGHT: 
li $t0, SEVENSEG_RIGHT # assign port's address
 sb $a0, 0($t0) # assign new value
jr $ra 
