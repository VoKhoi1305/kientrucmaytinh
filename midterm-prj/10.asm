    .data
prompt: .asciiz "Enter an integer: "
power_msg: .asciiz "Power"
square_msg: .asciiz "Square"
hex_msg: .asciiz "Hexadecimal"
newline: .asciiz "\n"
tab : .asciiz "\t"

    .text
    .globl main

main:
    li $v0, 4               # Print prompt
    la $a0, prompt
    syscall

    li $v0, 5               # Read integer from user
    syscall
    move $t0, $v0           # Store user input in $t0

    # Print table headers
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, power_msg
    syscall

    li $v0, 4
    la $a0, tab
    syscall

    li $v0, 4
    la $a0, square_msg
    syscall

    li $v0, 4
    la $a0, tab
    syscall

    li $v0, 4
    la $a0, hex_msg
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    jal power

    # Print power
    move $a0, $t3
    li $v0, 1
    syscall

    # Print tab
    li $v0, 4
    la $a0, tab
    syscall

    # Calculate square
    move $a0, $t0
    jal square

    # Print square
    move $a0, $v0
    li $v0, 1
    syscall

    # Print tab
    li $v0, 4
    la $a0, tab
    syscall

    move $a0, $t0
    li $v0, 34
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall 
    
    # Exit program
    li $v0, 10
    syscall

# Subroutine to calculate power
power:
    li $t3, 2    
    li $t5, 2           # $t3 = result
    move $t4, $t0           # $t4 = counter
ploop:
    addi $t4, $t4, -1  
    bgtz $t4, pcontinue     # Continue if counter > 0
    jr $ra                  # Return if counter <= 0
pcontinue:
    mul $t3, $t3, $t5      # result *= base
     # counter--
    j ploop

# Subroutine to calculate square
square:
    move $t2, $a0           # $t2 = input
    mul $v0, $t2, $t2       # result = input * input
    jr $ra                  # Return

# Subroutine to calculate hexadecimal

