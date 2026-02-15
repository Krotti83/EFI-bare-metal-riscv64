/**
 *
 * EFI-bare-metal-riscv64
 *
 * Simple EFI application targeting RISC-V without any dependencies to
 * GNU-EFI and/or EDK2.
 *
 * Copyright (c) 2026 Johannes Krottmayer <krotti83@proton.me>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

.section .peheader, "a", %progbits
_header_s:
/**
 * PE+: MS-DOS file header
 */
header_msdos:
    .ascii "MZ"
    .skip 58
    .word header_pe - header_msdos
header_pe:
    .ascii "PE\0\0"

/**
 * PE+: COFF file header
 */
header_coff:
    .short 0x5064                           /* Machine: IMAGE_FILE_MACHINE_RISCV64 */
    .short 3                                /* NumberOfSections */
    .word 0                                 /* TimeDateStamp */
    .word 0                                 /* PointerToSymbolTable */
    .word 0                                 /* NumberOfSymbols */
    .short _header_opt_e - _header_opt_s    /* SizeOfOptionalHeader */
    .short 0x206                            /* Characteristics */

/**
 * PE+: Optional header standard fields
 */
_header_opt_s:
header_opt:
    .short 0x020B                           /* Magic: PE+ */
    .byte 0x1                               /* MajorLinkerVersion */
    .byte 0x0                               /* MinorLinkerVersion */
    .word _text_e - _text_s                 /* SizeOfCode */
    .word _rodata_e - _rodata_s             /* SizeOfInitializedData */
    .word 0                                 /* SizeOfUninitializedData */
    .word _start - _image_s                 /* AddressOfEntryPoint */
    .word _text_s - _image_s                /* BaseOfCode */

/**
 * PE+: Optional header Windows-specific fields
 */
header_win:
    .quad 0                                 /* ImageBase */
    .word 0x1000                            /* SectionAlignment */
    .word 0x1000                            /* FileAlignment */
    .short 0                                /* MajorOperatingSystemVersion */
    .short 0                                /* MinorOperatingSystemVersion */
    .short 0                                /* MajorImageVersion */
    .short 0                                /* MinorImageVersion */
    .short 0                                /* MajorSubsystemVersion */
    .short 0                                /* MinorSubsystemVersion */
    .word 0                                 /* Win32VersionValue */
    .word _image_e - _image_s               /* SizeOfImage */
    .word _header_e - _header_e             /* SizeOfHeaders */
    .word 0                                 /* CheckSum */
    .short 10                               /* Subsystem: IMAGE_SUBSYSTEM_EFI_APPLICATION */
    .short 0                                /* DllCharacteristics */
    .quad 0                                 /* SizeOfStackReserve */
    .quad 0                                 /* SizeOfStackCommit */
    .quad 0                                 /* SizeOfHeapReserve */
    .quad 0                                 /* SizeOfHeapCommit */
    .word 0                                 /* LoaderFlags */
    .word 16                                /* NumberOfRvaAndSizes */
    .quad 0                                 /* ExportTable */
    .quad 0                                 /* ImportTable */
    .quad 0                                 /* ResourceTable */
    .quad 0                                 /* ExceptionTable */
    .quad 0                                 /* CertificateTable */
    .word _reloc_s - _image_s               /* BaseRelocationTable (Address) */
    .word _reloc_e - _reloc_s               /* BaseRelocationTable (Size) */
    .quad 0                                 /* Debug */
    .quad 0                                 /* Architecture (Reserved, must be 0) */
    .quad 0                                 /* GlobalPtr */
    .quad 0                                 /* TLSTable */
    .quad 0                                 /* LoadConfigTable */
    .quad 0                                 /* BoundImport */
    .quad 0                                 /* IAT */
    .quad 0                                 /* DelayImportDescriptor */
    .quad 0                                 /* CLRRuntimeHeader */
    .quad 0                                 /* Reserved, must be zero */
_header_opt_e:

/**
 * PE+: Section Table
 */
table_section:
table_section_text:
    .ascii ".text\0\0\0"                    /* Name */
    .word _text_e - _text_s                 /* VirtualSize */
    .word _text_s                           /* VirtualAddress */
    .word _text_e - _text_s                 /* SizeOfRawData */
    .word _text_s                           /* PointerToRawData */
    .word 0                                 /* PointerToRelocations */
    .word 0                                 /* PointerToLineNumbers */
    .short 0                                /* NumberOfRelocations */
    .short 0                                /* NumberOfLineNumbers */
    .word 0x60000020                        /* Characteristics */

table_section_reloc:
    .ascii ".reloc\0\0"                     /* Name */
    .word _reloc_e - _reloc_s               /* VirtualSize */
    .word _reloc_s                          /* VirtualAddress */
    .word _reloc_e - _reloc_s               /* SizeOfRawData */
    .word _reloc_s                          /* PointerToRawData */
    .word 0                                 /* PointerToRelocations */
    .word 0                                 /* PointerToLineNumbers */
    .short 0                                /* NumberOfRelocations */
    .short 0                                /* NumberOfLineNumbers */
    .word 0x42000040                        /* Characteristics */

table_section_rodata:
    .ascii ".rodata\0"                      /* Name */
    .word _rodata_e - _rodata_s             /* VirtualSize */
    .word _rodata_s                         /* VirtualAddress */
    .word _rodata_e - _rodata_s             /* SizeOfRawData */
    .word _rodata_s                         /* PointerToRawData */
    .word 0                                 /* PointerToRelocations */
    .word 0                                 /* PointerToLineNumbers */
    .short 0                                /* NumberOfRelocations */
    .short 0                                /* NumberOfLineNumbers */
    .word 0x40000040                        /* Characteristics */
_header_e:
