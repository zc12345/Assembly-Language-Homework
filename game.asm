DATAS SEGMENT
;��ʼ�������ʾ��Ϣ===============================================
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
;�����������ʾ��Ϣ===============================================
	winshow1 	DB  '***************************************',0AH,0DH,
					'*************** You Win! **************',0AH,0DH,'$'
	quitshow1 	DB  '***************************************',0AH,0DH,
					'************* What a pity! ************',0AH,0DH,'$'
	winshow2	DB	0AH,0DH,
					'***************************************',0AH,0DH,
					'*****    Q    :  exit              ****',0AH,0DH,;'$'
					'*****    enter:  new game          ****',0AH,0DH,;'$'
					'***************************************',0AH,0DH,'$'
;��ر���=========================================================
	full_score	dw 8
	score dw 0
	score2 dw 30h,'$'
	DBUFFER DB 8 DUP (':'),'$'
	DBUFFER2 DB 8 DUP (':'),'$'
	TIME DB '00:00:00','$';8 DUP (':'),'$'
	PROMPT1 DB 'score:$'
	PROMPT2 DB 'time:$'
	m4 db ?
	;�ɻ��Ͱ���λ���������=============
	plane_x dw ?
	plane_y dw ?
	left_bound db 5
	right_bound db 35
	;ABOUT AUTOMOVE=====================
	AUTOMOVE0 DB 6,9,12,15,18,21,24,27
	AUTOFLAG DB 1,1,1,1,1,1,1,1
	COUNT DB 8
	;�������===========================
	MUSICBEGIN DW 11CAH,11CAH,0FDAH,11CAH,0D5BH,0E1FH,11CAH 
	MUSICSHOOT DW 1FB4H,152FH,0A97H
	MUSICWIN DW 11CAH,11CAH,0FDAH,064CH,0D5BH,064FH,0BCAH 
	MUSICFAIL DW 064FH,11CAH,0A97H,064CH,0D5BH,064FH,0BCAH 
	DURATION DB 2,2,2,2,2,2,2
DATAS ENDS

STACKS SEGMENT
STACKS ENDS
;============================================
;�����궨��
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
;ʱ����ֵת����ASCII���ַ��ӳ���
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
;����һ��������
;����ֵ:���ص���ʼλ��(HA,LA),�г���LEN,��ɫCOL
LINE MACRO HA,LA,LEN,COL
LOCAL LINELP
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	MOV DX,HA;DX������
	MOV CX,LA;CX������
	MOV BX,LEN;BXһ��������������
LINELP:	
	MOV AH,0CH;AH=0CHд����
	MOV AL,COL;AL��ɫֵ
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
;����ɻ��ĺ�
clearplane macro hcood,lcood
local clearlp
	pushf
	push cx
	push dx
	push di
    mov dx,hcood
    mov cx,lcood

	;�����ɻ�
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
;���Ƶз��ɻ�
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
	;�����޽粻����ʾ
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
;�����ҷ��ɻ��ĺ�
myplane macro hcood,lcood
	local planelp1,planelp2
	    push ax
    push cx
    push dx
    push di
    push si
    
    ;mov ax,000dh;320*200  ��ɫͼ��(EGA)
    ;int 10h
    mov dx,hcood
    mov cx,lcood
;�һ�===================================
;��ͷ����========================================
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
;������================================

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
	
;��β����===============================
	
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
;��һ������һ���ӳ�ʱ��
MUSICPART MACRO NOTE,DURA
LOCAL MUSICLPP
	;һ����һ������
	;����ֵΪ1.1913MHz/Ƶ��
	MOV AX,NOTE		;����������AX
	OUT 42H,AL		;��λ�ֽ�
	MOV AL,AH		;
	OUT 42H,AL		;��λ�ֽ�
	
	IN AL,61H		;��ö˿�B��ǰ����
	MOV AH,AL		;����
	OR AL,00000011B	;ʹPB0=1,PB1=1
	OUT 61H,AL		;��������
	MOV DL,DURA	;
