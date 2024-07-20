.data
word: .space 100
prompt: .asciiz "Nhap tu can kiem tra: "
result_true: .asciiz " la mot cyclone word.\n"
result_false: .asciiz " khong phai la mot cyclone word.\n"
end:.byte'\n'
.text
main:
li $t9,1
li $t8,-1
   lb $t6, end 
    # Hiển thị thông báo nhập từ
    li $v0, 4
    la $a0, prompt
    syscall

    # Nhập từ từ bàn phím
    li $v0, 8
    la $a0, word
    li $a1, 100
    syscall
    
    # nhảy tới chương trình để check xem nó có là cyclone word hay không
   j isCycloneWord

result:
    # In kết quả
    beqz $v0, false_result
    li $v0, 4
    la $a0, result_true
    syscall
    j end_program

false_result:
    li $v0, 4
    la $a0, result_false
    syscall

end_program:
    li $v0, 10
    syscall

isCycloneWord:
get_length: la $a0, word# a0 = Address(string[0])
xor $v0, $zero, $zero # v0 = length = 0
xor $t0, $zero, $zero # t0 = i = 0
check_char: add $t1, $a0, $t0 # t1 = a0 + t0 
 #= Address(string[0]+i) 
 lb $t2, 0($t1) # t2 = string[i]
 beq $t2,$t6,end_of_str # Is null char? 
 addi $v0, $v0, 1 # v0=v0+1->length=length+1
 addi $t0, $t0, 1 # t0=t0+1->i = i + 1
 j check_char
 end_of_str :

la $a2, word #a0 , a2 lưu địa chỉ bắt đầu của từ 
la $a0, word#a0 , a2 lưu địa chỉ bắt đầu của từ 
li $t1 , 0
move $t2, $v0#$t2 lưu só chữ của từ
check_loop:
subi $t2, $t2, 1
add $a1, $a2, $t2
    lb $t3, 0($a0)#$t3 lưu chữ trc 
    lb $t4, 0($a1)	#$t4 lưu chữ sau
    sub $t5, $t4, $t3
    slt $t0, $t8, $t5
    beq $t0, $0, not_cyclone_word 

 sub $t7, $t2, $t1
 beq $t7, $t9, end_check_loop

addi $t1, $t1, 1#số đầu +1
add $a0, $a2, $t1

lb $t3, 0($a0)
    lb $t4, 0($a1)
    sub $t5, $t3, $t4
    slt $t0, $t8, $t5
    beq $t0, $0, not_cyclone_word 
    
    sub $t7, $t2, $t1
    beq $t7, $t9, end_check_loop
    j check_loop

not_cyclone_word:
    li $v0, 0
    j result
    
end_check_loop:
    li $v0, 1
    j result
    
   
