DATAS SEGMENT
    ;�˴��������ݶδ��� 
    ORG 0H
NUM	DW	78,92,85,62,45,90,66,74,88,100 
	ORG	20H
COUNT	DW 10
SUM	DW	?
AVE	DW	?

DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    MOV BX,OFFSET NUM;BXָ������
    MOV CX,COUNT
    SUB AX,AX
LP:	;���
	ADD AX,[BX]
	ADD BX,2
	DEC CX
	JNZ LP
	;���ֵ
	MOV SUM,AX 
	SUB DX,DX
	MOV CX,COUNT
	DIV CX
	MOV AVE,AX;�̼Ĵ���AX���棬�����Ĵ���DX����
	
	;����ð������
	MOV SI,COUNT
	XOR DI,0
LP2:INC DI
	DEC SI
	MOV CX,SI
	MOV BX,OFFSET NUM
	
LP1:MOV AL,[BX]
	CMP AX,[BX+2]
	JAE	NEXT;�����򲻽���
    XCHG AL,[BX+2]
    MOV	[BX],AL
    NEXT:
    ADD BX,2
    ;CMP BX,20
    ;JNE LP1
    LOOP LP1
    
    CMP SI,1
    JNE LP2
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