MUSIClPP:			;����������һ��ʱ��
	CALL DELAYM		;
	DEC DL			;
	JNZ MUSIClPP
	
	MOV AL,AH		;��ö˿�B��ǰ����
	OUT 61H,AL		;�ر�������
	CALL DELAYM2	;�ر�������5ms
ENDM
;======================================================
;===============================================
;�������ֵĺ�
MUSICBEGIN1 MACRO
LOCAL MUSICLP1
	PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    
    MOV AL,0B6H	;�����ֽڣ�1011 0110B ������2,LSB,MSB,������
	OUT 43H,AL	;���Ϳ����ֽڵ��Ĵ���
	
	MOV SI,OFFSET MUSICBEGIN
	MOV DI,OFFSET DURATION
	MOV CX,7	;����������
MUSICLP1:
	MOV BX,[SI]	;����ָ��
	MOV DL,[DI]	;
	MUSICPART BX,DL
	INC SI		;
	INC SI
	INC DI		;����noteָ��
	DEC CX		;����������
	JNZ MUSICLP1 ;���CX��Ϊ0,ѭ������ִ��
	
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
    
    MOV AL,0B6H	;�����ֽڣ�1011 0110B ������2,LSB,MSB,������
	OUT 43H,AL	;���Ϳ����ֽڵ��Ĵ���
	
	MOV SI,OFFSET MUSICSHOOT
	;MOV DI,OFFSET DURATION
	MOV CX,3	;����������
MUSICLP2:
	MOV BX,[SI]	;����ָ��
	;MOV DL,[DI]	;
	MUSICPART BX,1

	INC SI		;
	INC SI
	;INC DI		;����noteָ��
	DEC CX		;����������
	JNZ MUSICLP2;���CX��Ϊ0,ѭ������ִ��
	
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
    
    MOV AL,0B6H	;�����ֽڣ�1011 0110B ������2,LSB,MSB,������
	OUT 43H,AL	;���Ϳ����ֽڵ��Ĵ���
	
	MOV SI,OFFSET MUSICWIN
	MOV DI,OFFSET DURATION
	MOV CX,7	;����������
MUSICLP3:
	MOV BX,[SI]	;����ָ��
	MOV DL,[DI]	;
	MUSICPART BX,DL
	INC SI		;
	INC SI
	INC DI		;����noteָ��
	DEC CX		;����������
	JNZ MUSICLP3 ;���CX��Ϊ0,ѭ������ִ��
	
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
    
    MOV AL,0B6H	;�����ֽڣ�1011 0110B ������2,LSB,MSB,������
	OUT 43H,AL	;���Ϳ����ֽڵ��Ĵ���
	
	MOV SI,OFFSET MUSICFAIL
	MOV DI,OFFSET DURATION
	MOV CX,7	;����������
MUSICLP4:
	MOV BX,[SI]	;����ָ��
	MOV DL,[DI]	;
	MUSICPART BX,DL
	INC SI		;
	INC SI
	INC DI		;����noteָ��
	DEC CX		;����������
	JNZ MUSICLP4;���CX��Ϊ0,ѭ������ִ��
	
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
	;���������
game:
	MOV SCORE,0
	MOV SCORE2,30H
	clear_screen 00,00,24,79 
	;80*25 16ɫ�ı���ʾ
	;��ʼ����====================
	MUSICBEGIN1
	MOV AH,09
    MOV DX,OFFSET MESSAGE1
    INT 21H
CHECKENTER:    
    MOV AH,0
    INT 16H
    CMP AH,1CH
    JNE CHECKENTER
    ;ѡ��ؿ��Ѷ�=================
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
	;���ɻ�
	clear_screen 00,00,24,79 
	mov ax,0013h
	int 10h
		
	CALL COUNTSCORE
	;���Ʒְ�
	CALL COUNTTIME
	;����ʱ��
	TARGET 01H
	;���Ƶл�
	
	;���ӵ�
	mov ah,02h ;ͼ����������������λ�õĹ��
	mov bh,00h
	mov dh,22
	mov dl,18
	int 10h
	
	mov plane_x,140
	mov plane_y,176
	myplane	plane_y,plane_x
	;call delay
	;clearplane plane_y,plane_x
	
		
