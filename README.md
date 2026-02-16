# EFI-bare-metal-riscv64

Simple EFI application targeting RISC-V without any dependencies to GNU-EFI and/or EDK2. It's a
minimalist `Hello World!` application in plain assembly.

### NOTE

The PE+ image header [(src/peheader.S)](https://github.com/Krotti83/EFI-bare-metal-riscv64/blob/main/src/peheader.S) is handcrafted in assembly in this sample. So therefore at 
least `objcopy` doesn't *must* support the output of PE+ images directly.

## Required toolchains

* GNU binutils targeting RISC-V (only `as`, `ld`, `objcopy` needed)

### NOTE
In this sample the GNU toolchains `riscv64-unknown-linux-gnu` are used. But I should also work with the
bare-metal version from the GNU toolchains, because the current code doesn't need to build with the
option position-independent code (`-fpic`).

## Building from the application

* Clone the sources
```
$ git clone https://github.com/Krotti83/EFI-bare-metal-riscv64.git
```

* Build the application
```
$ cd EFI-bare-metal-riscv64
$ make
```

## Output

On successful build the root directory from the sources should contain the EFI application `hello.efi`.
All other created files can be ignored in the following steps.

## Run the application

### QEMU through U-Boot

* Load the EFI image into memory
```
=> fatload virtio 0:1 0x1100000000 hello.efi
```
* Start the application
```
=> bootefi 0x1100000000
Booting /hello.efi
Hello World!
=>
```

### VisionFive 2 through U-Boot (real hardware)

* Load the EFI image into memory
```
StarFive # fatload mmc 1:3 0x500000000 hello.efi
```
* Start the application
```
StarFive # bootefi 0x500000000
Booting /hello.efi
Hello World!
StarFive #
```

## TODO

* Add *real* relocation support

Currently a dummy `.reloc` section is used in the code, because most of the EFI loaders
require a relocatable PE+ image. If not they refuse the execution of the code.

* Reduce size of resulting binary image

Currently the sections are page aligned (4KiB) in the output. Will try to reduce the size
of the EFI image later.

## Used documentation

[UEFI Specification 2.11](https://uefi.org/specs/UEFI/2.11/)  
[Portable Executable (PE+) Image Format](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format)  
[U-Boot Documentation](https://docs.u-boot.org/en/latest/usage/index.html)  
