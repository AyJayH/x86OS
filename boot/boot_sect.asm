[ org 0x7c00 ]
KERNEL_OFFSET equ 0x1000

mov [BOOT_DRIVE], dl
mov bp , 0x9000 ; Set the stack.
mov sp , bp
mov bx , MSG_REAL_MODE
call print_string

call load_kernel

call switch_to_pm ; Doesn't return
jmp $ ; Hang
%include "boot/print_string.asm"
%include "boot/GDT.asm"
%include "boot/switch.asm"
%include "boot/Disk_Load.asm"


[ bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string

    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[ bits 32]
; Change to 32-bit once program jumps to BEGIN_PM
BEGIN_PM :
mov eax, 0xffffffff  ; Timer before calling kernel
loop:
    sub eax, 1
    cmp eax, 0
    jne loop

call KERNEL_OFFSET ; Doesn't return from kernel
jmp $ ; Hang.
; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db " Started in 16 - bit Real Mode " , 0
MSG_PROT_MODE db " Successfully landed in 32 - bit Protected Mode " , 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0
; Bootsector padding
times 510 -( $ - $$ ) db 0
dw 0xaa55