in_key:			;�Ӽ��������ַ�
	push dx
	mov ah,06h 	;ֱ�ӿ���̨I/O
	mov dl,0ffh	;DL=0FF(����)��DL=�ַ�(���)
	int 21h
	pop dx
	cmp al,'q' 	;�������Q�����˳�
	je over
	cmp al," " 	;�������SPACE�����Ӧλ��ͼ����ʧ
	je disappear
	
move_l:
	cmp al,4bh 	; �����(ɨ����)ʵ��ͼ�����������ƶ�
	jnz move_r
	;���ص��ʾ�һ�
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
	;����Ƿ����Խ�����
	cmp dl,left_bound
	jge movelnext
	;Խ���ʱ��
	;mov ah,09h
	;mov al,' '
	;mov cx,1
	;int 10h
	
	inc dl
	mov ah,02h
	int 10h
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x
	;mov ah,09h
	;mov al,1h
	;mov bl,0fh
	;mov cx,1
	;int 10h
	;û��Խ��
movelnext:	
	;jmp in_key
	jmp timer
		
move_r:
	cmp al,4dh ;���Ҽ���ɨ���룩ʵ��ͼ�����������ƶ�
	jnz in_key
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x	
	
	inc dl
	mov ah,02h
	int 10h
	;����Ƿ�Խ��
	cmp dl,right_bound
	jle movernext
	;�������Խ��
	dec dl
	mov ah,02h
	int 10h
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x
	sub plane_x,8
	myplane plane_y,plane_x
	;û��Խ��
movernext:	
	jmp timer
	
disappear:
	push ax
	;���ù��λ��
	mov dh,21
	mov ah,02h
	mov bh,00h
	int 10h
	;��ʾ�ӵ�
	mov ah,09h
	mov al,07h
	mov bl,0fh
	mov cx,1
	int 10h
	;���ù��λ��
	sub dh,1
con1:
	mov ah,02h
	mov bh,00h
	int 10h
	
	;��ʾ�ӵ�
	mov ah,09h
	mov al,07h
	mov bl,0fh
	mov cx,1
	int 10h
	;������ʱ�ӳ���
	call delay
	;���ù��λ��
	inc dh
	mov ah,02h
	mov bh,00h
	int 10h
	
	;����ӵ�
	mov ah,09h
	mov al,0
	mov bl,0fh
	mov cx,1
	int 10h
	sub dh,2
	cmp dh,0ah
	ja con1
	
	;������һ���ӵ�
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
	
	;��������õ�ͼ��λ��
	mov ah,02h
	mov bh,00h
	mov dh,0ah
	int 10h
	;��ȡ��괦�ַ�
	mov ah,08h
	mov bh,00
	int 10h
	mov m4,al
	;���������λ���ÿո��
	mov ah,09h
	mov al,' '
	mov dh,0ah
	mov cx,1
	int 10h
	cmp m4,01h	;�жϸ�λ���Ƿ������ͼ
	jnz next4

	add score,1	;������1
	MUSICSHOOT1
	CALL SHOWSCORE
	;��ʾ����
timer:	
	call timer1
	;���ü�ʱ����ʾʱ��
next4:
	;����󽫹��ص�ԭ���λ��
	mov ah,02h 
	mov bh,00h
	mov dh,22d
	int 10h
	
	cmp score,8
	JNE IN_KEY
	jmp union1
