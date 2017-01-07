DATAS SEGMENT
;开始界面的提示信息===============================================
	MESSAGE1	DB	'***************************************',0AH,0DH,
					'**************** INFO: ****************',0AH,0DH,;'$'
					'*****    <-   :  move left         ****',0AH,0DH,;'$'
					'*****    ->   :  move right        ****',0AH,0DH,;'$'
					'*****    space:  shoot             ****',0AH,0DH,;'$'
					'*****    Q    :  exit              ****',0AH,0DH,;'$'
					'*****    enter:  start game        ****',0AH,0DH,;'$'
					'***************************************',0AH,0DH,'$'
	LEVELMSG1	DB	'***************************************',0AH,0DH,
					'**************** LEVEL: ***************',0AH,0DH,;'$'
					'*****      E  :  EASY              ****',0AH,0DH,;'$'
					'*****      H  :  HARD              ****',0AH,0DH,;'$'
					'***************************************',0AH,0DH,'$'
;结束界面的提示信息===============================================
	winshow1 	DB  '***************************************',0AH,0DH,
					'*************** You Win! **************',0AH,0DH,'$'
	quitshow1 	DB  '***************************************',0AH,0DH,
					'************* What a pity! ************',0AH,0DH,'$'
	winshow2	DB	0AH,0DH,
					'***************************************',0AH,0DH,
					'*****    Q    :  exit              ****',0AH,0DH,;'$'
					'*****    enter:  new game          ****',0AH,0DH,;'$'
					'***************************************',0AH,0DH,'$'
;相关变量=========================================================
	full_score	dw 8
	score dw 0
	score2 dw 30h,'$'
	DBUFFER DB 8 DUP (':'),'$'
	DBUFFER2 DB 8 DUP (':'),'$'
	TIME DB '00:00:00','$';8 DUP (':'),'$'
	PROMPT1 DB 'score:$'
	PROMPT2 DB 'time:$'
	m4 db ?
	;飞机和靶子位置坐标相关=============
	plane_x dw ?
	plane_y dw ?
	left_bound db 5
	right_bound db 35
	;ABOUT AUTOMOVE=====================
	AUTOMOVE0 DB 6,9,12,15,18,21,24,27
	AUTOFLAG DB 1,1,1,1,1,1,1,1
	COUNT DB 8
	;音乐相关===========================
	MUSICBEGIN DW 11CAH,11CAH,0FDAH,11CAH,0D5BH,0E1FH,11CAH 
	MUSICSHOOT DW 1FB4H,152FH,0A97H
	MUSICWIN DW 11CAH,11CAH,0FDAH,064CH,0D5BH,064FH,0BCAH 
	MUSICFAIL DW 064FH,11CAH,0A97H,064CH,0D5BH,064FH,0BCAH 
	DURATION DB 2,2,2,2,2,2,2
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
LOCAL INPUT,NEXT,SHOW,FLAGCHECK
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	PUSH SI
	PUSH SP
	
	MOV COUNT,8
	MOV SI,OFFSET AUTOFLAG
	MOV DI,OFFSET AUTOMOVE0
INPUT:
	MOV DL,[DI]
	MOV DH,0AH
	MOV AH,2
	INT 10H
	;超过限界不再显示
	CMP DL,right_bound
	JLE NEXT
	;MOV AL,0
	;JMP SHOW
	PUSH AX
	MOV AX,0
	MOV [SI],AX
	POP AX
NEXT:
	PUSH BX
	MOV BX,[SI]
	CMP BX,0
	POP BX
	JE FLAGCHECK
	MOV AL,TARGETLOOK
SHOW:	
	MOV BH,0
	MOV BL,084H
	MOV CX,1
	MOV AH,09H
	INT 10H
FLAGCHECK:
	INC DI
	INC SI
	DEC COUNT
	JNZ INPUT
	
	POP SP
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
;响一个音符一段延迟时间
MUSICPART MACRO NOTE,DURA
LOCAL MUSICLPP
	;一次响一个音符
	;音符值为1.1913MHz/频率
	MOV AX,NOTE		;发送音符到AX
	OUT 42H,AL		;低位字节
	MOV AL,AH		;
	OUT 42H,AL		;高位字节
	
	IN AL,61H		;获得端口B当前设置
	MOV AH,AL		;保存
	OR AL,00000011B	;使PB0=1,PB1=1
	OUT 61H,AL		;打开扬声器
	MOV DL,DURA	;
