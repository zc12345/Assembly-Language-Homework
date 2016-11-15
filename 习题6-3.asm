DATAS SEGMENT
    ;此处输入数据段代码  
    SQRT_TABL DB 0,1,4,9,16,25,36,49,64,81
    ;DOUB_TABL DB 0,2,4,6,8,10,12,14,16,18
    ALE DB 'CHOOSE A NUMBER FROM 0-9',0AH,0DH,'$'
    RES DB 'THE RESULT OF Y=X^2+2*X+5 IS ',0AH,0DH,'$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    ;提示语句
    MOV AH,09
    MOV DX,OFFSET ALE
    INT 21H
    
    ;获取0-9的数字
    MOV AH,0
    INT 16H
    SUB AL,30H
    
    ;MOV AL,5
    MOV CL,AL
    ADD CL,CL
    MOV BX,OFFSET SQRT_TABL
    XLAT
    ADD CL,AL
    ADD CL,5
    
    ;提示输出
    MOV AH,09
    MOV DX,OFFSET RES
    INT 21H
    
    MOV BL,CL
    
    ;显示十六进制数
    MOV DI,2
LP:	MOV CL,4
	ROL BL,CL
	MOV AL,BL
	AND AL,0FH
	CMP AL,0AH
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
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
