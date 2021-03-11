# PURPOSE - 		Given a number this program computes the
#			square result of that number. This 	
#			program will only work for numbers below 16.

.section .data

.section .text 

.globl _start
.globl square 


_start: 

	push 	$6
	call	square

	movl	$1, %eax
	int	$0x80

.type square, @function

square:

	pushl	%ebp
	movl	%esp, %ebp

	movl	8(%ebp), %eax
	cmpl	$15, %eax
	jg	end_square
	
	movl	%eax, %ebx
	imull	%eax, %ebx

end_square:	
	
	movl	%ebp, %esp
	popl	%ebp
	ret
