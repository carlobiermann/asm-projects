; This program should only read three bytes from the stdin and output the result 
; to the stdout.

	global		start
	section		.text

start:
	mov		rbx, input 
	mov		rdx, output

	mov		rax, 0x02000003	
	mov		rdi, 0
	mov		rsi, input
	syscall

	mov		rdx, rsi
	inc		rdx
	mov		byte [rdx],10
	
	mov		rax, 0x02000004
	mov		rdi, 1
	mov		rsi, output
	mov 		rdx, data_size
	syscall
	mov		rax, 0x02000001
	xor		rdi, rdi
	syscall
	
		section		.bss
data_size	equ		3
input:		resb		data_size
output:		resb		data_size