MUSIClPP:			;将音符播放一段时间
	CALL DELAYM		;
	DEC DL			;
	JNZ MUSIClPP
	
	MOV AL,AH		;获得端口B当前设置
	OUT 61H,AL		;关闭扬声器
	CALL DELAYM2	;关闭扬声器5ms
ENDM
;======================================================
;===============================================
;播放音乐的宏
MUSICBEGIN1 MACRO
LOCAL MUSICLP1
	PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    
    MOV AL,0B6H	;控制字节；1011 0110B 计数器2,LSB,MSB,二进制
	OUT 43H,AL	;发送控制字节到寄存器
	
	MOV SI,OFFSET MUSICBEGIN
	MOV DI,OFFSET DURATION
	MOV CX,7	;建立计数器
MUSICLP1:
	MOV BX,[SI]	;设置指针
	MOV DL,[DI]	;
	MUSICPART BX,DL
	INC SI		;
	INC SI
	INC DI		;递增note指针
	DEC CX		;递增计数器
	JNZ MUSICLP1 ;如果CX不为0,循环继续执行
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
ENDM
MUSICSHOOT1 MACRO
LOCAL MUSICLP2
	PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    
    MOV AL,0B6H	;控制字节；1011 0110B 计数器2,LSB,MSB,二进制
	OUT 43H,AL	;发送控制字节到寄存器
	
	MOV SI,OFFSET MUSICSHOOT
	;MOV DI,OFFSET DURATION
	MOV CX,3	;建立计数器
MUSICLP2:
	MOV BX,[SI]	;设置指针
	;MOV DL,[DI]	;
	MUSICPART BX,1

	INC SI		;
	INC SI
	;INC DI		;递增note指针
	DEC CX		;递增计数器
	JNZ MUSICLP2;如果CX不为0,循环继续执行
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
ENDM
MUSICWIN1 MACRO
LOCAL MUSICLP3
	PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    
    MOV AL,0B6H	;控制字节；1011 0110B 计数器2,LSB,MSB,二进制
	OUT 43H,AL	;发送控制字节到寄存器
	
	MOV SI,OFFSET MUSICWIN
	MOV DI,OFFSET DURATION
	MOV CX,7	;建立计数器
MUSICLP3:
	MOV BX,[SI]	;设置指针
	MOV DL,[DI]	;
	MUSICPART BX,DL
	INC SI		;
	INC SI
	INC DI		;递增note指针
	DEC CX		;递增计数器
	JNZ MUSICLP3 ;如果CX不为0,循环继续执行
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
ENDM
MUSICFAIL1 MACRO
LOCAL MUSICLP4
	PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    
    MOV AL,0B6H	;控制字节；1011 0110B 计数器2,LSB,MSB,二进制
	OUT 43H,AL	;发送控制字节到寄存器
	
	MOV SI,OFFSET MUSICFAIL
	MOV DI,OFFSET DURATION
	MOV CX,7	;建立计数器
MUSICLP4:
	MOV BX,[SI]	;设置指针
	MOV DL,[DI]	;
	MUSICPART BX,DL
	INC SI		;
	INC SI
	INC DI		;递增note指针
	DEC CX		;递增计数器
	JNZ MUSICLP4;如果CX不为0,循环继续执行
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
ENDM
;===============================================
CODES SEGMENT
	ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	MOV AX,DATAS
	MOV DS,AX
	;清屏宏调用
game:
	MOV SCORE,0
	MOV SCORE2,30H
	clear_screen 00,00,24,79 
	;80*25 16色文本显示
	;开始界面====================
	MUSICBEGIN1
	MOV AH,09
    MOV DX,OFFSET MESSAGE1
    INT 21H
CHECKENTER:    
    MOV AH,0
    INT 16H
    CMP AH,1CH
    JNE CHECKENTER
    ;选择关卡难度=================
    MUSICBEGIN1
	MOV AH,09
    MOV DX,OFFSET LEVELMSG1
    INT 21H
LEVELCHOOSE:    
    MOV AH,0
    INT 16H
    CMP AL,'e'
    JE EASY
    CMP AL,'h'
    JE HARD
    JMP LEVELCHOOSE
 	
