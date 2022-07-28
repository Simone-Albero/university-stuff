_EXIT = 1
_PRINTF = 127

.SECT .TEXT
start:
	PUSH end1 !secondo parametro
	PUSH string !primo parametro
	CALL LUN
	MOV SP,BP
	PUSH (x) !secondo parametro
	PUSH string !primo parametro
	CALL OCC
	MOV SP,BP
	PUSH 0
	PUSH _EXIT
	SYS

LUN:
	PUSH BP
	MOV BP,SP
	
	MOV AX,6(BP)
	MOV BX,4(BP)
	SUB AX,BX
	
	PUSH AX
	PUSH frm1
	PUSH _PRINTF
	SYS
	
	MOV SP,BP
	POP BP
	RET

OCC:
	PUSH BP
	MOV BP,SP
	
	MOV DI, 4(BP)
	MOVB AL, 6(BP)
	MOV CX, end1-string
	MOV BX,0
1:	SCASB
	JNE 2f	
	ADD BX, 1
2:	LOOP 1b
	
	PUSH BX
	PUSH AX
	PUSH frm2
	PUSH _PRINTF
	SYS
	
	MOV SP,BP
	POP BP
	RET


.SECT .DATA

string: .ASCII "ramarro"
end1: .SPACE 1
x: .ASCII 'r'
end2: .SPACE 1
frm1: .ASCII "La lunghezza della stringa e': %d\n\0"
frm2: .ASCII "Il numero si occorrenze del carattere '%c' e': %d\n\0"
