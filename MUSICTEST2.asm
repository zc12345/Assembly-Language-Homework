DATAS SEGMENT
    ;�˴��������ݶδ���
	DURATION DB 2,2,4,4,4,8,2
	MUSICNOTE DW 11CAH,11CAH,0FDAH,11CAH,0D5BH,0E1FH,11CAH  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS
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
	;MOV DL,DURA	;
MUSIClPP:			;����������һ��ʱ��
	CALL DELAYM		;
	DEC DL			;
	JNZ MUSIClPP
	
	MOV AL,AH		;��ö˿�B��ǰ����
	OUT 61H,AL		;�ر�������
	CALL DELAYM2	;�ر�������5ms
ENDM
;======================================================
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    
    MOV AL,0B6H	;�����ֽڣ�1011 0110B ������2,LSB,MSB,������
	OUT 43H,AL	;���Ϳ����ֽڵ��Ĵ���
	
	MOV SI,OFFSET MUSICNOTE
	MOV DI,OFFSET DURATION
	MOV CX,7	;����������
MUSICLP:
	MOV BX,[SI]	;����ָ��
	MOV DL,[DI]	;
	MUSICPART BX,DL
	;MUSICPART 11CAH,2
	INC SI		;
	INC SI
	INC DI		;����noteָ��
	DEC CX		;����������
	JNZ MUSICLP ;���CX��Ϊ0,ѭ������ִ��
	
	MOV AL,AH		;��ö˿�B��ǰ����
	OUT 61H,AL		;�ر�������
	CALL DELAYM
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
	
	MOV AH,4CH
    INT 21H
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




