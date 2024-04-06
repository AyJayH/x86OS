; Switch from 16 to 32 bit

[ bits 16]
switch_to_pm :
cli ; Interrupt disable
lgdt [ gdt_descriptor ] ; Load our global descriptor table
or eax , 0x1 ; the first bit of CR0 , a control register
mov cr0 , eax

jmp CODE_SEG : init_pm ; far jump forces cpu to flush pipeline 
[ bits 32]
; Initialise registers and the stack once in PM.
init_pm :
mov ax , DATA_SEG ; old segments are meaningless ,
mov ds , ax 
mov ss , ax 
mov es , ax
mov fs , ax
mov gs , ax
mov ebp , 0x90000 ; Update stack position so it is right
mov esp , ebp ; at the top of the free space.
call BEGIN_PM ; exit to known function