;======================================================================
;======================================================================
;hardģʽ
HARD:
	;====================================
	clear_screen 00,00,24,79 
	;mov ax,0001h
	;int 10h
	mov ax,0013h
	int 10h
	
	;ͼ���ʽ�ķɻ�		
	
	mov plane_x,140
	mov plane_y,176
	myplane	plane_y,plane_x
	mov ah,09h
	mov ah,02h ;ͼ����������������λ�õĹ��
	mov bh,00h
	mov dh,22	;��ʼλ�ù����
	mov dl,18	;��ʼλ�ù����
	int 10h	
	
	CALL COUNTSCORE
	;���Ʒְ�
	CALL COUNTTIME
	;����ʱ��
	;JMP UNREFRESH
refresh:
	
	myplane	plane_y,plane_x
	;����refreshm�꣬�������ӵ�������
	;refreshm
	;��չ��===================================
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
	;�����֮ǰ��һ�а���
	TARGET ' '
	MOV SI,8
	MOV DI,OFFSET AUTOMOVE0
REFRESHLP:
	MOV DL,[DI]
	INC DL
	MOV [DI],DL
	;�߽��޶�
	;�������ߵ�Ԫ�ص��г����޶����˳�
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
	;��չ������===========================
UNREFRESH:	
	;û��ˢ�£��ڵ�һ�����е�ʱ����ݳ�ʼֵ���ư���
	TARGET 01H
	;���л�
		
in_keyh:			;�Ӽ��������ַ�
	mov ah,01h
	int 16h
	
	jz refresh	;ZF=1���̻�����Ϊ��ʱ
				;��������Ϊ�գ�����⵽������ʱ��
	mov ah,00h	;��ȡ����ֵ��AH=ɨ���룬AL=ASCII��
	int 16h
	cmp al,'q' 	;�������Q�����˳�
	je over
	cmp al," " 	;�������SPACE�����Ӧλ��ͼ����ʧ
	je disappearh
	
move_lh:
	cmp al,'a' 	; �����(ɨ����)ʵ��ͼ�����������ƶ�
	jnz move_rh
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x 
	sub plane_x,8
	myplane plane_y,plane_x
	
	dec dl
	mov ah,02h
	int 10h
	
	;����Ƿ����Խ�����
	cmp dl,left_bound
	jge movelnexth
	;Խ���ʱ��
	
	inc dl
	mov ah,02h
	int 10h
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x
	
	;û��Խ��
movelnexth:	
	jmp refresh	
move_rh:
	cmp al,'d' ;���Ҽ���ɨ���룩ʵ��ͼ�����������ƶ�
	jnz refresh
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x	
	
	inc dl
	mov ah,02h
	int 10h
	
	;����Ƿ�Խ��
	cmp dl,right_bound
	jle movernexth
	;�������Խ��
	
	dec dl
	mov ah,02h
	int 10h
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x
	sub plane_x,8
	myplane plane_y,plane_x
	
	;û��Խ��
movernexth:	
	jmp timer
	
disappearh:
	push ax
	;���ù��λ��
	mov dh,21
	mov ah,02h
	mov bh,00h
	int 10h
	;��ʾ�ӵ�
	mov ah,09h
	mov al,07h
	mov bl,0fh
	mov cx,1
	int 10h
	;���ù��λ��
	sub dh,1
con1h:
	mov ah,02h
	mov bh,00h
	int 10h
	
	;��ʾ�ӵ�
	mov ah,09h
	mov al,07h
	mov bl,0fh
	mov cx,1
	int 10h
	;������ʱ�ӳ���
	call delay
	;���ù��λ��
	inc dh
	mov ah,02h
	mov bh,00h
	int 10h
	
	;����ӵ�
	mov ah,09h
	mov al,0
	mov bl,0fh
	mov cx,1
	int 10h
	sub dh,2
	cmp dh,0ah
	ja con1h
	
	;������һ���ӵ�
	mov ah,02h	;���ù��λ��
	mov bh,00h	;ҳ��
	mov dh,0bh	;����
	int 10h
	mov ah,09h	;���λ����ʾ�ַ�
	mov al,0	;�ո�����ӵ�
	mov bl,0fh	;�ַ�����
	mov cx,1	;�ظ�һ��
	int 10h
	pop ax
	
	;��������õ�ͼ��λ��
	mov ah,02h
	mov bh,00h
	mov dh,0ah
	int 10h
	;��ȡ��괦�ַ�
	mov ah,08h
	mov bh,00
	int 10h
	mov m4,al

	;���������λ���ÿո��
	mov ah,09h
	mov al,' '
	mov dh,0ah
	mov cx,1
	int 10h
	cmp m4,01h	;�жϸ�λ���Ƿ��ел�
	jnz next4h
	
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	PUSH SI
	;���ñ�־λ
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
	
	add score,1	;������1
	MUSICSHOOT1
	CALL SHOWSCORE
	;��ʾ����
