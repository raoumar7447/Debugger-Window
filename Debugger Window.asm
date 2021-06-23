[org 0x100]
di_memory:dw 968
dx_memory:dw 0x0604
flag:db 0
ax_value:dw 0x0000
bx_value:dw 0x10
cx_value:dw 0x20
dx_value:dw 0x40
oldisr:dd 0
jmp start

clrscr: 
push es
push ax
push cx
push di
mov ax, 0xb800

mov es, ax ; point es to video base
xor di, di ; point di to top left column
mov ax, 0x0720 ; space char in normal attribute
mov cx, 2000 ; number of screen locations
cld ; auto increment mode
rep stosw ; clear the whole screen
pop di

pop cx
pop ax
pop es
ret



reg:
push bp
mov bp,sp
mov ax,0xb800
mov es,ax

mov al,[bp+6] ; get a val
mov bl,[bp+4] ; get x val
mov ah,0x6	
mov bh,0x6
mov si,0
xor di,di
print:
mov word[es:di],ax
add di,2
add si,1
inc al
mov word[es:di],bx
add di,4
mov cx,0
l1:
mov al,0x30
mov [es:di],ax
add di,2
inc cx
cmp cx,4
jne l1
mov cx,0

l2:
mov di,0
add di,160
inc cx
cmp cx,si
jne l2
je print
ret 4

line1:

mov ax,0xb800
mov es,ax
mov di,640
add di,160
mov ax,0x075F
l11:
mov word[es:di],ax
add di,2
cmp di,960
jne l11

ret

Cmd:
mov ax,0xb800
mov es,ax
mov di,960
mov word[es:di],0x0743
add di,2

mov word[es:di],0x074D
add di,2

mov word[es:di],0x0744
add di,2

mov word[es:di],0x073E
mov ah,0x02		;13 service for print string
mov al,1			;subservice cursor update
mov bh,0			;video memory page 0
mov dx,0x0604		;rows on dh and coloumns on dl
int 0x10			;bios video service

ret

line2:
mov ax,0xb800
mov es,ax
mov di,960
add di,160
mov ax,0x075F
l12:
mov word[es:di],ax
add di,2
cmp di,1214
jne l12

ret


line3:
mov ax,0xb800
mov es,ax
mov di,1054
mov ax,0x077C
l22:
mov word[es:di],ax
add di,160
cmp di,2814
jne l22

ret

line4:
mov ax,0xb800
mov es,ax
mov di,2720
mov ax,0x075F
l33:
mov word[es:di],ax
add di,2
cmp di,2880
jne l33

ret

line5:
mov ax,0xb800
mov es,ax
mov di,3010
mov ax,0x077C
l44:
mov word[es:di],ax
add di,160
cmp di,3970
jne l44

ret

line6:
mov ax,0xb800
mov es,ax
mov di,3840
mov ax,0x075F
l55:
mov word[es:di],ax
add di,2
cmp di,4000
jne l55

ret

flags:
mov ax,0xb800
mov es,ax
mov di,432
add di,160	;	for address right positio
mov word[es:di],0x074F
add di,2
mov word[es:di],0x0746
add di,160
mov word[es:di],0x0230


mov di,440	;	DF
add di,160
mov word[es:di],0x0744
add di,2
mov word[es:di],0x0746
add di,160
mov word[es:di],0x0230


mov di,446	;	IF
add di,160
mov word[es:di],0x0749
add di,2
mov word[es:di],0x0746
add di,160
mov word[es:di],0x0230



mov di,452	;	SF
add di,160
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0746
add di,160
mov word[es:di],0x0230



mov di,458	;	ZF
add di,160
mov word[es:di],0x075A
add di,2
mov word[es:di],0x0746
add di,160
mov word[es:di],0x0230


mov di,464	;	AF
add di,160
mov word[es:di],0x0741
add di,2
mov word[es:di],0x0746
add di,160
mov word[es:di],0x0230



mov di,470	;	PF
add di,160
mov word[es:di],0x0750
add di,2
mov word[es:di],0x0746
add di,160
mov word[es:di],0x0230



mov di,476	;	CF
add di,160
mov word[es:di],0x0743
add di,2
mov word[es:di],0x0746
add di,160
mov word[es:di],0x0230


ret
print_registers:
push bp
mov bp, sp
push ax
push bx
push cx
push dx
push si
push di
push ds
push es

