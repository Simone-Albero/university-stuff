_EXIT = 1
_PRINT = 127

.SECT.TEXT
start:
	MOV CX, end-vec
	SHR CX,1
	MOV SI, CX-1 
	MOV BX,vec

1:	MOV AX,(SI)(BX) 	
	DEC SI
	PUSH AX
	PUSH _PRINT
	SYS
	MOV SP,BP
	LOOP 1f

	PUSH 0
	PUSH _EXIT
	SYS

.SECT.DATA
vec: .WORD 3,4,5,6,7
end: .SPACE 1
frmt: .ASCII "%d\0"

.SECT.BSS
