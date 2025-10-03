AS = ./i686-elf/bin/i686-elf-as
CC = ./i686-elf/bin/i686-elf-gcc
MKDIR = mkdir -p

.PHONY: all kernel iso clean

all: tutos.iso

boot.o: boot.s
	${AS} boot.s -o boot.o

kernel.o: kernel.c
	${CC} -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

tutos.bin: boot.o kernel.o
	${CC} -T linker.ld -o tutos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

tutos.iso: tutos.bin
	${MKDIR} isodir/boot/grub
	cp tutos.bin isodir/boot
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o tutos.iso isodir

kernel: tutos.bin

iso: tutos.iso

clean:
	rm -rf *.o tutos.bin tutos.iso isodir
