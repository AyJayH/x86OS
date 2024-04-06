; load DH sectors to ES:BX from drive DL
disk_load :
    push dx ; Store DX on stack
    mov ah , 0x02 ; BIOS read sector function
    mov al , dh ; Read DH sectors
    mov ch , 0x00 ; Cylinder 0
    mov dh , 0x00 ; Head 0
    mov cl , 0x02 ; Sector 2
    int 0x13 ; BIOS interrupt to start reading
    pop dx ; Restore DX from the stack
    ret

