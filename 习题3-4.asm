DATAS SEGMENT
    ;�˴��������ݶδ��� 
    ORG 10H
    RESULT DW ? 
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

;��n����n=8��

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    MOV BX,8
    MOV AX,1
LP: MOV DX,BX
	MUL DX
	DEC BX
	JNZ LP   
    
    MOV RESULT,DX
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



