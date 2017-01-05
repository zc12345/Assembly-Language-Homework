DATAS SEGMENT
    ;此处输入数据段代码
	DURATION DB 2,2,4,4,4,8,2
	MUSICNOTE DW 11CAH,11CAH,0FDAH,11CAH,0D5BH,0E1FH,11CAH  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS
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
	;MOV DL,DURA	;
MUSIClPP:			;将音符播放一段时间
	CALL DELAYM		;
	DEC DL			;
	JNZ MUSIClPP
	
	MOV AL,AH		;获得端口B当前设置
	OUT 61H,AL		;关闭扬声器
	CALL DELAYM2	;关闭扬声器5ms
ENDM
;======================================================
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    
    MOV AL,0B6H	;控制字节；1011 0110B 计数器2,LSB,MSB,二进制
	OUT 43H,AL	;发送控制字节到寄存器
	
	MOV SI,OFFSET MUSICNOTE
	MOV DI,OFFSET DURATION
	MOV CX,7	;建立计数器
MUSICLP:
	MOV BX,[SI]	;设置指针
	MOV DL,[DI]	;
	MUSICPART BX,DL
	;MUSICPART 11CAH,2
	INC SI		;
	INC SI
	INC DI		;递增note指针
	DEC CX		;递增计数器
	JNZ MUSICLP ;如果CX不为0,循环继续执行
	
	MOV AL,AH		;获得端口B当前设置
	OUT 61H,AL		;关闭扬声器
	CALL DELAYM
	
	POP SI
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
	
	MOV AH,4CH
    INT 21H
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
CODES ENDS
    END START




