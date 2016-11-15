;--------------
;清除屏幕的宏
CLEARSCR MACRO
	MOV AX,0600H;
	MOV BH,07
	MOV CX,0
	MOV DX,184FH
	INT 10H
	ENDM
;--------------
;显示十六进制数
SHOW MACRO NUM
	MOV BL,NUM
    ;显示十六进制数
    MOV DI,2;计数器值为4时可以表示BX
LP:	MOV CL,4
	ROL BL,CL
	MOV AL,BL
	AND AL,0FH;分别先取高四位后取低四位
	CMP AL,0AH;判断是否是大于0AH
	JGE SHOW1
	ADD AL,30H
	MOV AH,02
	MOV DL,AL
	INT 21H
	JMP NEXT
SHOW1:
	SUB AL,9
	ADD AL,40H
	MOV AH,02
	MOV DL,AL
	INT 21H
NEXT:
	DEC DI
	JNZ LP
    ;表示是十六进制数
    MOV AH,02
    MOV DX,'H'
    INT 21H
    
    ENDM
;-------------
		.MODEL SMALL
		.STACK 64
		.DATA
		.CODE
	MAIN PROC FAR
		MOV AX,@DATA
		MOV DS,AX
		CLEARSCR
		MOV AH,0
		INT 16H
		SUB AL,20H
		SHOW AL
		
    
		MOV AH,4CH
		INT 21H
	MAIN ENDP
		END MAIN
