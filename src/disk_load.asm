
%macro load_disk 2
	mov dl, %1
	mov dh, %2
	call disk_load
%endmacro
	
disk_load:
	push dx

	mov ah, 0x02
	mov al, dl
	mov ch, 0
	mov cl, dh
	mov dl, 0x80
	mov dh, 0

	int 0x13
	jc disk_err

	pop dx
	cmp dl, al
	jne disk_err
	ret

disk_err:
	print disk_err_msg
	jmp $
	disk_err_msg db 'Load disk failed...', 10, 13, 0
