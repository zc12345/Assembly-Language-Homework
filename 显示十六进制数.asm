DATAS SEGMENT
    ;此处输入数据段代码  
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
    MOV BL,3FH
    
    ;显示十六进制数
    MOV DI,2		;计数器值为4时可以表示BX
LP:	MOV CL,4
	ROL BL,CL
	MOV AL,BL
	AND AL,0FH	;分别先取高四位后取低四位
	CMP AL,0AH	;判断是否是大于0AH
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
	
    ;表示是十六进制数
    MOV AH,02
    MOV DX,'H'
    INT 21H
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


