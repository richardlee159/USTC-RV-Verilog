CROSS = riscv64-unknown-elf

CC = $(CROSS)-gcc
AS = $(CROSS)-as
LD = $(CROSS)-ld
OC = $(CROSS)-objcopy

CFLAGS  = -Wall -Og -nostdinc -I./include -fomit-frame-pointer -march=rv32i -mabi=ilp32 -static
ASFLAGS = -march=rv32i
LDFLAGS = -T $(PROJ).ld
OCFLAGS = -O binary

PROJ = riscv
OBJS = init.o main.o stdio.o

all: $(PROJ).mem

clean:
	-bash -c 'rm -f *.o $(PROJ).{bin,mem} $(PROJ)'

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

$(PROJ): $(OBJS)
	$(LD) $(LDFLAGS) $+ -o $@ 

$(PROJ).bin: $(PROJ)
	$(OC) $(OCFLAGS) $< $@

$(PROJ).mem: $(PROJ).bin
	hexdump -ve '1/4 "%08x\n"' $< > $@
	wc -l $@