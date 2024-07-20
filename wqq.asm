# KEYBOARD and DISPLAY MMIO ----------------------------------------------------
.eqv KEY_CODE 0xFFFF0004  # ASCII code to show, 1 byte 
.eqv KEY_READY 0xFFFF0000
# BITMAP DISPLAY ----------------------------------------------------
.eqv MONITOR_SCREEN 0x10010000
.eqv YELLOW 0x00FFFF00
.eqv BLACK 0x00000000
.text 
	li   $k0,  KEY_CODE 
	li   $k1,  KEY_READY 
	li   $v1, MONITOR_SCREEN 
main:
    # Khởi tạo các biến
   	 li $a0, 256       # cx = 256
  	 li $a1, 256       # cy = 256
   	 li $a2, 20 
   	 li $a3, YELLOW
   	 jal DrawCircle
   	# li $t3, YELLOW 
   	
moving:	
	beq $t1,97,left		#$t1 = 'a'
	beq $t1,100,right	#$t1 = 'd'
	beq $t1,115,down	#$t1 = 's'
	beq $t1,119,up		#$t1 = 'w'
	j Input		
	left:	#Thực hiện di chuyển sang trái
		li $a3,BLACK	#color = black
		jal DrawCircle
		addi $a0,$a0,-2		#x0 = x0 - 1
		add $a1,$a1, $0		#y0 = y0
		li $a3, YELLOW		#color = yellow
		jal DrawCircle
		jal Pause
		bltu $a0,20,reboundRight	#Nếu x0 = 20 thì thực hiện bật phải
		j Input
	right: 	#Thực hiện di chuyển sang phải
		li $a3,BLACK	#color = black
		jal DrawCircle
		addi $a0,$a0,2		#x0 = x0 + 1
		add $a1,$a1, $0		#y0 = y0
		li $a3, YELLOW		#color = yellow
		jal DrawCircle
		jal Pause
		bgtu $a0,492,reboundLeft	#Nếu x0 = 512 - 20 = 492 thì thực hiện bật trái
		j Input
	up: 	#Thực hiện di chuyển lên trên
		li $a3,BLACK	#color = black
		jal DrawCircle		
		addi $a1,$a1,-2		#y0 = y0 - 1
		add $a0,$a0,$0		#x0 = x0
		li $a3, YELLOW		#color = yellow
		jal DrawCircle
		jal Pause
		bltu $a1,20,reboundDown		#Nếu y0 = 20 thì thực hiện đi xuống
		j Input
	down: 	#Thực hiện di chuyển xuống dưới
		li $a3,BLACK	#color = black
		jal DrawCircle
		addi $a1,$a1,2	#y0 = y0 + 1
		add $a0,$a0,$0		#x0 = x0
		li $a3, YELLOW		#color = yellow
		jal DrawCircle
		jal Pause
		bgtu $a1,492,reboundUp		#Nếu y0 = 512 - 20 = 492 thì thực hiện đi lên
		j Input
	reboundLeft:	#Thực hiện bật sang trái
		li $t3, 97	#Gán $t3 với 'a' rồi lưu vào địa chỉ $k0 
		sw $t3,0($k0)
		j Input	
	reboundRight:	#Thực hiện bật sang phải
		li $t3, 100	#Gán $t3 với 'd' rồi lưu vào địa chỉ $k0 
		sw $t3,0($k0)
		j Input	
	reboundDown:	#Thực hiện bật xuống dưới
		li $t3, 115	#Gán $t3 với 's' rồi lưu vào địa chỉ $k0 
		sw $t3,0($k0)
		j Input
	reboundUp:		#Thực hiện bật lên trên
		li $t3, 119	#Gán $t3 với 'w' rồi lưu vào địa chỉ $k0 
		sw $t3,0($k0)
		j Input
Input:	#Thực hiện đọc kí tự từ bàn phím  
	ReadKey: lw $t1, 0($k0) # $t1 = [$k0] = KEY_CODE
	j moving

Pause:	#vì thanh ghi $a0 trùng với biến số x0 nên để sử dụng syscall 32 thì dùng stack để lưu tạm thời giá trị $a0 
	addiu $sp,$sp,-4
	sw $a0, ($sp)
	li $a0, 20		# speed = 0ms
	li $v0, 32	 	#syscall sleep
	syscall
    
	lw $a0,($sp)		#tra lai gia tri $a0
	addiu $sp,$sp,4
	jr $ra
	
#----------------------------------------------------------------
# DrawCircle
# @brief	Vẽ hình tròn theo thuật toán Midpoint Circle
# @param[in]	$a0	Tọa độ x0 của tâm
# @param[in]	$a1	Tọa độ y0 của tâm
#----------------------------------------------------------------
DrawCircle:
    # Lưu các thanh ghi tạm thời
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Tính toán các biến khởi tạo
    move $s0, $a0  # cx
    move $s1, $a1  # cy
   

    li $t3, 0     # x = 0
    move $t4, $a2 # y = r
    li $t5, 3
    sll $t6, $a2, 1  # t6 = 2 * r
    sub $t5, $t5, $t6 # t5 = 3 - 2 * r

# while x<=y
circle_loop:
    ble $t3, $t4, draw_points
    b endloop

draw_points:
    jal draw_circle_points
    bgez $t5, adjust_else

adjust_if: 
    sll $t7, $t3, 2 # 4 * x 
    add $t5, $t5, $t7
    addi $t5, $t5, 6
    addi $t3, $t3, 1
    j circle_loop

adjust_else:    
    sub $t8, $t3, $t4
    sll $t8, $t8, 2
    add $t5, $t5, $t8
    addi $t5, $t5, 10
    subi $t4, $t4, 1
    addi $t3, $t3, 1
    j circle_loop
 
endloop: 
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

draw_circle_points:
    # Lưu các thanh ghi tạm thời
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Tính toán và vẽ các điểm
    add $t0, $a0, $t3
    add $t1, $a1, $t4
    jal set_pixel

    sub $t0, $a0, $t3
    add $t1, $a1, $t4
    jal set_pixel

    add $t0, $a0, $t3
    sub $t1, $a1, $t4
    jal set_pixel

    sub $t0, $a0, $t3
    sub $t1, $a1, $t4
    jal set_pixel

    add $t0, $a0, $t4
    add $t1, $a1, $t3
    jal set_pixel

    sub $t0, $a0, $t4
    add $t1, $a1, $t3
    jal set_pixel

    add $t0, $a0, $t4
    sub $t1, $a1, $t3
    jal set_pixel

    sub $t0, $a0, $t4
    sub $t1, $a1, $t3
    jal set_pixel

    # Phục hồi các thanh ghi tạm thời
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

set_pixel:
    add $s1, $t1, $0
    sll $s1, $s1, 9        # calculate offset in $s1: s1 = y_pos * 512
    add $s1, $s1, $t0      # s1 = y_pos * 512 + x_pos = "index"
    sll $s1, $s1, 2        # s1 = (y_pos * 512 + x_pos) * 4 = "offset"
    add $s1, $s1, $v1      # s1 = v1 + offset
    sw  $a3, ($s1)          # draw it!
    jr  $ra
