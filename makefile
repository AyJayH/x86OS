C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h )


OBJ = ${C_SOURCES:.c=.o}

all: os-image

run: all
	sudo qemu-system-i386 os-image
	
os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image	
	
kernel.bin: kernel/entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

%.o : %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@
	
%.o : %.asm
	nasm $< -f elf64 -o $@
%.bin : %.asm
	nasm $< -f bin -I '../../16 bit /' -o $@
clean :
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o
	
	
	
	