EASY:
	;画飞机
	clear_screen 00,00,24,79 
	mov ax,0013h
	int 10h
		
	CALL COUNTSCORE
	;画计分板
	CALL COUNTTIME
	;画计时板
	TARGET 01H
	;绘制敌机
	
	;画子弹
	mov ah,02h ;图像输入完后，设置射击位置的光标
	mov bh,00h
	mov dh,22
	mov dl,18
	int 10h
	
	mov plane_x,140
	mov plane_y,176
	myplane	plane_y,plane_x
	;call delay
	;clearplane plane_y,plane_x
	
		
in_key:			;从键盘输入字符
	push dx
	mov ah,06h 	;直接控制台I/O
	mov dl,0ffh	;DL=0FF(输入)，DL=字符(输出)
	int 21h
	pop dx
	cmp al,'q' 	;如果键入Q，则退出
	je over
	cmp al," " 	;如果键入SPACE，则对应位的图形消失
	je disappear
	
move_l:
	cmp al,4bh 	; 按左键(扫描码)实现图像随光标向左移动
	jnz move_r
	;像素点表示我机
	clearplane plane_y,plane_x
	sub plane_x,8
	myplane plane_y,plane_x
	;mov ah,09h
	;mov al,' '
	;mov cx,1
	;int 10h
	dec dl
	mov ah,02h
	int 10h
	
	;mov ah,09h
	;mov al,1h
	;mov bl,0fh
	;mov cx,1
	;int 10h
	;检查是否出现越界情况
	cmp dl,left_bound
	jge movelnext
	;越界的时候
	;mov ah,09h
	;mov al,' '
	;mov cx,1
	;int 10h
	
	inc dl
	mov ah,02h
	int 10h
	;像素点表示我机
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x
	;mov ah,09h
	;mov al,1h
	;mov bl,0fh
	;mov cx,1
	;int 10h
	;没有越界
movelnext:	
	;jmp in_key
	jmp timer
		
move_r:
	cmp al,4dh ;按右键（扫描码）实现图像随光标向右移动
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
	;将射击到的位置用空格填补
	mov ah,09h
	mov al,' '
	mov dh,0ah
	mov cx,1
	int 10h
	cmp m4,01h	;判断该位置是否有射击图
	jnz next4

	add score,1	;分数加1
	MUSICSHOOT1
	CALL SHOWSCORE
	;显示分数
timer:	
	call timer1
	;调用计时器显示时间
next4:
	;射击后将光标回到原射击位置
	mov ah,02h 
	mov bh,00h
	mov dh,22d
	int 10h
	
	cmp score,8
	JNE IN_KEY
	jmp union1
;======================================================================
;======================================================================
;hard模式
HARD:
	;====================================
	clear_screen 00,00,24,79 
	;mov ax,0001h
	;int 10h
	mov ax,0013h
	int 10h
	
	;图像格式的飞机		
	
	mov plane_x,140
	mov plane_y,176
	myplane	plane_y,plane_x
	mov ah,09h
	mov ah,02h ;图像输入完后，设置射击位置的光标
	mov bh,00h
	mov dh,22	;起始位置光标行
	mov dl,18	;起始位置光标列
	int 10h	
	
	CALL COUNTSCORE
	;画计分板
	CALL COUNTTIME
	;画计时板
	;JMP UNREFRESH
refresh:
	
	myplane	plane_y,plane_x
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
		
in_keyh:			;从键盘输入字符
	mov ah,01h
	int 16h
	
	jz refresh	;ZF=1键盘缓冲区为空时
				;缓冲区不为空，即检测到按键的时候
	mov ah,00h	;读取按键值，AH=扫描码，AL=ASCII码
	int 16h
	cmp al,'q' 	;如果键入Q，则退出
	je over
	cmp al," " 	;如果键入SPACE，则对应位的图形消失
	je disappearh
	
move_lh:
	cmp al,'a' 	; 按左键(扫描码)实现图像随光标向左移动
	jnz move_rh
	;像素点表示我机
	clearplane plane_y,plane_x 
	sub plane_x,8
	myplane plane_y,plane_x
	
	dec dl
	mov ah,02h
	int 10h
	
	;检查是否出现越界情况
	cmp dl,left_bound
	jge movelnexth
	;越界的时候
	
	inc dl
	mov ah,02h
	int 10h
	;像素点表示我机
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x
	
	;没有越界
movelnexth:	
	jmp refresh	
