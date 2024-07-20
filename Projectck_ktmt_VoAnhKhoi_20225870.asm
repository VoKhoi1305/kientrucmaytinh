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
    # config
   	 li $a0, 256       # x0 = 256
  	 li $a1, 256       # y0 = 256
   	 li $a2, 20 
   	 li $a3, YELLOW
   	 jal Draw_circle
   	# li $a3, YELLOW 
   	
moving:	
	beq $t1,97, Go_left		#$t1 = 'a'
	beq $t1,100,Go_right		#$t1 = 'd'
	beq $t1,115,Go_down		#$t1 = 's'
	beq $t1,119,Go_up		#$t1 = 'w'
	j Read_key		
	Go_left:	#go to left
		li $a3,BLACK		#color = black
		jal Draw_circle
		addi $a0,$a0,-2		#x0 = x0 - 1
		add $a1,$a1, $0		#y0 = y0
		li $a3, YELLOW		#color = yellow
		jal Draw_circle
		jal Pause
		bltu $a0,20,rebound_right#if x0 <= 20 go right
		j Read_key
	Go_right: 	#go to right
		li $a3,BLACK		#color = black
		jal Draw_circle
		addi $a0,$a0,2		#x0 = x0 + 1
		add $a1,$a1, $0		#y0 = y0
		li $a3, YELLOW		#color = yellow
		jal Draw_circle
		jal Pause
		bgtu $a0,492,rebound_left	#if x0 = 512 - 20 = 492 go left
		j Read_key
	Go_up: 	#go up
		li $a3,BLACK	#color = black
		jal Draw_circle		
		addi $a1,$a1,-2		#y0 = y0 - 1
		add $a0,$a0,$0		#x0 = x0
		li $a3, YELLOW		#color = yellow
		jal Draw_circle
		jal Pause
		bltu $a1,20,rebound_down		#if y0 = 20 go down
		j Read_key
	Go_down: 	#go down
		li $a3,BLACK	#color = black
		jal Draw_circle
		addi $a1,$a1,2	#y0 = y0 + 1
		add $a0,$a0,$0		#x0 = x0
		li $a3, YELLOW		#color = yellow
		jal Draw_circle
		jal Pause
		bgtu $a1,492,rebound_up		#Nếu y0 = 512 - 20 = 492 thì thực hiện đi lên
		j Read_key
	rebound_left:	#go left
		li $t3, 97	#set $t3 = 'a' then store in $k0 
		sw $t3,0($k0)
		j Read_key
	rebound_right:	#go right
		li $t3, 100	#set $t3 = 'd' then store in $k0 
		sw $t3,0($k0)
		j Read_key
	rebound_down:	#go down
		li $t3, 115	#set $t3 = 's' then store in $k0 
		sw $t3,0($k0)
		j Read_key
	rebound_up:	#go up
		li $t3, 119	#set $t3 = 'w' then store in $k0 
		sw $t3,0($k0)
		j Read_key

WaitForKey:  lw   $t0, 0($k1)            # $t1 = [$k1] = KEY_READY 
	nop 
	beq  $t0, $zero, WaitForKey # if $t1 == 0 then Polling 
	nop 
Read_key:	lw $t1, 0($k0) # $t1 = [$k0] = KEY_CODE
	j moving

Pause:	
	addiu $sp,$sp,-4
	sw $a0, ($sp)
	li $a0, 40		# speed = ??ms
	li $v0, 32	 	#syscall sleep
	syscall
    
	lw $a0,($sp)		
	addiu $sp,$sp,4
	jr $ra
Draw_circle:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # config circle


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
    bgez $t5, adjust_else # if p<0

adjust_if: 
    sll $t7, $t3, 2 # 4 * x 
    add $t5, $t5, $t7 # p = p+4x
    addi $t5, $t5, 6 # P = P +4x +6
    addi $t3, $t3, 1 # x = x+1 
    j circle_loop

adjust_else:    
    sub $t8, $t3, $t4 # x-y
    sll $t8, $t8, 2 # 4*(x-y)
    add $t5, $t5, $t8 # p = p +4*(x-y)
    addi $t5, $t5, 10 # p = p +4*(x-y) +10
    subi $t4, $t4, 1 #y= y-1
    addi $t3, $t3, 1 #x= x+1
    j circle_loop
 
endloop: 
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

draw_circle_points:
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # set pixel 8 point
    add $t0, $a0, $t3 # cx = x0+x
    add $t1, $a1, $t4 # cy = y0+y 
    jal set_pixel

    sub $t0, $a0, $t3 # cx = x0-x
    add $t1, $a1, $t4 # cy = y0+y 
    jal set_pixel

    add $t0, $a0, $t3 # cx = x0+x
    sub $t1, $a1, $t4 # cy = y0-y 
    jal set_pixel

    sub $t0, $a0, $t3 # cx = x0-x
    sub $t1, $a1, $t4 # cy = y0-y 
    jal set_pixel

    add $t0, $a0, $t4 # cx = x0+y
    add $t1, $a1, $t3 # cy = y0+x 
    jal set_pixel

    sub $t0, $a0, $t4 # cx = x0-y
    add $t1, $a1, $t3 # cy = y0+x
    jal set_pixel

    add $t0, $a0, $t4 # cx = x0+y
    sub $t1, $a1, $t3 # cy = y0-x
    jal set_pixel

    sub $t0, $a0, $t4 # cx = x0-y
    sub $t1, $a1, $t3 # cy = y0-x
    jal set_pixel

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

set_pixel: # draw point
    add $s1, $t1, $0
    sll $s1, $s1, 9        # calculate offset in $s1: s1 = y_pos * 512
    add $s1, $s1, $t0      # s1 = y_pos * 512 + x_pos = "index"
    sll $s1, $s1, 2        # s1 = (y_pos * 512 + x_pos) * 4 = "offset"
    add $s1, $s1, $v1      # s1 = v1 + offset
    sw  $a3, ($s1)          # draw it!
    jr  $ra
