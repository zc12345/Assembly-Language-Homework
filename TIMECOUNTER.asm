DATAS SEGMENT
    ;�˴��������ݶδ��� 
    TIME	DB 'time:$'
    DBUFFER  DB 8 DUP(':'),'$'
    TIME2	DB	'00:00:00$'
;    DBUFFER1 DB 8 DUP(':'),'$'
;    DBUFFER2 DB 8 DUP(':'),'$'
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS
;-------------------------------------
;���ù��λ��(HA,LI)
CURSOR	MACRO	HA,LI
	MOV AH,02
	MOV BH,0
	MOV DH,HA
	MOV DL,LI
	INT 10H
	ENDM
;------------------------------------
;ʱ����ֵת����ASCII���ַ��ӳ���
BCDASC MACRO DBUFFERs 
	PUSH BX
	PUSH AX
	CBW
	MOV BL,10
	DIV BL
	OR  AL,30H
	MOV DBUFFERs[SI],AL
	INC SI
	OR  AH,30H
	MOV DBUFFERs[SI],AH
	INC SI
	POP AX
	POP BX
	ENDM
;--------------------------------------
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    MOV AH,09
    MOV DX,OFFSET TIME
    INT 21H
    
    ;��ʱ��ֵ��ʼ��Ϊ0������ֵAL=0��ʾ���óɹ�
    ;MOV AH,2DH
    ;MOV CX,0000H
    ;MOV DX,0000H
    ;INT 21H
    ;ADD AL,30H
    ;MOV AH,02
    ;MOV DL,AL 
    ;INT 21H
    MOV DI,200
 LP:   
    CURSOR 00,05
    
    CALL DELAY
    CALL DELAY
    MOV SI,0
    MOV AH,2CH
    INT 21H
    MOV DBUFFER[SI],0
    INC SI
    MOV DBUFFER[SI],CL
    INC SI
    INC SI
    MOV DBUFFER[SI],0
    INC SI
    MOV DBUFFER[SI],DH
    INC SI
    INC SI
    MOV DBUFFER[SI],0
    INC SI
    MOV DBUFFER[SI],DL
    
    MOV SI,0
    MOV AL,DBUFFER[1]
    BCDASC TIME2
    INC SI
    MOV AL,DBUFFER[4]
    BCDASC TIME2
    INC SI
    MOV AL,DBUFFER[7]
    BCDASC TIME2
    
    MOV AH,09
    MOV DX,OFFSET TIME2
    INT 21H
    
    DEC DI
    JNZ LP
    
    MOV AH,4CH
    INT 21H
delay proc near;��ʱ�ӳ���
	push cx
	push dx
	mov dx,1000
dl1:mov cx,1000
dl2:loop dl2
	dec dx
	jnz dl1
	pop dx
	pop cx
	ret
delay endp
CODES ENDS
    END START



