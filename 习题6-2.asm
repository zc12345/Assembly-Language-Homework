DATAS SEGMENT
    ;�˴��������ݶδ���  
    DATA1 DB 'IbM','$'
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
    MOV ES,AX
    CLD
    MOV DI,OFFSET DATA1
    MOV CX,4
    MOV AL,'b'
    REPNE SCASB
    JNE OVER
    DEC DI
    MOV BYTE PTR [DI],'B'
OVER:
	MOV AH,09
	MOV DX,OFFSET DATA1
    INT 21H
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
