;--------------
;�����Ļ�ĺ�
CLEARSCR MACRO
	MOV AX,0600H;
	MOV BH,07
	MOV CX,0
	MOV DX,184FH
	INT 10H
	ENDM
;--------------
;��ʾʮ��������
SHOW MACRO NUM
	MOV BL,NUM
    ;��ʾʮ��������
    MOV DI,2;������ֵΪ4ʱ���Ա�ʾBX
LP:	MOV CL,4
	ROL BL,CL
	MOV AL,BL
	AND AL,0FH;�ֱ���ȡ����λ��ȡ����λ
	CMP AL,0AH;�ж��Ƿ��Ǵ���0AH
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
    ;��ʾ��ʮ��������
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
