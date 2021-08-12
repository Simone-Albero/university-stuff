_EXIT = 1
_PRINT = 127


.SECT.TEXT
start:
	PUSH string
	CALL PAL	
	MOV SP,BP
	PUSH 0
	PUSH _EXIT
	SYS	

PAL:	
	PUSH BP
	MOV BP,SP
	MOV BX, 4(BP)
	MOV CX, end-string
	SUB CX,1
	MOV SI, 0
	MOV DI, CX
	
1:	CMP DI,SI	
	JLE 2f
	MOVB AL, (BX)(SI)
	CMPB AL, (BX)(DI)	
	JNE 3f
	ADD SI,1
	SUB DI,1
	JMP 1b
	
2:	MOV SP,BP
	PUSH frmt1
	PUSH _PRINT
	SYS
	JMP 4f

3:	MOV SP,BP
	PUSH frmt2
	PUSH _PRINT
	SYS

4:	MOV SP,BP
	POP BP
	RET	



.SECT.DATA


.SECT.BSS
string: .ASCII "anna"
end: .SPACE 1
frmt1: .ASCII "La stringa e' palindroma!\n\0"
frmt2: .ASCII "la stringa non e' palindroma!\n\0"
