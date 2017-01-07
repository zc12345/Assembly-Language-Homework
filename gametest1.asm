DATAS SEGMENT
	score dw 0
	score2 dw 30h,'$'
	DBUFFER DB 8 DUP (':'),'$'
	DBUFFER2 DB 8 DUP (':'),'$'
	TIME DB '00:00:00','$';8 DUP (':'),'$'
	PROMPT1 DB 'score:$'
	PROMPT2 DB 'time:$'
	m4 db ?
	plane_x dw ?
	plane_y dw ?
	left_bound db 5
	right_bound db 35
	;ABOUT AUTOMOVE
	AUTOMOVE0 DB 6,9,12,15,18,21,24,27
	AUTOMOVE1 DW 6 
	AUTOMOVE2 DW 9
	AUTOMOVE3 DW 11
	AUTOMOVE4 DW 13 
	AUTOMOVE5 DW 15
	AUTOMOVE6 DW 17
	AUTOMOVE7 DW 20
	AUTOMOVE8 DW 22
	
DATAS ENDS

STACKS SEGMENT
STACKS ENDS
;============================================
;清屏宏定义
clear_screen macro h1,l1,h2,l2 
	mov ah,06h
	mov al,00h
	mov bh,07h
	mov ch,h1
	mov cl,l1
	mov dh,h2
	mov dl,l2
	int 10h
	mov ah,02h	
	mov bh,00h
	mov dh,00h	
	mov dl,00h
	int 10h
	endm
;============================================
;时间数值转换成ASCII码字符子程序
BCDASC MACRO DBUFFERs 
	PUSH BX
	PUSH AX
	CBW
	MOV BL,10
	DIV BL
	OR  AL,30H
	MOV DBUFFERs[SI],AL
	INC SI
	OR  AH,30H
	MOV DBUFFERs[SI],AH
	INC SI
	POP AX
	POP BX
	ENDM
;==============================================
;刷新，将之前的靶子的列坐标自增
refreshm macro
local delayuselp,refreshlp
;调用延时子程序，保证隔一段可观测时间移动一次
	PUSH CX
	MOV CX,100
DELAYUSELP:
	call delay
	DEC CX
	JNZ DELAYUSELP
	POP CX
	;autorefresh
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	PUSH SI
	;先清空之前的一列靶子
	TARGET ' '
	MOV SI,8
	MOV DI,OFFSET AUTOMOVE0
REFRESHLP:
	MOV DL,[DI]
	INC DL
	MOV [DI],DL
	;CMP DX,right_bound
	;JA OVER
	INC DI
	DEC SI
	JNZ REFRESHLP
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
	POPF
endm
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
;========================================================
;清除飞机的宏
clearplane macro hcood,lcood
local clearlp
	pushf
	push cx
	push dx
	push di
    mov dx,hcood
    mov cx,lcood

	;擦除飞机
	mov di,19
clearlp:
	line dx,cx,17,0h
	inc dx
	dec di
	jnz clearlp
	pop di
	pop dx
	pop cx
	popf
endm
;========================================================
;绘制敌方飞机
TARGET MACRO TARGETLOOK
LOCAL INPUT,NEXT,SHOW
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	PUSH SI
	
	MOV SI,8
	MOV DI,OFFSET AUTOMOVE0
INPUT:
	MOV DL,[DI]
	MOV DH,0AH
	MOV AH,2
	INT 10H
	;超过限界不再显示
	CMP DL,right_bound
	JLE NEXT
	MOV AL,' '
	JMP SHOW
NEXT:
	MOV AL,TARGETLOOK
SHOW:	
	MOV BH,0
	MOV BL,084H
	MOV CX,1
	MOV AH,09H
	INT 10H
	INC DI
	DEC SI
	JNZ INPUT
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
	POPF
ENDM
;========================================================
;画出我方飞机的宏
myplane macro hcood,lcood
	local planelp1,planelp2
	push ax
    push cx
    push dx
    push di
    push si
    
    ;mov ax,000dh;320*200  彩色图形(EGA)
    ;int 10h
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
	
	pop si
    pop di
    pop dx
    pop cx
    pop ax
    endm
;========================================================

CODES SEGMENT
	ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	MOV AX,DATAS
	MOV DS,AX
	;清屏宏调用
    
    ;画飞机
	clear_screen 00,00,24,79 
	mov ax,0013h
	int 10h		;320*200 255色图形
	mov plane_x,140
	mov plane_y,176
	myplane	plane_y,plane_x
	
	mov ah,0EH	;显示字符
	mov al,03h	;AL=字号
	int 10h
	
	CALL COUNTSCORE
	;画计分板
	CALL COUNTTIME
	;画计时板
	JMP UNREFRESH
refresh:
	;调用refreshm宏，自增靶子的列坐标
	;refreshm
	;宏展开===================================
	PUSH CX
	MOV CX,100
