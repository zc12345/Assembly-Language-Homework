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

		.MODEL SMALL
		.STACK 64
		.DATA
	STR0 DB 'F1 EDIT',0AH,'F2 MASM',0AH,'F3 LINK',0AH,'F4 DEBUG',0AH,'$'
	STR1 DB 'PRESS F1 KEY,F1 EDIT$'
	STR2 DB 'PRESS F2 KEY,F2 MASM$'
	STR3 DB 'PRESS F3 KEY,F3 LINK$'
	STR4 DB 'PRESS F4 KEY,F4 DEBUG$'
		.CODE
	MAIN PROC FAR
		MOV AX,@DATA
		MOV DS,AX
		CLEARSCR
		DISPLAY STR0
		MOV AH,0
		INT 16H
		CMP AL,3BH
		JE JP1
		CMP AL,3CH
		JE JP2
		CMP AL,3DH
		JE JP3
		CMP AL,3EH
		JE JP4
	JP1:	DISPLAY STR1
			JMP EXIT
	JP2:	DISPLAY STR2
			JMP EXIT
	JP3:	DISPLAY STR3
			JMP EXIT
	JP4:	DISPLAY STR4
			JMP EXIT
		
	EXIT:	
		MOV AH,4CH
		INT 21H
	MAIN ENDP
		END MAIN

