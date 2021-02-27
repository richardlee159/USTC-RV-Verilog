OUTPUT_ARCH(riscv)
OUTPUT_FORMAT(elf32-littleriscv)
ENTRY(_start)
BASE_ADDRESS = 0x80000000;

SECTIONS
{
    . = BASE_ADDRESS;

    _stext = .;
    .text : {
        *(.text.entry)
        *(.text .text.*)
    }

    . = ALIGN(4);
    _etext = .;
    _srodata = .;
    .rodata : {
        *(.rodata .rodata.*)
    }

    . = ALIGN(4);
    _erodata = .;
    _sdata = .;
    .data : {
        *(.data .data.*)
    }

    . = ALIGN(4);
    _edata = .;
    _sbss = .;
    .bss : {
        *(.bss .bss.*)
        *(.sbss .sbss.*)
    }

    . = ALIGN(4);
    _ebss = .;
    .stack : {
        *(.stack)
    }
}