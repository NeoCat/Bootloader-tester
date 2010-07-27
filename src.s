	.code16

	// print 'A'
	mov		$0x41, %al
	mov		$0x0e, %ah
	mov		$0x0007, %bx
	int		$0x10

	// read keyboard buffer
	xor		%ax, %ax
	int		$0x16

	// APM power off
	//  - APM connect from real mode
	mov		$0x5301, %ax
	xor		%bx, %bx
	int		$0x15
	jc		err

	//  - APM enable version 1.01
	mov		$0x530e, %ax
	xor		%bx, %bx
	mov		$0x0101, %cx
	int		$0x15
	jc		err

	//  - APM engage Power Management for every device
	mov		$0x530f, %ax
	mov		$0x0001, %bx
	mov		%bx, %cx
	int		$0x15
	jc		err

	//  - APM enable Power Management for every device
	mov		$0x5308, %ax
	mov		$0x0001, %bx
	mov		%bx, %cx
	int		$0x15
	jc		err

	//  - APM set Power State to OFF
	mov		$0x5307, %ax
	mov		$0x0001, %bx
	mov		$0x0003, %cx
	int		$0x15
	jc		err

	jmp loop1

err:
	mov		$0x0007, %bx
	mov		$0x0e, %ah
	add		$0x40, %al
	int		$0x10
	
loop1:
	nop
	cli
	hlt
	jmp		loop1