DELAYUSELP:
	call delay
	DEC CX
	JNZ DELAYUSELP
	POP CX
	;autorefresh
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	PUSH SI
	;先清空之前的一列靶子
	TARGET ' '
	MOV SI,8
	MOV DI,OFFSET AUTOMOVE0
REFRESHLP:
	MOV DL,[DI]
	INC DL
	MOV [DI],DL
	;边界限定
	;如果最左边的元素的列超出限定则退出
	CMP SI,8
	JNE BOUNDTEST
	CMP DL,right_bound
	JA OVER
	
BOUNDTEST:
	INC DI
	DEC SI
	JNZ REFRESHLP
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
	POPF
	;宏展开结束===========================
UNREFRESH:	
	;没有刷新，在第一次运行的时候根据初始值绘制靶子
	TARGET 01H
	;画敌机
refreshnext:
	mov ah,02h ;图像输入完后，设置射击位置的光标
	mov bh,00h
	mov dh,22	;起始位置光标行
	mov dl,18	;起始位置光标列
	int 10h
	;====================================
	;图像格式的飞机
	mov plane_x,140
	mov plane_y,176
	
	myplane	plane_y,plane_x
	jmp in_key
		
in_key:			;从键盘输入字符
	;push dx
	;mov ah,06h 	;直接控制台I/O
	;mov dl,0ffh	;DL=0FF(输入)，DL=字符(输出)
	;int 21h
	;pop dx
	mov ah,01h
	int 16h
	
	jz refresh	;ZF=1键盘缓冲区为空时
				;缓冲区不为空，即检测到按键的时候
	mov ah,00h	;读取按键值，AH=扫描码，AL=ASCII码
	int 16h
	cmp al,'q' 	;如果键入Q，则退出
	je over
	cmp al," " 	;如果键入SPACE，则对应位的图形消失
	je disappear
	
move_l:
	cmp al,'a' 	; 按左键(扫描码)实现图像随光标向左移动
	jnz move_r
	;像素点表示我机
	clearplane plane_y,plane_x 
	sub plane_x,8
	myplane plane_y,plane_x
	dec dl
	mov ah,02h
	int 10h
	;检查是否出现越界情况
	cmp dl,left_bound
	jge movelnext
	;越界的时候
	inc dl
	mov ah,02h
	int 10h
	;像素点表示我机
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x
	;没有越界
movelnext:	
	jmp in_key
		
move_r:
	cmp al,'d' ;按右键（扫描码）实现图像随光标向右移动
	jnz in_key
	;像素点表示我机
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x	
	inc dl
	mov ah,02h
	int 10h
	;检查是否越界
	cmp dl,right_bound
	jle movernext
	;如果出现越界
	dec dl
	mov ah,02h
	int 10h
	;像素点表示我机
	clearplane plane_y,plane_x
	sub plane_x,8
	myplane plane_y,plane_x
	;没有越界
movernext:	
	jmp timer
;	jmp in_key
	
disappear:
	push ax
	;设置光标位置
	mov dh,21
	mov ah,02h
	mov bh,00h
	int 10h
	;显示子弹
	mov ah,09h
	mov al,07h
	mov bl,0fh
	mov cx,1
	int 10h
	;设置光标位置
	sub dh,1
con1:
	mov ah,02h
	mov bh,00h
	int 10h
	
	;显示子弹
	mov ah,09h
	mov al,07h
	mov bl,0fh
	mov cx,1
	int 10h
	;调用延时子程序
	call delay
	;设置光标位置
	inc dh
	mov ah,02h
	mov bh,00h
	int 10h
	
	;清除子弹
	mov ah,09h
	mov al,0
	mov bl,0fh
	mov cx,1
	int 10h
	sub dh,2
	cmp dh,0ah
	ja con1
	
	;清除最后一颗子弹
	mov ah,02h
	mov bh,00h
	mov dh,0bh
	int 10h
	mov ah,09h
	mov al,0
	mov bl,0fh
	mov cx,1
	int 10h
	pop ax
	
	;将光标设置到图像位置
	mov ah,02h
	mov bh,00h
	mov dh,0ah
	int 10h
	;读取光标处字符
	mov ah,08h
	mov bh,00
	int 10h
	mov m4,al
next2:
	;将射击到的位置用空格填补
	mov ah,09h
	mov al,' '
	mov dh,0ah
	mov cx,1
	int 10h
	cmp m4,01h	;判断该位置是否有敌机
	jnz next4
	add score,1	;分数加1
	CALL SHOWSCORE
	;显示分数
timer:
	call timer1
next4:
	;射击后将光标回到原射击位置
	mov ah,02h 
	mov bh,00h
	mov dh,22d
	int 10h
	
	cmp score,8
	JNE IN_KEY
	;全部打中之后显示分数	
	clear_screen 0,0,24,79
	call showscore
	JMP WINOVER
over:	
	clear_screen 0,0,24,79
	call showscore
