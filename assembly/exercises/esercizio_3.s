_EXIT = 1
_PRINT = 127

.SECT.TEXT
start:
	MOV CX, end1-vec1
	SHR CX,1
	MOV BX, end2-vec2
	SHR BX,1
	CMP CX,BX
	JNE 2f
	MOV BX, vec1
	MOV SI,0
	
1:	MOV AX,(BX)(SI)
	MOV BX, vec2
	CMP AX,(BX)(SI)
	JNE 2f
	ADD SI,2
	LOOP 1b
	
	!vettori uguali
	PUSH frmt1
	PUSH _PRINT
	SYS
	JMP 3f
	
	!vettori diversi
2:	PUSH frmt2
	PUSH _PRINT
	SYS
	
3:	MOV SP,BP
	PUSH 0
	PUSH _EXIT
	SYS
	

.SECT.DATA
vec1: .WORD 2,3,5,6,7
end1: .SPACE 1
vec2: .WORD 2,3,5,6,8
end2: .SPACE 1
frmt1: .ASCII "I vettori sono uguali!\n\0"
frmt2: .ASCII "I vettori sono diversi!\n\0"

.SECT.BSS
