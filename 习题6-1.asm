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
;��ʾʮ��������
SHOW MACRO NUM
LOCAL LP,SHOW1,NEXT
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
		
		ORG 0H
	COUNTNEG DB ?
	COUNTACT DB ?
	ALE1	DB	'NEGATIVE NUMBER:',0AH,0DH,'$'
	ALE2	DB	'ACTIVE NUMBER:',0AH,0DH,'$'
	;ALE3	DB	'THE BIGGEST NUMBER IN ENUM:',0AH,0DH,'$'
	STR0	DB	0AH,0DH,'$'
	BIGGEST DB ?
		ORG 60H
	NUM DB -41,+35,-62,+4,+97,+108,-86,+46,-82,+16,-73,+113,-113,+59,-105,+107,-51,+38,-91,+60
		ORG 100H
	ENUM DB 10 DUP(?)
	
		.CODE
	MAIN PROC FAR
		MOV AX,@DATA
		MOV DS,AX
		CLEARSCR
		MOV SI,OFFSET NUM
		MOV DI,20
		MOV BX,0
		MOV CX,0
		;1.�����������ĸ���
	LP:	MOV BL,[SI]
		INC SI
		ROL BL,1
		AND BL,01H
		CMP BL,01H
		JNE ACT
		INC CL
		JMP NEXT
	ACT:INC CH
	NEXT:
		DEC DI		
		JNZ LP
    	
    	MOV COUNTNEG,CL
    	MOV COUNTACT,CH
    	DISPLAY ALE1
    	SHOW COUNTNEG
    	DISPLAY STR0
    	DISPLAY ALE2
    	SHOW COUNTACT
    	DISPLAY STR0
    	;2.��NUM��ǰ10����������ENUM
    	MOV DS,AX
    	MOV ES,AX
    	CLD
    	MOV SI,OFFSET NUM
    	MOV DI,OFFSET ENUM
    	MOV CX,10
    	REP MOVSB
    	
    	;3.����ENUM�е����ֵ
    	MOV CX,10
    	MOV SI,OFFSET ENUM
    	MOV AL,0
    BACK:
    	MOV AL,[SI]
    	CMP AL,[SI]
    	JLE NEXT2
    	MOV AL,[SI]
    	NEXT2:
    	INC SI
    	DEC CX
    	JNZ BACK
    	
    	MOV BIGGEST,AL
    	;DISPLAY ALE3
    	SHOW BIGGEST
    	
    	
		MOV AH,4CH
		INT 21H
	MAIN ENDP
		END MAIN




