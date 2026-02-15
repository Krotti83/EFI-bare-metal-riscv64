
# EFI-bare-metal-riscv64
#
# Simple EFI application targeting RISC-V without any dependencies to
# GNU-EFI and/or EDK2.
#
# Copyright (c) 2026 Johannes Krottmayer <krotti83@proton.me>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

# Target
TARGET			:= hello
TARGET_EFI		:= $(TARGET).efi
TARGET_ELF		:= $(TARGET).elf
TARGET_MAP		:= $(TARGET).map

# Cross compile
ifeq ($(CROSS_COMPILE),)
CROSS_COMPILE		= riscv64-unknown-linux-gnu-
endif

# Generic shell commands
RM			:= rm -rf
CP			:= cp -Rf

# Toolchain
AS			:= $(CROSS_COMPILE)as
LD			:= $(CROSS_COMPILE)ld
OBJCOPY			:= $(CROSS_COMPILE)objcopy

# Assembler flags
ASFLAGS			+= -march=rv64gc

# Linker flags
LDFLAGS			+= -T ./ld/efiapp.ld
LDFLAGS			+= -Map $(TARGET_MAP)
LDFLAGS			+= --print-map-locals

include ./src/files.mk

EFIAPP_AOBJ		+= $(EFIAPP_ASRC:.S=.o)

#
# All
#
all: efiapp

efiapp: $(EFIAPP_AOBJ)
	@echo "   [LD]        $(TARGET_ELF)"
	@$(LD) $(LDFLAGS) -o $(TARGET_ELF) $(EFIAPP_AOBJ)
	@echo "   [OBJCOPY]   $(TARGET_EFI)"
	@$(OBJCOPY) -O binary $(TARGET_ELF) $(TARGET_EFI)

#
# EFI application
#

# Assemble assembly sources
$(EFIAPP_AOBJ): %.o: %.S
	@echo "   [AS]        $@"
	@$(AS) -c $(ASFLAGS) -o $@ $<

#
# Clean
#
.PHONY: clean
clean:
	@echo "   [CLEAN]"
	@$(RM) $(EFIAPP_AOBJ)
	@$(RM) $(TARGET_ELF)
	@$(RM) $(TARGET_MAP)
	@$(RM) $(TARGET_EFI)
