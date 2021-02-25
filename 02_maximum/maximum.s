# FROM J. Bartlett's "Programming from the Ground Up"
#
#
# VARIABLES: The registers have the following uses: 
#
# %edi - Holds the index of the data item being examined 
# %ebx - Largest data item found 
# %eax - Current data item 
#
# The following memory locations are used: 
#
# data_items - contains the item data. A 0 is used to terminate the data 
# 

.section 		.data

data_items: 			

.long 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 66, 0

.section		.text
.globl			_start

_start:
	movl		$0, %edi
	movl		data_items(,%edi,4), %eax
	movl		%eax, %ebx

start_loop:
	cmpl		$0, %eax
	je 		loop_exit
	incl		%edi
	movl		data_items(,%edi,4), %eax
	cmpl		%ebx, %eax
	jle		start_loop
	movl		%eax, %ebx
	jmp		start_loop

loop_exit: 
# %ebx is the status code for the exit system call
# and it already has the maximum number (return) 

loop_exit:
	movl		$1, %eax
	int		$0x80
