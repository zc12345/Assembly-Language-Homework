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
;ˢ�£���֮ǰ�İ��ӵ�����������
refreshm macro
local delayuselp,refreshlp
;������ʱ�ӳ��򣬱�֤��һ�οɹ۲�ʱ���ƶ�һ��
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
	;�����޽粻����ʾ
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

CODES SEGMENT
	ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	MOV AX,DATAS
	MOV DS,AX
	;���������
    
    ;���ɻ�
	clear_screen 00,00,24,79 
	mov ax,0013h
	int 10h		;320*200 255ɫͼ��
	mov plane_x,140
	mov plane_y,176
	myplane	plane_y,plane_x
	
	mov ah,0EH	;��ʾ�ַ�
	mov al,03h	;AL=�ֺ�
	int 10h
	
	CALL COUNTSCORE
	;���Ʒְ�
	CALL COUNTTIME
	;����ʱ��
	JMP UNREFRESH
refresh:
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
refreshnext:
	mov ah,02h ;ͼ����������������λ�õĹ��
	mov bh,00h
	mov dh,22	;��ʼλ�ù����
	mov dl,18	;��ʼλ�ù����
	int 10h
	;====================================
	;ͼ���ʽ�ķɻ�
	mov plane_x,140
	mov plane_y,176
	
	myplane	plane_y,plane_x
	jmp in_key
		
in_key:			;�Ӽ��������ַ�
	;push dx
	;mov ah,06h 	;ֱ�ӿ���̨I/O
	;mov dl,0ffh	;DL=0FF(����)��DL=�ַ�(���)
	;int 21h
	;pop dx
	mov ah,01h
	int 16h
	
	jz refresh	;ZF=1���̻�����Ϊ��ʱ
				;��������Ϊ�գ�����⵽������ʱ��
	mov ah,00h	;��ȡ����ֵ��AH=ɨ���룬AL=ASCII��
	int 16h
	cmp al,'q' 	;�������Q�����˳�
	je over
	cmp al," " 	;�������SPACE�����Ӧλ��ͼ����ʧ
	je disappear
	
move_l:
	cmp al,'a' 	; �����(ɨ����)ʵ��ͼ�����������ƶ�
	jnz move_r
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x 
	sub plane_x,8
	myplane plane_y,plane_x
	dec dl
	mov ah,02h
	int 10h
	;����Ƿ����Խ�����
	cmp dl,left_bound
	jge movelnext
	;Խ���ʱ��
	inc dl
	mov ah,02h
	int 10h
	;���ص��ʾ�һ�
	clearplane plane_y,plane_x
	add plane_x,8
	myplane plane_y,plane_x
	;û��Խ��
movelnext:	
	jmp in_key
		
move_r:
	cmp al,'d' ;���Ҽ���ɨ���룩ʵ��ͼ�����������ƶ�
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
;	jmp in_key
	
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
	cmp m4,01h	;�жϸ�λ���Ƿ��ел�
	jnz next4
	add score,1	;������1
	CALL SHOWSCORE
	;��ʾ����
timer:
	call timer1
next4:
	;����󽫹��ص�ԭ���λ��
	mov ah,02h 
	mov bh,00h
	mov dh,22d
	int 10h
	
	cmp score,8
	JNE IN_KEY
	;ȫ������֮����ʾ����	
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
;��ʱ��====================================
timer1 proc far
	
	PUSH SI
	PUSH BX
	PUSH AX
	PUSH CX
	PUSH DX
	;��ȡʱ����ʾ���λ��
	MOV AH,02
	MOV BH,00
	MOV DH,02
	MOV DL,42H
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
	MOV DL,42H	;time���λ������
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
CODES ENDS
END START



















