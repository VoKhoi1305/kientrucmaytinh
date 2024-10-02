    .data
prompt: .asciiz "Enter an integer: "
power_msg: .asciiz "Power(2,i)"
square_msg: .asciiz "Square(i)"
hex_msg: .asciiz "Hexadecimal(i)"
i_msg : .asciiz "i"
newline: .asciiz "\n"
tab : .asciiz "\t "
hexa1: .asciiz "0x"
a: .asciiz "a"
b1: .asciiz "b"
c: .asciiz "c"
d: .asciiz "d"
e: .asciiz "e"
f: .asciiz "f"

    .text
    .globl main

main:
    li $v0, 4               # in prompt
    la $a0, prompt
    syscall

    li $v0, 5               # đọc số nguyên 
    syscall
    move $t0, $v0           # lưu số nhập vào $t0

        # in bảng
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, i_msg
    syscall
    
    li $v0, 4
    la $a0, tab
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

    move $a0, $t0
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, tab
    syscall

# gọi chương trình tính power
    jal power
   # in power nếu input <= 30
   subi $t9, $t0, 30
   slt $t9, $zero , $t9
   bne $t9, $zero, skip
   move $a0, $t5
    li $v0, 1
   syscall
skip:
    
    li $v0, 4
    la $a0, tab
    syscall

       # tính square
    move $a0, $t0
    jal square

  
    move $a0, $v0
    li $v0, 1
    syscall

    
    li $v0, 4
    la $a0, tab
    syscall

#	j hexadecimal
#ree:
   # in ra màn hình hexadecimal bằng lệnh có sẵn
    move $a0, $t0
    li $v0, 34
    syscall
    
    li $v0, 10
    syscall

# chương trình con tính toán power
power: 
# trường hợp input <= 30 
    subi $s4, $t0, 30
    slt $t7, $zero, $s4
    bne $t7, $0, power2
    li $t5, 2    
            # $t3 = result
    move $t4, $t0          # $t4 = biến đếm
ploop:
    addi $t4, $t4, -1  
    bgtz $t4, pcontinue     # Continue nếu đếm > 0
    jr $ra                  # Continue nếu đếm > 0
pcontinue:
    sll $t5, $t5, 1      # result *= 2
    j ploop

# trường hợp input 30< i <=60
power2:
 # 2^30
	li $t4, 30          # trường hợp input 30< i <=60
	li $t1, 2
	li $t2, 2
ploop1:
    addi $t4, $t4, -1  
    bgtz $t4, pcontinue1     # Continue nếu đếm > 0
    j ploop2                # Return nếu đếm <= 0
pcontinue1:
    sll $t1, $t1, 1      # result *= 2
    j ploop1
    
 ploop2:
    bgtz $s4, pcontinue2   # Return nếu đếm >= 0
    j calc                  # start calc
pcontinue2:
    sll $t2, $t2, 1      # result *= 2
    addi $s4, $s4, -1 
    j ploop2
    
calc: # tinh so 32bit nhan 32 bit
	srl $t2, $t2, 1
	li $sp, 0x100100a0 #Khái báo địa chỉ con trỏ
	li $s1,10 #Gán giá trị cho thanh ghi s1 = 10 de div lay tung gia tri 1
	li $s4,0 #Gán giá trị cho thanh ghi s4 = 0
	li $s5,0 #Gán giá trị cho thanh ghi s5 = 0
	li $t4,0
	li $t8, 1

loop1:
add $t5,$zero,$t1 #Gán t5=X
div $t2,$t2, $s1 #Lấy ra chữ số hàng đơn vị của Y
mfhi $t3

loop2:
div $t5,$t5, $s1 # X=X/10
mfhi $t4 #t4 = X%10
#Kiểm tra xem đã nhân hết với các chữ số của X hay chưa
seq $s6,$t5,$zero
seq $s7,$t4,$zero
and $s6,$s7,$s6
beq $s6,$t8,return1
mult $t3,$t4
mflo $s2
div $s2,$s2,10
mfhi $s3
add $s3,$s4,$s3
div $s3,$s3,10
mfhi $s3
sw $s3, 0($sp) # đẩy giá trị vào ngăn xêp
 sub $sp, $sp, 4
 add $s4,$zero,$s2
 mflo $s3
 add $s4,$s4,$s3
 j loop2
 
return1: #Nhân với các phần tử khác còn lại
sw $s4, 0($sp) # đẩy nốt giá trị
 sub $sp, $sp, 4 #lui phai 1 don vi
 
loop3: #giống với loop 1 2 nhưng check xem đã hết Y hay chưa
addi $s5,$s5,1
add $t5,$zero,$t1
div $t2,$t2, $s1
mfhi $t3
#check vong lap
seq $s6,$t3,$zero
seq $s7,$t2,$zero
and $s6,$s7,$s6
beq $s6,$t8,return2
li $sp, 0x100100a0
sll $s6,$s5,2
sub $sp,$sp,$s6

loop4:
div $t5,$t5, $s1
mfhi $t4
seq $s6,$t5,$zero
seq $s7,$t4,$zero
and $s6,$s7,$s6
beq $s6,1,loop3
mult $t3,$t4
mflo $s2
div $s2,$s2,10
mfhi $s3
 lw $s4, 0($sp)
add $s3,$s4,$s3
div $s3,$s3,10
mfhi $s3
sw $s3, 0($sp) 
 sub $sp, $sp, 4
 lw $s4,0($sp)
 
 add $s4,$s2,$s4
 mflo $s3
 add $s4,$s4,$s3
 
 sw $s4,0($sp)
 j loop4
return2: # đẩy kết quả vào stack
li $s3,0
sub $sp,$sp,4
lw $s3,0($sp)
loop5: # in ket qua
bgt $sp,0x100100a0,return3
lw $s3,0($sp)
add $sp,$sp,4
li $v0,1
move $a0,$s3
syscall
j loop5
return3:
jr $ra	
#--------------------------------------------------------------------------------------------------
# tinh square (input = $t2)
square:
    move $t2, $a0           # $t2 = input
    mul $v0, $t2, $t2       # result = input * input
    jr $ra                  # Return