mov ax,[bp+4]
mov di,[bp+6]
mov bx,10
mov cx,4
l:
mov dx,0
div bx
add dl,0x30
push dx
sub cx,1
jnz l
mov cx,4
loop_2:
add di,2
pop dx
mov dh,0x02
mov word[es:di],dx
sub cx,1
jnz loop_2
pop es
pop ds
pop di
pop si
pop dx
pop cx
pop bx
pop ax 
pop bp
ret 4
 
trapisr:
push bp
mov bp, sp ; to read cs, ip and flags
push ax
push bx
push cx
push dx
push si
push di
push ds
push es
push ax
mov ax,0xb800
mov es,ax
pop ax
push cs
pop ds ; initialize ds to data segment
mov si,6
;printing flags and a space
mov di,272
mov word[es:di],0x0746	;FLAGS
add di,2
mov word[es:di],0x076C
add di,2
mov word[es:di],0x0761
add di,2
mov word[es:di],0x0767
add di,2
mov word[es:di],0x0773
add di,2
add di,2
push di
push word [bp+si]
call print_registers
sub si,2

;printing cs and a space
mov di,200
mov word[es:di],0x0743
add di,2
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0720
push di
push word [bp+si]
call print_registers
sub si,2


;printing IP and a space
mov di,220
mov word[es:di],0x0749
add di,2
mov word[es:di],0x0750
add di,2
mov word[es:di],0x0720
push di
push word [bp+si]
call print_registers
sub si,2

;printing bp and a space
mov di,500
mov word[es:di],0x0742
add di,2
mov word[es:di],0x0750
add di,2
mov word[es:di],0x0720
push di
push word [bp+si]
call print_registers
sub si,2

;printing ax and a space
mov di,160
mov word[es:di],0x0741
add di,2
mov word[es:di],0x0758
add di,2
mov word[es:di],0x0720

push di
push word [bp+si]
call print_registers
sub si,2

;printing bx and a space
mov di,320
mov word[es:di],0x0742
add di,2
mov word[es:di],0x0758
add di,2
mov word[es:di],0x0720

push di
push word [bp+si]
call print_registers
sub si,2


;printing cx and a space
mov di,480
mov word[es:di],0x0743
add di,2
mov word[es:di],0x0758
add di,2
mov word[es:di],0x0720
push di
push word [bp+si]
call print_registers
sub si,2

;printing dx and a space
mov di,640
mov word[es:di],0x0744
add di,2
mov word[es:di],0x0758
add di,2
mov word[es:di],0x0720
push di
push word [bp+si]
call print_registers
sub si,2

;printing si and a space
mov di,180
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0749
add di,2
mov word[es:di],0x0720
push di
push word [bp+si]
call print_registers
sub si,2

;printing di and a space
mov di,340
mov word[es:di],0x0744
add di,2
mov word[es:di],0x0749
add di,2
mov word[es:di],0x0720
push di
push word [bp+si]
call print_registers
sub si,2

;printing ds and a space
mov di,360
mov word[es:di],0x0744
add di,2
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0720
push di
push word [bp+si]
call print_registers
sub si,2

;printing es and a space
mov di,520
mov word[es:di],0x0745
add di,2
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0720
push di
push word [bp+si]
call print_registers
sub si,2

; printing sp and a space
mov di,660
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0750
add di,2
mov word[es:di],0x0720
push di
push sp
call print_registers



; printing ss and a space
mov di,680
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0720
push di
push ss
call print_registers

; printing HS and a space
mov di,540
mov word[es:di],0x0748
add di,2
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0720
push di
push fs
call print_registers

; printing FS and a space
mov di,700
mov word[es:di],0x0746
add di,2
mov word[es:di],0x0753
add di,2
mov word[es:di],0x0720
push di
push fs
call print_registers

pop es
pop ds
pop di
pop si
pop dx
pop cx
pop bx
pop ax 
pop bp
iret

print_stack:
mov bp,sp
mov ax,[bp+2]
mov di,[bp+4]
mov bx,10
mov cx,4
lstack:
mov dx,0
div bx
add dl,0x30
push dx
sub cx,1
jnz lstack
mov cx,4
loopstack:
add di,2
pop dx
mov dh,0x07
mov word[es:di],dx
sub cx,1
jnz loopstack

ret 4

stack:
mov ax,0xb800
mov es,ax
mov bp,sp
;printing stack
mov di,242
mov word[es:di],0x0753			;s
add di,2
mov word[es:di],0x0754			;t
add di,2
mov word[es:di],0x0741			;a
add di,2
mov word[es:di],0x0743			;c
add di,2
mov word[es:di],0x074b			;k
add di,2
mov word[es:di],0x0720			;space

