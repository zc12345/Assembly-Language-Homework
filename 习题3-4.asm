DATAS SEGMENT
    ;此处输入数据段代码 
    ORG 10H
    RESULT DW ? 
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

;求n！（n=8）

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
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



