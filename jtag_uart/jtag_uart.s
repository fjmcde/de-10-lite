/*******************************************************
*	Program to read character data from the DE-10 Lite
*	JTAG UART data register
*******************************************************/

.text

/* Assembler constants */
.equ JTAG_BASE_ADDR,	0xff201000	# base address of the JTAG UART data register
.equ BIT15,				0x8000		# 0b1000 0000 0000 0000
.equ LSByte,			0xff		# 0b1111 1111

/* Code entry point (simulator) */
.global _start
_start:
	movia	r4, JTAG_BASE_ADDR	# point r8 to the JTAG UART data register

while_loop:
	call getChar	# retreieve a character
	br while_loop	# infinite loop


/*******************************************************
*	Subroutine to retreive a character from the data
*	byte in the JTAG UART data register
*******************************************************/
.global getChar
getChar:
	ldwio	r9, (r4)				# load word from JTAG UART; store in r9
	andi	r10, r9, BIT15			# check for valid data in RVALID register of JTAG UART
	beq		r10, zero, noChar		# if RVALID == 0 (no data) then conditionally return
	andi	r2, r9, LSByte			# get data from first byte of word
	break							# debug breakpoint
	ret

# Label to conditionally return from getChar when no data is on the READ FIFO stack 
noChar:
	ret	# pop call stack (to avoid a stack overflow)

.end
