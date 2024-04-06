print_string:
    mov ah, 0x0e
    sub:
        mov al, [bx]
        cmp al,0
        je exit
        int 0x10
        add bx, 1
        jmp sub
    exit:
        ret



