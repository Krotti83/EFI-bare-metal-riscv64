# EFI-bare-metal-riscv64

Simple EFI application targeting RISC-V without any dependencies to GNU-EFI and/or EDK2. It's a
minimalistic `Hello World!` application in plain assembly.

### NOTE

Because my current used toolchain doesn't support, the PE+ image (EFI image) directly it will be 
handcrafted in assembly.

## Required toolchains

* GNU binutils targeting RISC-V

### NOTE
In this sample the GNU toolchains `riscv64-unknown-linux-gnu` are used. But I should also work with the
bare-metal version from the GNU toolchains, because the current code doesn't need to build with the
option position-interdependent code (`-fpic`).

## Building from the application

* Clone the sources
```
$ git clone https://github.com/Krotti83/EFI-bare-metal-riscv64.git
```

* Build the application
```
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
Hello World!
StarFive #
```
