# PURPOSE:	This program takes the input from the STDIN 
#		and writes it to the file given by the 
#		first command line argument


.section .data 

#######CONSTANTS#######

# system call numbers 

.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# options for open (look at
# /usr/include/asm/fcntl.h for 
# various values. You can combine them 
# by adding them or ORing them) 

.equ O_RDONLY, 0 
.equ O_CREAT_WRONLY_TRUNC, 03101

# standard file descriptors 

.equ STDIN, 0 
.equ STDOUT, 1
.equ STDERR, 2 

# system call interrupt

.equ LINUX_SYSCALL, 0x80

.equ END_OF_FILE, 0 	# This is the return value 
			# of read which means we've
			# hit the end of the file

.equ NUMBER_ARGUMENTS, 2


.section .bss

# Buffer - 	This is where the data is loaded into 
#		from the data file and written from 
#		into the output file. This should
#		never exceed 16,000 for various 
#		reasons. 

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.lcomm BSS_STDIN, 4
.lcomm BSS_STDOUT, 4

.section .text

# STACK POSITIONS 

.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4	
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0		# Number of arguments 
.equ ST_ARGV_0, 4	# Name of program
.equ ST_ARGV_1, 8  	# Output file name
#.equ ST_ARGV_2, 12 	# Output file name


.globl _start
_start:

	###INITIALIZE PROGRAMM###

	# save the stack pointer
	movl	%esp, %ebp

	# Allocate space for our file descriptors
	# on the stack 
	#subl $ST_SIZE_RESERVE, %esp

open_files:
#open_fd_in:

	###OPEN INPUT FILE###
	
	# open syscall
#	movl 	$SYS_OPEN, %eax

	# input filename int %ebx
#	movl	ST_ARGV_1(%ebp), %ebx

	# read-only flag
#	movl	$O_RDONLY, %ecx

	# this doesn't really matter for reading
#	movl 	$0666, %edx

	# call Linux 
#	int	$LINUX_SYSCALL


#store_fd_in:

	# save the given file descriptor
#	movl 	$STDIN, ST_FD_IN(%ebp)
	movl	$STDIN, BSS_STDIN

open_fd_out:

	movl	$SYS_OPEN, %eax
	
	movl	ST_ARGV_1(%ebp), %ebx
	movl	$O_CREAT_WRONLY_TRUNC, %ecx
	movl	$0666, %edx
	int	$LINUX_SYSCALL
	
store_fd_out: 

	# store the file descriptor here
#	movl	%eax, ST_FD_OUT(%ebp)
	movl	%eax, BSS_STDOUT

	###BEGIN   MAIN LOOP###

read_loop_begin: 

	###READ IN A BLOCK FROM THE INPUT FILE###
	movl	$SYS_READ, %eax

	# get the input file descriptor 
#	movl	ST_FD_IN(%ebp), %ebx
	movl	BSS_STDIN, %ebx
	
	# the location to read into
	movl	$BUFFER_DATA, %ecx
	
	# the size of the buffer
	movl	$BUFFER_SIZE, %edx

	# Size of buffer read is returned in %eax
	int	$LINUX_SYSCALL

	###EXIT IF WE'VE REACHED THE END###

	# check for end of file marker 
	cmpl $END_OF_FILE, %eax

	# if found or on error, go to the end
	jle end_loop

continue_read_loop: 

	###CONVERT THE BLOCK TO UPPER CASE###
	pushl	$BUFFER_DATA	# location of buffer 
	pushl	%eax		# size of the buffer

	popl	%eax		# get the size back
	addl	$4, %esp	# restore %esp

	###WRITE THE BLOCK OUT TO THE OUTPUT FILE###

	# size of the buffer 
	movl 	%eax, %edx
	movl	$SYS_WRITE, %eax

	# file to use
#	movl	ST_FD_OUT(%ebp), %ebx
	movl	BSS_STDOUT, %ebx

	#  location of the buffer 
	movl	$BUFFER_DATA, %ecx
	int	$LINUX_SYSCALL 

	###CONTINUE THE LOOP###
	jmp 	read_loop_begin

end_loop:
	###CLOSE THE FILES###
	# NOTE - 	we don't need to do error checking
	#		on these, because error conditions
	#		don't signify anything special here

	movl	$SYS_CLOSE, %eax
	movl	BSS_STDOUT, %ebx
	int 	$LINUX_SYSCALL

	###EXIT###

	movl	$SYS_EXIT, %eax
	movl	$0, %ebx
	int	$LINUX_SYSCALL


