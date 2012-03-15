@ ARM/XScale Assembly language program to perform operations on a 52-byte 
@ packet. The first four header bytes are added and the sum compared to 
@ the fifth header byte; if equal, the remaining 48 bytes (written in Big-
@ Endian MSB order) are shuffled so that they are ready to be transferred 
@ on in Little Endian LSB order. The actual receipt and transfer of the 
@ packet is ignored. 
@
@ Written by Jen Hanni, Winter 2011
@ Released under the 2-clause "New BSD" license. See the LICENSE file.

.text
.global _start
_start:
.equ	NUM,48			@ Set NUM to the number of non-header bytes
	LDR R1,=HEADER		@ Initialize R1 with pointer to HEADER array
	LDR R4,=CHECKSUM	@ Initialize R4 with pointer to CHECKSUM array
	MOV R0,#3		@ Initialize R0 as loop counter for HEAD
	LDR R6,=BYTESOLD	@ Initialize R6 with pointer to BYTESOLD
	ADD R6,R6,#47		@ Initialize this pointer to BIG ENDIAN format (47)
	LDR R7,=BYTESNEW	@ Initialize R7 with pointer to BYTESNEW
	MOV R5,#NUM		@ Initialize R5 as loop counter for BYTES
	LDRB R2,[R1],#1		@ Load the first byte in HEADER array into R2

@ This is the summing of the four bytes
HEAD:	LDRB R3,[R1],#1		@ Load the next HEADER byte into R3
	ADD R2,R2,R3		@ Add what's already in R2 with the next byte,
				@ and save result in R2 to be used next time
				@ around the loop.
	SUBS R0,R0,#1		@ Decrement the loop counter by one
	BNE HEAD		@ Loop until the counter is at zero

@ This is the checksum operation
	LDRB R3,[R4]		@ Load checksum byte from R4 array into R3
	TST R3,R2		@ Compare the total byte to checksum byte
	BEQ DONE		@ If no, exit
	B BYTES			@ Else yes, move on to BE -> LE byte transfer

@ This is the packet switch from Big Endian to Little Endian
BYTES:	LDRB R11,[R6],#-1	@ Get a byte from BYTESOLD array and
				@ *decrement* the array
	STRB R11,[R7],#1	@ Store value in BYTESNEW array and
				@ *increment* by one.
				@ Do I declare an address in here for the register? 
	SUBS R5,R5,#1		@ Decrement loop counter by one.
	BNE BYTES		@ Repeat until done.
DONE: 	NOP			@ 

.data
HEADER:		.byte 0x1,0x2,0x3,0x4 	@ These four bytes must equal CHECKSUM
CHECKSUM:	.byte 0xA	@ This byte must be sum of four HEADER bytes
BYTESOLD:	.rept 48	@ This generates an array of 48 test values
				@ to be transferred to BYTESNEW.
		.byte 	0x99, 0x88, 0x77, 0x66, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x44, 0x33, 0x22, 0x11
		.endr
BYTESNEW:	.rept 48	@ This creates an empty array to receive values
		.byte 0x23	@ from BYTESOLD. I actually used 0x23 to make sure the space existed.
		.endr

.end				@ Tell assembly to stop reading this file
