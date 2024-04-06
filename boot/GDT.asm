; GDT
gdt_start:

gdt_null: ; null descriptor
    dd 0x0 
    dd 0x0
gdt_code : ; code segment
; base 0x0 , limit 0xfffff
    dw 0xffff ; Limit
    dw 0x0 ; Base
    db 0x0 ; Base
    db 10011010b ; flags
    db 11001111b 
    db 0x0 ; Base 

gdt_data: ; the data segment descriptor
    dw 0xffff ; Limit
    dw 0x0 ; Base
    db 0x0 ; Base
    db 10010010b ; flags
    db 11001111b 
    db 0x0 ; Base 
gdt_end: ;Used for calculation
gdt_descriptor:
dw gdt_end - gdt_start - 1 ; Size of GDT
dd gdt_start ; Start address of our GDT

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
