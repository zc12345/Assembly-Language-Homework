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
;��ʾ�ַ����ĺ�
DISPLAY MACRO STRING
	MOV AH,09
	MOV DX,OFFSET STRING
	INT 21H
	ENDM
;--------------
;���ù��λ��
CURSOR MACRO ROW,COLUMN
	MOV AH,02
	MOV BH,00
	MOV DH,ROW
	MOV DL,COLUMN
	INT 10H
	ENDM
;--------------

		.MODEL SMALL
		.STACK 64
		.DATA
	STR1 DB 'Assembly Language, Design, and Interfacing$'
		.CODE
	MAIN PROC FAR
		MOV AX,@DATA
		MOV DS,AX
		CLEARSCR
		CURSOR 8,14
		DISPLAY STR1
		
		MOV AH,4CH
		INT 21H
	MAIN ENDP
		END MAIN