;stack first line +0
add di,2
mov word[es:di],0x072b			;+sign
add di,2
mov word[es:di],0x0730			;0
add di,2
mov word[es:di],0x0720			;space
mov bx,[bp+2]
push di
push bx
call print_stack
;stack second line +2
mov di,414
mov word[es:di],0x072b			;+sign
add di,2
mov word[es:di],0x0732			;2
add di,2
mov word[es:di],0x0720			;space
mov bx,[bp+4]
push di
push bx
call print_stack

;stack third line +4
mov di,574
mov word[es:di],0x072b			;+sign
add di,2
mov word[es:di],0x0734			;4
add di,2
mov word[es:di],0x0720			;space
mov bx,[bp+6]
push di
push bx
call print_stack

;stack fourth line +6
mov di,734
mov word[es:di],0x072b			;+sign
add di,2
mov word[es:di],0x0736			;6
add di,2
mov word[es:di],0x0720			;space
mov bx,[bp+8]
push di
push bx
call print_stack

ret 8

memory_segment_2:
mov ax,0xb800
mov es,ax
mov di,2880
mov word[es:di],0x7032			;2

add di,22
mov word[es:di],0x0730			;0

add di,6
mov word[es:di],0x0731			;1

add di,6
mov word[es:di],0x0732			;2

add di,6
mov word[es:di],0x0733			;3

add di,6
mov word[es:di],0x0734			;4

add di,6
mov word[es:di],0x0735			;5

add di,6
mov word[es:di],0x0736			;6

add di,6
mov word[es:di],0x0737			;7

add di,10
mov word[es:di],0x0738			;8

add di,6
mov word[es:di],0x0739			;9

add di,6
mov word[es:di],0x0741			;A

add di,6
mov word[es:di],0x0742			;B

add di,6
mov word[es:di],0x0743			;C

add di,6
mov word[es:di],0x0744			;D

add di,6
mov word[es:di],0x0745			;E

add di,6
mov word[es:di],0x0746			;F

ret


memory_segement_1:
mov ax,0xb800
mov es,ax
mov di,1058
mov word[es:di],0x7031			;1

add di,18
mov word[es:di],0x0730			;0
add di,6
mov word[es:di],0x0731			;1
add di,6
mov word[es:di],0x0732			;2
add di,6
mov word[es:di],0x0733			;3
add di,6
mov word[es:di],0x0734			;4
add di,6
mov word[es:di],0x0735			;5
add di,6
mov word[es:di],0x0736			;6
add di,6
mov word[es:di],0x0737			;7

;printing first ds:0000

ret

memory_2digits:
mov ax,0xb800
mov es,ax
mov bp,sp
mov cx,[bp+4]
mov ch,0x02
mov ax,[bp+2]				;adress
mov bx,0x10					;divide by 16
mov di,3040
;printing first ds:0000
mov word[es:di],cx				;D/or any data segment
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
adress_loop_1:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne adress_loop_1
mov si,0
pop_adress_1:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne pop_adress_1
;printing second ds:0010
mov ax,[bp+2]				;adress
add al,0x10
mov bx,0x10
mov di,3200
mov ch,0x07
mov word[es:di],cx				;D/any segment
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
adress_loop_2:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne adress_loop_2

mov si,0
pop_adress_2:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne pop_adress_2

;printing third ds:0020
mov ax,[bp+2]				;adress
add al,0x20
mov bx,0x10
mov di,3360
mov word[es:di],cx				;D/any segment
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
adress_loop_3:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne adress_loop_3
mov si,0
pop_adress_3:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne pop_adress_3

;printing fourth ds:0030
mov ax,[bp+2]				;adress
add al,0x30
mov bx,0x10
mov di,3520
mov word[es:di],cx				;D/any segment
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
adress_loop_4:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne adress_loop_4
mov si,0
pop_adress_4:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne pop_adress_4

;printing fifth ds:0040
mov ax,[bp+2]				;adress
add al,0x40
mov bx,0x10
mov di,3680
mov word[es:di],cx				;D/any segment
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2
mov si,0
adress_loop_5:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne adress_loop_5
mov si,0
pop_adress_5:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne pop_adress_5