WINOVER:
	MOV AH,4CH
	INT 21H
;====================================================================
;计时器====================================
timer1 proc far
	
	PUSH SI
	PUSH BX
	PUSH AX
	PUSH CX
	PUSH DX
	;获取时间显示光标位置
	MOV AH,02
	MOV BH,00
	MOV DH,02
	MOV DL,42H
	INT 10H

	MOV SI,0
	;获取打中的时间
	MOV AH,2CH 
	INT 21H
	MOV AL,CH
	MOV DBUFFER2[SI],0
	INC SI
	MOV DBUFFER2[SI],AL
	INC SI
	INC SI
	MOV AL,CL
	MOV DBUFFER2[SI],0
	INC SI
	MOV DBUFFER2[SI],AL
	INC SI
	INC SI
	MOV AL,DH
	mov DBUFFER2[SI],0
	INC SI
	MOV DBUFFER2[SI],AL
	;计算时间差
	MOV AL,DBUFFER[1]
	SUB DBUFFER2[1],AL
	MOV AL,DBUFFER[4]
	CMP DBUFFER2[4],AL
	JNB N1
	ADD DBUFFER2[4],60
N1: MOV AH,DBUFFER[7]
	CMP DBUFFER2[7],AH
	JA  S1
	JMP S2
S1: SUB DBUFFER2[4],AL
	JMP CM
S2:
	SUB DBUFFER2[4],AL
	SUB DBUFFER2[4],1
CM: MOV AL,DBUFFER[7]
	CMP DBUFFER2[7],AL
	JNB N2
	ADD DBUFFER2[7],60
N2: SUB DBUFFER2[7],AL
	;显示时间
	mov ah,09h
	mov dx,offset PROMPT2
	int 21h
	MOV SI,0
	MOV AL,DBUFFER2[1]
	BCDASC TIME
	INC SI
	MOV AL,DBUFFER2[4]
	BCDASC TIME
	INC SI
	MOV AL,DBUFFER2[7]
	BCDASC TIME
	MOV AH,09
	MOV DX,OFFSET TIME
	INT 21H
	POP DX
	POP CX
	POP AX
	POP BX
	POP SI
timer1 endp
;计分板	===================================
COUNTSCORE PROC FAR
	;画计分板
	push ax
	push bx
	push dx
	mov ah,02h;将光标设置到score位置
	mov bh,00h
	mov dh,02H	;score光标位置行数
	mov dl,02h	;score光标位置列数
	int 10h
	mov ah,09h
	mov dx,offset PROMPT1;显示分数 'score:$'
	int 21h
	mov ah,09h
	mov dx,offset score2;分数具体值
	int 21h
	pop dx
	pop bx
	pop ax
	RET
COUNTSCORE ENDP	
;计时板=====================================
COUNTTIME PROC FAR
	PUSH SI
	PUSH BX
	PUSH AX
	PUSH DX
	;设置时间位置
	MOV AH,02
	MOV BH,00	
	MOV DH,02	;time光标位置行数
	MOV DL,42H	;time光标位置列数
	INT 10H
	
	;显示时间
	mov ah,09h
	mov dx,offset PROMPT2;'time$'
	int 21h
	;获取开始的时间
	MOV SI,0
	MOV AH,2CH	;取时间，CH:CL=时:分，DH:DL=秒:1/100秒
	INT 21H
	MOV AL,CH
	mov DBUFFER[SI],0
	INC SI
	MOV DBUFFER[SI],AL
	INC SI
	INC SI
	MOV AL,CL
	mov DBUFFER[SI],0
	INC SI
	MOV DBUFFER[SI],AL
	INC SI
	INC SI
	MOV AL,DH
	mov DBUFFER[SI],0
	INC SI
	MOV DBUFFER[SI],AL
	MOV AH,09
	MOV DX,OFFSET TIME
	INT 21H
	POP DX
	POP AX
	POP BX
	POP SI
	RET
COUNTTIME	ENDP
;显示分数================================
SHOWSCORE PROC FAR	
	push ax
	push bx
	push dx
	;将光标设置到score位置
	mov ah,02h
	mov bh,00h
	mov dh,02h
	mov dl,02h
	int 10h
	;显示分数
	mov ah,09h
	mov dx,offset PROMPT1
	int 21h
	mov ax,score
	mov score2,ax
	or  score2,30h
	cmp score2,3ah
	jb  disp3
	mov ax,3100h
	sub score2,10
	or  ax,score2
	xchg ah,al
	mov score2,ax	
disp3:
	mov ah,09h
	mov dx,offset score2
	int 21h
	pop dx
	pop bx
	pop ax
	RET
SHOWSCORE ENDP
;延时子程序===============================
delay proc near
	push cx
	push dx
	mov dx,0fh
dl1:mov cx,02ffh
dl2:loop dl2
	dec dx
	jnz dl1
	pop dx
	pop cx
	ret
delay endp
CODES ENDS
END START



















