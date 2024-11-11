_EXIT = 1
_PRINT = 127

.SECT.TEXT
start: 
	MOV CX, end-vec1
	SHR CX,1
	PUSH vec2
	PUSH vec1
	CALL COPY	
	MOV SP,BP
	MOV CX, end-vec1
	SHR CX,1	
	PUSH vec2
	PUSH vec1
	CALL CHECK
	MOV SP,BP
	PUSH 0
	PUSH _EXIT
	SYS
	
COPY: 
	PUSH BP
	MOV BP,SP
	MOV SI,4(BP)
	MOV DI,6(BP)
	REP MOVSW
	MOV SP,BP
	POP BP
	RET
	
CHECK:
	PUSH BP
	MOV BP,SP
	MOV SI,4(BP)
	MOV DI,6(BP)
1:	CMPSW
	JNE 2f
	LOOP 1b
	PUSH frmt1
	PUSH _PRINT
	SYS
	JMP 3f
	
2:	PUSH frmt2
	PUSH _PRINT
	SYS

3:	MOV SP,BP
	POP BP
	RET
	
	
.SECT.DATA
frmt1: .ASCII "I vettori sono uguali!\n\0"
frmt2: .ASCII "I vettori sono diversi\n\0"
frmt3: .ASCII "%d\n\0"
vec1: .WORD 2,3,4,5,6,7
end: .SPACE 1
vec2: 

.SECT.BSS