mov bx,[bp+2]				;adress
mov si,0
mov di,3060
mov cx,0
a:
push cx
t:
mov ax,[bx+si]
push bx
mov bx,10
mov cx,2
lmemory:
mov dx,0
div bx
add dl,0x30
push dx
sub cx,1
jnz lmemory
mov cx,2
loop_2memory:
pop dx
mov dh,0x02
mov word[es:di],dx
add di,2
sub cx,1
jnz loop_2memory
mov bx,10
mov cx,2
add di,2
l3memory:
mov dx,0
div bx
add dl,0x30
push dx
sub cx,1
jnz l3memory
mov cx,2
loop_3memory:
pop dx
mov dh,0x02
mov word[es:di],dx
add di,2
sub cx,1
jnz loop_3memory
pop bx
pop dx
mov cx,dx
push dx
add cx,8
add di,2
add si,2
cmp si,cx
jne t
add di,4
l4memory:
mov ax,[bx+si]
push bx
mov bx,10
mov cx,2
l5memory:
mov dx,0
div bx
add dl,0x30
push dx
sub cx,1
jnz l5memory
mov cx,2
l6memory:
pop dx
mov dh,0x02
mov word[es:di],dx
add di,2
sub cx,1
jnz l6memory
mov bx,10
mov cx,2
add di,2
l7memory:
mov dx,0
div bx
add dl,0x30
push dx
sub cx,1
jnz l7memory
mov cx,2
l8memory:
pop dx
mov dh,0x02
mov word[es:di],dx
add di,2
sub cx,1
jnz l8memory
pop bx
pop dx
mov cx,dx
push dx
add cx,16
add di,2
add si,2
cmp si,cx
jne l4memory
add di,60
pop cx
add cx,0x10
cmp cx,0x50
jne a

ret 4

memory_1digits:
mov ax,0xb800
mov es,ax
mov bp,sp
mov cx,[bp+4]
mov ch,0x02
mov ax,[bp+2]				;adress
mov bx,0x10					;divide by 16

mov di,1218
mov word[es:di],cx				;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
memory_adress_loop_1:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_1
mov si,0
memory_pop_adress_1:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_1

;printing first ds:0008
mov ax,[bp+2]				;adress
add al,0x08
mov bx,0x10
mov di,1378
mov ch,0x07
mov word[es:di],cx				;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2
mov si,0
memory_adress_loop_2:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_2
mov si,0
memory_pop_adress_2:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_2
;printing first ds:0010
mov ax,[bp+2]				;adress
add al,0x10
mov bx,0x10
mov di,1538
mov word[es:di],cx			;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2
mov si,0
memory_adress_loop_3:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_3
mov si,0
memory_pop_adress_3:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_3
;printing first ds:0018
mov ax,[bp+2]				;adress
add al,0x18
mov bx,0x10
mov di,1698
mov word[es:di],cx				;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
memory_adress_loop_4:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_4
mov si,0
memory_pop_adress_4:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_4
;printing first ds:0020
mov ax,[bp+2]				;adress
add al,0x20
mov bx,0x10
mov di,1858
mov word[es:di],cx				;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
memory_adress_loop_5:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_5
mov si,0
memory_pop_adress_5:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_5
;printing first ds:0028
mov ax,[bp+2]				;adress
add al,0x28
mov bx,0x10
mov di,2018
mov word[es:di],cx				;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2
mov si,0
memory_adress_loop_6:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_6
mov si,0
memory_pop_adress_6:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_6
;printing first ds:0030
mov ax,[bp+2]				;adress
add al,0x30
mov bx,0x10
mov di,2178
mov word[es:di],cx			;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2
mov si,0
memory_adress_loop_7:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_7
mov si,0
memory_pop_adress_7:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_7
;printing first ds:0038
mov ax,[bp+2]				;adress
add al,0x38
mov bx,0x10
mov di,2338
mov word[es:di],cx			;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
memory_adress_loop_8:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_8
mov si,0
memory_pop_adress_8:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_8
;printing first ds:0040
mov ax,[bp+2]				;adress
add al,0x40
mov bx,0x10
mov di,2498
mov word[es:di],cx			;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
memory_adress_loop_9:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_9
mov si,0
memory_pop_adress_9:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_9
;printing first ds:0048
mov ax,[bp+2]				;adress
add al,0x48
mov bx,0x10
mov di,2658
mov word[es:di],cx				;D
add di,2
mov word[es:di],0x0753			;S
add di,2
mov word[es:di],0x073A			;:
add di,2

mov si,0
memory_adress_loop_10:
mov dx,0
div bx
mov dh,02
add dl,0x30
push dx
add si,1
cmp si,4
jne memory_adress_loop_10
mov si,0
memory_pop_adress_10:
pop dx
mov word[es:di],dx			;0
add di,2
add si,1
cmp si,4
jne memory_pop_adress_10

