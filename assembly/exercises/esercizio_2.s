_EXIT = 1
_PRINT = 127

.SECT.TEXT
start:
	MOV AX,(a)
	CMP (b),AX
	JBE 1f
	MOV AX,(b)
1:	CMP (c),AX
	JBE 2f
	MOV AX,(c)
2:	PUSH AX
	PUSH frmt
	PUSH _PRINT
	SYS
	MOV SP,BP
	PUSH 0
	PUSH _EXIT
	SYS

.SECT.DATA



.SECT.BSS
a: .WORD 7
b: .WORD 25
c: .WORD 3
frmt: .ASCII "Il maggiore e': %d\n\0"
