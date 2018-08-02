# bs101

## Install

Run the following:

```bash
git clone https://github.com/propellerhat/bs101.git
cd bs101
chmod +x setup.sh
sudo ./setup.sh
```

Several tools are compiled from source, so be patient. It could take a while.

## Exercises

### Compile `hello.c`
 * Run the command `./gcc_unsafe hello.c`
 * You should notice a new file in the current directory named `hello`
 * Execute the binary that was just created by typing `./hello`
 * This is an ELF executable file. It's just like any other file, but with a few notable attributes.
 * Run `ls -l hello`. The first attribute that binary executables have is, well, they're executable.
 * Run `file hello`. Just like any other file, there is a well-defined file structure. The `file` utility will print some of the high-level information about the file to stdout.
 * To dig deep into an ELF binary, the utility `readelf` can be very informative. It can parse some or all of the sections in an ELF binary and print the results. `readelf -a hello` will print all of the sections and their associated info.
 * One section of the ELF file contains the actual x86 machine instructions that the compiler has emitted after processing our C source file. This section is called the `.text` section.
 * The `.text` section contains a sequence of machine instructions. A machine instruction is just a piece of data. Each instruction can be one or more bytes, depending on the type of instruction. Some instructions contain embedded data to be used by the CPU to carry out the operation. An example is adding a fixed value to a register.
 * When humans deal with machine instructions, we work with mnemonics that are easy to understand. Below is an example:
```assembly
push ebp
mov  ebp, esp
sub  esp, 16
xor  eax, eax
```
 * Instructions start with an English-like operation and are followed by any operands that the instruction operates on. There are two different 'flavors' of x86 assembly syntax. AT&T and Intel. The above example is Intel syntax, which lists destination operands first, and sources second. So the instruction `mov ebp, esp` will copy the contents of the register esp into the ebp register.
 * When a CPU deals with machine instructions, they are just bytes of data. The process of converting the human-readable mnemonics into raw bytes that the CPU understands is called assembly. The software program that performs the conversion is called an assembler.
 * A binary file (like our `hello` ELF binary) only contains the 'raw byte' form of machine code. In order to allow a human to examine a binary, a program called a disassembler must be used to translate the raw bytes back into a form that we can view and reason about.
 * `objdump` is a standard disassembler that can be used to examine a binary. Run `objdump -d hello` and examine the output.
 * You should notice that a lot of boilerplate code is included that we did not explicitly write. The disassembly is organized by function. Locate the `main` function and analyze the behavior and compare it to the source code.
