DATAS SEGMENT
	ORG	10H
DATA1	DB	7
DATA2	DB	0
QOUT	DB	?
REMAIN	DB	?
	ORG 20H
NUM	DB	20	DUP(?);
	ORG 30H
SUM	DW	?
    ;�˴��������ݶδ���  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;100����7�ı���
    MOV DX,100
    MOV BX,OFFSET NUM
LP:    
    MOV AL,DL 
    SUB AH,AH
    DIV DATA1
    MOV QOUT,AL;AL������
    MOV REMAIN,AH;DH��������
    CMP DATA2,AH
    JNE NEXT
    MOV [BX],DL
    ADD SUM,DX
    INC BX
NEXT:DEC DX
	JNZ LP         
    ;�˴��������δ���
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START





