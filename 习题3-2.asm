DATAS SEGMENT
    ;�˴��������ݶδ���  
    ORG 10H
    NUM DW 00FFH
    ORG 20H
    SUM DW ?
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

;ͳ��16λ���С�0���ĸ�����
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    MOV AX,NUM			;AX�洢����ʮ��λ��������
    MOV BX,16			;BX��ѭ��������
    MOV CX,0			;CX���ʮ��λ���������е�0�ĸ���
LP: MOV	DX,AX
	AND DX,01H
	JNZ	NEXT
	INC CX
	NEXT:
	ROR AX,1
	DEC BX
	JNZ LP    
        
    MOV SUM,CX
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