move_rh:
	cmp al,'d' ;按右键（扫描码）实现图像随光标向右移动
	jnz refresh
	;像素点表示我机
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x	
	
	inc dl
	mov ah,02h
	int 10h
	
	;检查是否越界
	cmp dl,right_bound
	jle movernexth
	;如果出现越界
	
	dec dl
	mov ah,02h
	int 10h
	;像素点表示我机
	clearplane plane_y,plane_x
	sub plane_x,8
	myplane plane_y,plane_x
	
	;没有越界
movernexth:	
	jmp timer
	
disappearh:
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
con1h:
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
	ja con1h
	
	;清除最后一颗子弹
	mov ah,02h	;设置光标位置
	mov bh,00h	;页号
	mov dh,0bh	;行数
	int 10h
	mov ah,09h	;光标位置显示字符
	mov al,0	;空格，清除子弹
	mov bl,0fh	;字符属性
	mov cx,1	;重复一次
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

	;将射击到的位置用空格填补
	mov ah,09h
	mov al,' '
	mov dh,0ah
	mov cx,1
	int 10h
	cmp m4,01h	;判断该位置是否有敌机
	jnz next4h
	
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	PUSH SI
	;重置标志位
	MOV CX,8
	MOV SI,OFFSET AUTOFLAG
	MOV DI,OFFSET AUTOMOVE0
REFLAG:
	CMP DL,[DI]
	JNE FLAGTEST
	MOV AX,0
	MOV [SI],AX
FLAGTEST:
	INC DI
	INC SI
	DEC CX
	JNZ REFLAG
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
	POPF	
	
	add score,1	;分数加1
	MUSICSHOOT1
	CALL SHOWSCORE
	;显示分数
timerh:
	call timer1
next4h:
	;射击后将光标回到原射击位置
	mov ah,02h 
	mov bh,00h
	mov dh,22d
	int 10h
	
	cmp score,8
	JNE REFRESH
;====================================
;两种模式在这一点之后相同
	;全部打中之后显示分数	
union1:
	clear_screen 0,0,24,79
	mov ax,0002h
	int 10h
	mov ah,09
	mov dx,offset winshow1
	int 21h
	call showscore
	call timer1
	mov ah,09
	mov dx,offset winshow2
	int 21h

	MUSICWIN1
	JMP CHECKNEXT
over:	
	clear_screen 0,0,24,79
	mov ax,0002h
	int 10h
	mov ah,09
	mov dx,offset quitshow1
	int 21h
	call showscore
	call timer1
	mov ah,09
	mov dx,offset winshow2
	int 21h
	
	MUSICFAIL1
CHECKNEXT:
	mov ah,00
	int 16h
	CMP AH,1CH
	JE GAME
	CMP AL,'q'
	JE QUIT
	JMP CHECKNEXT
QUIT:
	MOV AH,4CH
	INT 21H
;====================================================================
;计时器=========================================
timer1 proc far
	PUSH BX
	PUSH SI
	PUSH AX
	PUSH CX
	PUSH DX
	;获取时间显示光标位置
	MOV AH,02
	MOV BH,00
	MOV DH,02
	MOV DL,15H
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
	MOV DL,15H	;time光标位置列数
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
;发声延时500ms	===============================
DELAYM PROC NEAR
	PUSH CX
	MOV CX,33156
	PUSH AX
WAIT1:
	IN AL,61H	;检查PB4
	AND AL,10H	;是否改变
	CMP AL,AH	;
	JE WAIT1	;等待改变
	MOV AH,AL	;保存PB4的新状态
	LOOP WAIT1	;继续直到CX为0
	POP AX
	POP CX
	RET
DELAYM ENDP
;发声延时5ms====================================
DELAYM2 PROC NEAR
	PUSH CX
	MOV CX,331
	PUSH AX
WAIT2:
	IN AL,61H
	AND AL,10H
	CMP AL,AH
	JE WAIT2
	MOV AH,AL
	LOOP WAIT2
	POP AX
	POP CX
	RET
DELAYM2 ENDP
;==================================================
;产生一个0-100的随机数
RAND  PROC
      PUSH CX
      PUSH DX
      PUSH AX
      STI
      MOV AH,0             ;读时钟计数器值
      INT 1AH
      MOV AX,DX            ;清高6位
      AND AH,3
      MOV DL,101           ;除101，产生0~100余数
      DIV DL
      MOV BL,AH            ;余数存BX，作随机数
      POP AX
      POP DX
      POP CX
      RET
RAND  ENDP
CODES ENDS
END START



