	;��ģ��3
	;��ģ����ʾ���ΪFFFFH��ʮ��������
	;AX=����ʾ����λʮ��������
	EXTRN KASC:BYTE
	PUBLIC SHOWHEX
	.MODEL SMALL
	.CODE
SHOWHEX	PROC	FAR
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	
	;MOV AX,0030H
	MOV BX,AX
	MOV DI,4;������ֵΪ4ʱ���Ա�ʾBX
LP:	MOV CL,4
	ROL BX,CL
	MOV AX,BX
	OR AL,30H;�ֱ���ȡ����λ��ȡ����λ
	CMP AL,3AH;�ж��Ƿ��Ǵ���0AH
	JGE SHOW1
	MOV AH,02
	MOV DL,AL
	INT 21H
	JMP NEXT
SHOW1:
	ADD AL,07H
	ADD AL,40H
	MOV AH,02
	MOV DL,AL
	INT 21H
NEXT:
	DEC DI
	JNZ LP
    ;��ʾ��ʮ��������
    ;MOV AH,02
    ;MOV DX,'H'
    ;INT 21H
	
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
	POPF
	RET
SHOWHEX	ENDP
	END





