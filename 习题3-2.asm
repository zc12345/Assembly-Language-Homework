DATAS SEGMENT
    ;此处输入数据段代码  
    ORG 10H
    NUM DW 00FFH
    ORG 20H
    SUM DW ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

;统计16位字中“0”的个数。
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    MOV AX,NUM			;AX存储的是十六位二进制数
    MOV BX,16			;BX是循环计数器
    MOV CX,0			;CX标记十六位二进制数中的0的个数
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



