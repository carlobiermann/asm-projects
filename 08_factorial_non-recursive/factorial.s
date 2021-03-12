# PURPOSE - 	Given a number thi program computes the
#		factorial. This example computes the 
#		factorial of 4. 4! = 24

# This program shows how to call the previous function 
# in 06_factorial without recursion. 

.section .data

.section .text

.globl _start
.globl factorial


_start: 
	pushl	$4
	call 	factorial
	movl 	%eax, %ebx
	movl 	$1, %eax
	int	$0x80

factorial:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	cmpl	$0, %eax
	je	is_zero
	mov	%eax, %ebx

loop:
	decl	%ebx
	cmpl	$1, %ebx
	je	end_loop
	imull	%ebx, %eax
	jmp	loop

end_loop:
	movl	%ebp, %esp
	popl	%ebp
	ret

is_zero: 
	movl	$0, %eax
	jmp	end_loop