mov bx,[bp+2]
mov si,0
mov di,1234
mov cx,0
memory_a:
push cx
memory_t:
mov ax,[bx+si]
push bx
mov bx,10
mov cx,2
lamemory:
mov dx,0
div bx
add dl,0x30
push dx
sub cx,1
jnz lamemory
mov cx,2
loop_2amemory:
pop dx
mov dh,0x02
mov word[es:di],dx
add di,2
sub cx,1
jnz loop_2amemory
mov bx,10
mov cx,2
add di,2
l3amemory:
mov dx,0
div bx
add dl,0x30
push dx
sub cx,1
jnz l3amemory
mov cx,2
loop_3amemory:
pop dx
mov dh,0x02
mov word[es:di],dx
add di,2
sub cx,1
jnz loop_3amemory
pop bx
pop dx
mov cx,dx
push dx
add cx,8
add di,2
add si,2
cmp si,cx
jne memory_t
add di,112
pop cx
add cx,8
cmp cx,0x50
jne memory_a

ret 4
print_junk:
mov ax,0xb800
mov es,ax
mov di,3012
mov ax,di
mov cx,0
junk:
mov word[es:di],0x072e
add di,2
m:
mov word[es:di],0x073d
add di,2
n:
mov word[es:di],0x0720
add di,2
p:
mov word[es:di],0x0766
add di,2
q:
mov word[es:di],0x0752
add di,2
r:
mov word[es:di],0x0728
add di,2
s:
mov word[es:di],0x0731
add di,2

add cx,2
add di,152
cmp cx,4
jbe m
add di,156
cmp cx,6
jbe n
add di,154
cmp cx,8
jbe p
add di,156
cmp cx,10
jbe p
add di,152
cmp cx,12
jbe q
ret
kbisr:
	push ax
	push es
	mov ax,0xb800
	mov es,ax
	in al,0x60
	cmp al,0x3b
	jne screen
software_interupt:
	push es
	push si
	xor si,si
	mov es,si
	mov word [es:1*4], trapisr ; store offset at n*4
	mov [es:1*4+2], cs ; store segment at n*4+2
	pushf ; save flags on stack
	pop si ; copy flags in ax
	or si, 0x100 ; set bit corresponding to TF
	push si ; save ax on stack
	popf ; reload into flags register
	mov ax,0
; the trap flag bit is on now, INT 1 will come after next instruction
; sample code to check the working of our elementary debugger
	mov ax,[ax_value]
	mov bx,[bx_value]
	mov cx,[cx_value]
	mov dx,[dx_value]
	l222: 
	inc ax
	mov word[ax_value],ax
	add bx, 2
	mov word[bx_value],bx
	dec cx
	mov word[cx_value],cx
	sub dx, 2
	mov word[dx_value],dx
	pushf ; save flags on stack
	pop si ; copy flags in ax
	xor si, 0x100; set bit corresponding to TF
	push si ; save ax on stack
	popf ; reload into flags register
	
	pop si
	pop es
	jmp exit_0
screen:
	cmp byte[flag],1
	je exit_1
	mov di,[di_memory]
	mov dx,[dx_memory]
screen_input:
	mov ah,0x02
	mov word[es:di],ax
	mov ah,0x02			;13 service for print string
	mov al,1			;subservice cursor update
	mov bh,0			;video memory page 0
	add dx,1			;rows on dh and coloumns on dl
D:
	int 0x10			;bios video service
	mov word[dx_memory],dx
	add di,2
	mov word[di_memory],di
	jmp exit_0
	
exit_0:
	mov byte[flag],1
	pop es
	pop ax
	jmp far[cs:oldisr]
exit_1:
	mov byte[flag],0
	pop es
	pop ax
	mov al,0x20
	out 0x20,al
	iret
	; jmp far[cs:oldisr]
start:
call clrscr

call line1
call line2
call line3
call line4
call line5
call line6
call Cmd
call flags
push 0x3c43
push 0x5678
push 0x1234
push 0x8756
call stack
call memory_segment_2
call memory_segement_1
push 0x0044
push 0x0210
call memory_2digits
push 0x0044
push 0x0210
call memory_1digits
call print_junk
xor ax, ax
mov es, ax ; point es to IVT base
mov ax,[es:9*4]
mov [oldisr],ax
mov ax,[es:9*4+2]
mov [oldisr+2],ax
cli
mov word[es:9*4],kbisr
mov word[es:9*4+2],cs
sti
lq:
mov ah,0
int 0x16
cmp al,27
jne lq

; mov ax,[oldisr]
; mov bx,[oldisr+2]
; cli
; mov word[es:9*4],ax
; mov word[es:9*4+2],bx
; sti


mov ax, 0x4c00 ; terminate program
int 0x21