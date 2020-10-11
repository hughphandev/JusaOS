%macro while 2
	mov al, %1
	call while
	jmp while_done
i:	%2
	ret
while_done:	
%endmacro

while_loop:
	call i
	cmp al, 0
	je end_while
	call [bx]
	jmp while_loop
end_while:	
	ret
