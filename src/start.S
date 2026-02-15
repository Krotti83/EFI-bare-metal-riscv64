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

/**
 * .text Section
 */
.text
.global _start
_start:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd fp, 0(sp)
    addi fp, sp, 16

    ld a0, 64(a1)
    ld t0, 8(a0)
    la a1, string_hello
    jalr t0

    ld ra, 8(sp)
    ld fp, 0(sp)
    addi sp, sp, 16
    ret

/**
 * .rodata Section
 */
.section .rodata

/* UTF-16 encode output string */
string_hello:
.byte 'H'
.byte 0
.byte 'e'
.byte 0
.byte 'l'
.byte 0
.byte 'l'
.byte 0
.byte 'o'
.byte 0
.byte ' '
.byte 0
.byte 'W'
.byte 0
.byte 'o'
.byte 0
.byte 'r'
.byte 0
.byte 'l'
.byte 0
.byte 'd'
.byte 0
.byte '!'
.byte 0
.byte '\r'
.byte 0
.byte '\n'
.byte 0
.byte 0
.byte 0
