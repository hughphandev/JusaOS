	org 0x7c00
	jmp _start
	%include "print.asm"
	%include "disk_load.asm"

_start:	
	;; load filetable to memory
	mov bx, 0x2000
	mov es, bx
	xor bx, bx
	
	load_disk 1, 3

	;; load kernel to memory
	mov bx, 0x1000
	mov es, bx
	xor bx, bx
	
	load_disk 1, 2

	;; off set the kernel to 0x1000 and jump to it
	mov ax, 0x1000
	mov ds, ax
	jmp 0x1000:0
	
format:	times 510 - ($ - $$) db 0
magic:	dw 0xaa55
