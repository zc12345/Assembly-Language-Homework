DATAS SEGMENT
	MESSAGE1	DB	'***************************************',0AH,0DH,
					'*****************INFO:*****************',0AH,0DH,;'$'
					'*****    <-   :  move left         ****',0AH,0DH,;'$'
					'*****    ->   :  move right        ****',0AH,0DH,;'$'
					'*****    space:  shoot             ****',0AH,0DH,;'$'
					'*****    Q    :  exit              ****',0AH,0DH,;'$'
					'*****    enter:  start game        ****',0AH,0DH,;'$'
					'***************************************',0AH,0DH,'$'
	winshow1 	DB  '***************************************',0AH,0DH,
					'*************** You Win! **************',0AH,0DH,'$'
	quitshow1 	DB  '***************************************',0AH,0DH,
					'************* What a pity! ************',0AH,0DH,'$'
	winshow2	DB	0AH,0DH,
					'***************************************',0AH,0DH,
					'*****    Q    :  exit              ****',0AH,0DH,;'$'
					'*****    enter:  new game          ****',0AH,0DH,;'$'
					'***************************************',0AH,0DH,'$'
	full_score	dw 8
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
	;�������
	MUSICBEGIN DW 11CAH,11CAH,0FDAH,11CAH,0D5BH,0E1FH,11CAH 
	MUSICSHOOT DW 1FB4H,152FH,0A97H
	MUSICWIN DW 11CAH,11CAH,0FDAH,064CH,0D5BH,064FH,0BCAH 
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
;�����з��ɻ��ĺ�
plane macro hcood,lcood
	local PLANELP1,PLANELP2
    push ax
    push cx
    push dx
    push di
    push si
    
    ;mov ax,000dh;320*200  ��ɫͼ��(EGA)
    ;int 10h
    mov dx,hcood
    mov cx,lcood

;��β����===============================	
	ADD CX,7
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,1,02H
	INC CX
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
	ADD CX,6
	LINE DX,CX,5,02H
	
	INC DX
	MOV CX,LCOOD
	ADD CX,7
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,1,02H
	INC CX
	LINE DX,CX,1,0AH
;������================================
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
	
	INC DX
	MOV CX,LCOOD
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,15,02H
	ADD CX,15
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
	ADD CX,5
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,5,02H
	ADD CX,5
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
	ADD CX,6
	LINE DX,CX,1,0AH
	INC CX
	LINE DX,CX,3,02H
	ADD CX,3
	LINE DX,CX,1,0AH
;��ͷ����========================================
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
	
	INC DX
	MOV CX,LCOOD
	ADD CX,7
	LINE DX,CX,3,03H
    
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
    ;PUSH DI
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
	;POP DI
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
	MUSICBEGIN1
	MOV AH,09
    MOV DX,OFFSET MESSAGE1
    INT 21H
CHECKENTER:    
    MOV AH,0
    INT 16H
    CMP AH,1CH
    JNE CHECKENTER
    ;CMP AL,'q'
    ;JE OVER
    ;���ɻ�
	clear_screen 00,00,24,79 
	;mov ax,0001h
	;int 10h
	mov ax,0013h
	int 10h
	
	mov ah,0EH
	mov al,03h
	int 10h
	
	mov di,15	;�ܹ�29��λ�ã�15��ͼ��14����
	mov dh,0ah	;���ͼ�ε��С���
	mov dl,0ch

input:
	mov ah,2	;����ͼ��λ��
	inc dl		;������
	int 10h
	mov al,01h	;�л�ͼ��
	mov bh,0
	mov bl,084h	;ͼ���Ӧ������,77H�׵װ���
	mov cx,1	;��ʾһ��
	mov ah,9
	int 10h
	dec di
	jnz input1
	
	CALL COUNTSCORE
	;���Ʒְ�
	CALL COUNTTIME
	;����ʱ��
	
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
	
	;mov ah,09h
	;mov al,1H	;�ҷ��ɻ���ͼ��
	;mov bl,0fh	;�ɻ����ԣ��ڵװ�������
	;mov cx,1	;�ַ��ظ�1��
	;int 10h
	jmp in_key
				
input1:
	mov ah,2 	;ʵ��ÿ��һ���ո�����һ��ͼ��
	inc dl		;�������ε���
	int 10h
	mov al,' '
	mov bh,0
	;mov bl,[si]
	;inc si
	dec di		;29��λ�õļ�����
	jnz input
		
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
	cmp dl,5
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
	
	;mov ah,09h
	;mov al ,' '
	;mov cx,1
	;int 10h
	inc dl
	mov ah,02h
	int 10h
	;mov ah,09h
	;mov al,1h
	;mov bl,0fh
	;mov cx,1
	;int 10h
	;����Ƿ�Խ��
	cmp dl,35
	jle movernext
	;�������Խ��
	;mov ah,09h
	;mov al,' '
	;mov cx,1
	;int 10h
	dec dl
	mov ah,02h
	int 10h
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x
	sub plane_x,8
	myplane plane_y,plane_x
	;mov ah,09h
	;mov al,1h
	;mov bl,0fh
	;mov cx,1
	;int 10h
	;û��Խ��
movernext:	
	;jmp in_key
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
next2:
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
	;mov ah,09h
	;mov al,1h
	;mov bl,0fh
	;mov cx,1
	;int 10h
	
	cmp score,8
	JNE IN_KEY
	;ȫ������֮����ʾ����	
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
CODES ENDS
END START





