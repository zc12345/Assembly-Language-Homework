DATAS SEGMENT
    ;此处输入数据段代码 
     hcood  dw	50;原点行坐标
     lcood	dw	100;原点列坐标
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

;==============================================
;画出一行像素行
;传入值:像素点起始位置(HA,LA),行长度LEN,颜色COL
LINE MACRO HA,LA,LEN,COL
LOCAL LINELP
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	MOV DX,HA;DX像素行
	MOV CX,LA;CX像素列
	MOV BX,LEN;BX一行像素数计数器
LINELP:	
	MOV AH,0CH;AH=0CH写像素
	MOV AL,COL;AL颜色值
	INT 10H
	INC CX
	DEC BX
	JNZ LINELP
	
	POP DX
	POP CX
	POP BX
	POP AX
	POPF
ENDM
;============================================

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    push ax
    push cx
    push dx
    push di
    push si
    
    mov ax,000dh;320*200  彩色图形(EGA)
    int 10h
    mov dx,hcood
    mov cx,lcood
;我机===================================
;机头部分========================================
	ADD CX,7
	LINE DX,CX,3,03H
	
	MOV DI,2
PLANELP2:	
	INC DX
	MOV CX,LCOOD
	ADD CX,7
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,1,02H
	ADD CX,1
	LINE DX,CX,1,0AH
	DEC DI
	JNZ PLANELP2
	
	MOV DI,3
PLANELP1:	
	INC DX
	MOV CX,LCOOD
	ADD CX,7
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,1,02H
	ADD CX,1
	LINE DX,CX,1,0AH
	DEC DI
	JNZ PLANELP1
;机身部分================================

	INC DX
	MOV CX,LCOOD
	ADD CX,6
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,3,02H
	ADD CX,3
	LINE DX,CX,1,0AH	
	
	INC DX
	MOV CX,LCOOD
	ADD CX,6
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,3,02H
	ADD CX,3
	LINE DX,CX,1,0AH
	
	INC DX
	MOV CX,LCOOD
	ADD CX,5
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,5,02H
	ADD CX,5
	LINE DX,CX,1,0AH
	
	INC DX
	MOV CX,LCOOD
	ADD CX,4
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,1,02H
	ADD CX,1
	LINE DX,CX,5,07H
	ADD CX,5
	LINE DX,CX,1,02H
	ADD CX,1
	LINE DX,CX,1,0AH
	
	INC DX
	MOV CX,LCOOD
	ADD CX,3
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,2,02H
	ADD CX,2
	LINE DX,CX,5,08H
	ADD CX,5
	LINE DX,CX,2,02H
	ADD CX,2
	LINE DX,CX,1,0AH
	
	INC DX
	MOV CX,LCOOD
	ADD CX,2
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,3,02H
	ADD CX,3
	LINE DX,CX,5,07H
	ADD CX,5
	LINE DX,CX,3,02H
	ADD CX,3
	LINE DX,CX,1,0AH
	
	INC DX
	MOV CX,LCOOD
	INC CX
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,13,02H
	ADD CX,13
	LINE DX,CX,1,0AH
	INC DX
	MOV CX,LCOOD
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,15,02H
	ADD CX,15
	LINE DX,CX,1,0AH
	
	INC DX
	MOV CX,LCOOD
	LINE DX,CX,3,0AH
	ADD CX,3
	LINE DX,CX,1,02H
	INC CX
	LINE DX,CX,4,0AH
	ADD CX,4
	LINE DX,CX,1,02H
	INC CX
	LINE DX,CX,4,0AH
	ADD CX,4
	LINE DX,CX,1,02H
	INC CX
	LINE DX,CX,3,0AH
	
;机尾部分===============================
	
	INC DX
	MOV CX,LCOOD
	ADD CX,7
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,1,02H
	INC CX
	LINE DX,CX,1,0AH
	
	INC DX
	MOV CX,LCOOD
	ADD CX,6
	LINE DX,CX,5,02H
	
	INC DX
	MOV CX,LCOOD
	ADD CX,6
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,3,02H
	ADD CX,3
	LINE DX,CX,1,0AH
	
	INC DX
	MOV CX,LCOOD
	ADD CX,7
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,1,02H
	INC CX
	LINE DX,CX,1,0AH
	
	
	LINE 10,20,20,0ah;浅绿
	LINE 20,20,20,0FFH
	LINE 30,20,20,0CH
	LINE 40,20,20,0DH
	LINE 50,20,20,0EH
	LINE 60,20,20,0FH
	LINE 70,20,20,01H
	LINE 80,20,20,02H;深绿
    LINE 90,20,20,03H
    LINE 100,20,20,04H
    LINE 110,20,20,05H
    LINE 120,20,20,06H
    LINE 130,20,20,07H
    LINE 140,20,20,08H
    LINE 150,20,20,09H
    
	pop si
    pop di
    pop dx
    pop cx
    pop ax
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




