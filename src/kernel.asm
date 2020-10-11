	jmp _start
	%include "print.asm"

_start:	
	;; set video mode
	mov ah, 0x00
	mov al, 0x03
	int 10h

	print wtext, wtext_len, 0x00 | 0x2, 1, 0, 0, 0

	;; keyboard handling
	;; for some reasons cant print using si?
get_input:	
	mov di, cmdString
keyloop:	
	xor ax, ax
	int 0x16

	mov ah, 0x0e
	int 0x10

	cmp al, 13
	je run_command

	mov [di], al
	inc di
	jmp keyloop

run_command:
	mov al, 10
	int 0x10

	mov byte [di], 0
	mov al, [cmdString]

	cmp al, 'F'
	je file_explorer

	cmp al, 'R'
	je reboot

	print failure
	jmp get_input

reboot:
	jmp 0xFFFF:0x0000	;reset vetor

file_explorer:	
	mov ah, 0x00
	mov al, 0x03
	int 10h

	print file_table_header
	mov ax, 0x2000
	mov es, ax
	xor bx, bx
	mov ah, 0x0e
	jmp next_line

file_explorer_loop:	
	mov al, [es:bx]

	cmp al, 0
	je get_input

	cmp al, '{'
	je next_char

	cmp al, '}'
	je next_line

	cmp al, ' '
	je next_char

	cmp al, ','
	je next_line

	cmp al, '-'
	je print_space_align

	sub cx, 1
	int 0x10

next_char:	
	inc bx
	jmp file_explorer_loop

next_line:
	push ax
	mov cx, 21
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	pop ax
	jmp next_char
	
print_space_align:
	push cx
	mov al, ' '
	int 0x10
	loop print_space_align
	pop cx
	jmp next_char

done:	
	hlt


wtext:	
	db 'welcome to JusaOS', 10, 13
	db '-----------------', 10, 13
	db 'F> File explorer', 10, 13
	db 'R> Reboot', 10, 13

wtext_len:
	dw $ - wtext 

file_table_header:
	db 'file                 sectors', 10, 13
	db '----------------------------', 10, 13, 0

failure:
	db 'Oops! Something went wrong!', 10, 13, 0

cmdString:
	db ''

	times 512 - ($ - $$) db 0