timerh:
	call timer1
next4h:
	;����󽫹��ص�ԭ���λ��
	mov ah,02h 
	mov bh,00h
	mov dh,22d
	int 10h
	
	cmp score,8
	JNE REFRESH
;====================================
;����ģʽ����һ��֮����ͬ
	;ȫ������֮����ʾ����	
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
;��ʱ��=========================================
timer1 proc far
	PUSH BX
	PUSH SI
	PUSH AX
	PUSH CX
	PUSH DX
	;��ȡʱ����ʾ���λ��
	MOV AH,02
	MOV BH,00
	MOV DH,02
	MOV DL,15H
	INT 10H

	MOV SI,0
	;��ȡ���е�ʱ��
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
	;����ʱ���
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
	;��ʾʱ��
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

;�Ʒְ�	===================================
COUNTSCORE PROC FAR
	;���Ʒְ�
	push ax
	push bx
	push dx
	mov ah,02h;��������õ�scoreλ��
	mov bh,00h
	mov dh,02H	;score���λ������
	mov dl,02h	;score���λ������
	int 10h
	mov ah,09h
	mov dx,offset PROMPT1;��ʾ���� 'score:$'
	int 21h
	mov ah,09h
	mov dx,offset score2;��������ֵ
	int 21h
	pop dx
	pop bx
	pop ax
	RET
COUNTSCORE ENDP	
;��ʱ��=====================================
COUNTTIME PROC FAR
	PUSH SI
	PUSH BX
	PUSH AX
	PUSH DX
	;����ʱ��λ��
	MOV AH,02
	MOV BH,00	
	MOV DH,02	;time���λ������
	MOV DL,15H	;time���λ������
	INT 10H
	
	;��ʾʱ��
	mov ah,09h
	mov dx,offset PROMPT2;'time$'
	int 21h
	;��ȡ��ʼ��ʱ��
	MOV SI,0
	MOV AH,2CH	;ȡʱ�䣬CH:CL=ʱ:�֣�DH:DL=��:1/100��
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
;��ʾ����================================
SHOWSCORE PROC FAR	
	push ax
	push bx
	push dx
	;��������õ�scoreλ��
	mov ah,02h
	mov bh,00h
	mov dh,02h
	mov dl,02h
	int 10h
	;��ʾ����
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
;��ʱ�ӳ���===============================
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
;������ʱ500ms	===============================
DELAYM PROC NEAR
	PUSH CX
	MOV CX,33156
	PUSH AX
WAIT1:
	IN AL,61H	;���PB4
	AND AL,10H	;�Ƿ�ı�
	CMP AL,AH	;
	JE WAIT1	;�ȴ��ı�
	MOV AH,AL	;����PB4����״̬
	LOOP WAIT1	;����ֱ��CXΪ0
	POP AX
	POP CX
	RET
DELAYM ENDP
;������ʱ5ms====================================
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
;����һ��0-100�������
RAND  PROC
      PUSH CX
      PUSH DX
      PUSH AX
      STI
      MOV AH,0             ;��ʱ�Ӽ�����ֵ
      INT 1AH
      MOV AX,DX            ;���6λ
      AND AH,3
      MOV DL,101           ;��101������0~100����
      DIV DL
      MOV BL,AH            ;������BX���������
      POP AX
      POP DX
      POP CX
      RET
RAND  ENDP
CODES ENDS
END START



