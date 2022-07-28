_EXIT = 1
_PRINT = 127

.SECT.TXT
start:
	PUSH (num)
	CALL IS_PRIMO
	MOV SP,BP
	PUSH 0
	PUSH _EXIT
	SYS

IS_PRIMO:
	PUSH BP
	MOV BP,SP
	MOV BX, 4(BP)
	MOV CX, BX
	DEC CX

1:	CMP CX,1
	JLE 2f
	MOV AX, BX
	DIV BX
	CMP DX,0
	JE 3f
	DEC CX
	JMP 1b

2:	PUSH BX
	PUSH frmt1
	PUSH _PRINT
	SYS
	JMP 4f

3:	PUSH AX
	PUSH frmt2
	PUSH _PRINT
	SYS

4:	MOV SP,BP
	POP BP
	RET



.SECT.DATA
num: .WORD 11
frmt1: .ASCII "Il numero '%d' e' primo!\n\0"
frmt2: .ASCII "Il numero '%d' non e' primo!\n\0"



.SECT.BSS
