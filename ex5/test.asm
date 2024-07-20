#Laboratory Exercise 5, Home Assignment 2
.data
a: .asciiz "input string"
x: .space 32 # destination string x, empty
y: .space 32 # source string y
.text
strcpy:
li $v0, 54
 la $a0, a
 la $a1, y
 la $a2, 32
 syscall
 add $s0,$zero,$zero #s0 = i=0
 la $a1, x
L1:

add $t1,$s0,$a0 #t1 = s0 + a1 = i + y[0]
 # = address of y[i]
lb $t2,0($t1) #t2 = value at t1 = y[i]
add $t3,$s0,$a1 #t3 = s0 + a0 = i + x[0] 
 # = address of x[i]
sb $t2,0($t3) #x[i]= t2 = y[i]a
beq $t2,$zero,end_of_strcpy #if y[i]==0, exit
nop
addi $s0,$s0,1 #s0=s0 + 1 <-> i=i+1
j L1 #next character
nop
end_of_strcpy:
