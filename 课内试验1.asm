;求十个数的最大值
	.model small
	.stack 64
	.data
data1 db 12h,13h,14h,15h,69h,23h,34h,35h,47h,22h
	org 10H
max   db ?
	.code
main proc far
	mov ax,@data
	mov ds,ax
	mov si,offset data1
	mov cx,0Ah
	sub al,al;将al清零
lp: 
	cmp al,[si];比较后将较大值存入al
	ja	next
	mov al,[si]
next: inc si
	dec cx
	jnz lp
	mov max,al
	mov ax,4ch
	int 21h
main endp
	end main




