# bs101

The material was designed and tested on 32bit x86 Kali Linux. It *should* work fine on any x86 32bit Linux.

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
 * Instructions start with an English-like operation and are followed by any operand(s) that the instruction operates on. There are two different 'flavors' of x86 assembly syntax. AT&T and Intel. The above example is Intel syntax, which lists destination operands first, and sources second. So the instruction `mov ebp, esp` will copy the contents of the register esp into the ebp register.
 * When a CPU deals with machine instructions, they are just bytes of data. The process of converting the human-readable mnemonics into raw bytes that the CPU understands is called assembly. The software program that performs the conversion is called an assembler.
 * A binary file (like our `hello` ELF binary) only contains the 'raw byte' form of machine code. In order to allow a human to examine a binary, a program called a disassembler must be used to translate the raw bytes back into a form that we can view and reason about.
 * `objdump` is a standard disassembler that can be used to examine a binary. Run `objdump -d hello` and examine the output.
 * You should notice that a lot of boilerplate code is included that we did not explicitly write. The disassembly is organized by function. Locate the `main` function and analyze the behavior and compare it to the source code.
 * Common file types have associated applications. If you 'open' a pdf file, the system will launch the default application that knows how to process a pdf file (e.g. Adobe Reader). In a similar fashion, when you 'execute' an ELF binary a program called the loader gets invoked. The loader will parse the ELF file and take certain actions. It will map the ELF file's different sections to various areas of memory (RAM). It will also map in any libraries that the binary leverages (functions like `printf()`). These libraries are shared among many programs.

#### Material
 * [corkami's wonderful ELF file format graphic](https://github.com/corkami/pics/blob/master/binary/elf101/elf101.pdf) (corkami has amazing graphics for many things)
 * `man elf`
 * `man objdump`
 * `man readelf`
 * [Linkers and Loaders](https://www.iecc.com/linker/).

### Byte Sex

There are two common ways that multi-byte integers and pointers are stored in memory in modern computing platforms. One way stores the least-significant byte at the lower memory address. This method is called little-endian. Some thought it would be logical to store integers in this way since the lowest address contains the least significant byte. However, that is not how most humans read information.

Keep this in mind when viewing memory. Most tools and debuggers will display information in ascending address order which will reverse pointers and integers. Also, memory copy operations happen from lowest to highest address. Therefore, when our input is copied around using `strcpy()` and the likes, we must account for the ascending order of the copy.

#### Material
 * [Endianness](https://en.wikipedia.org/wiki/Endianness)
 * [Are you a glutton for punishment?](https://blog.legitbs.net/2017/07/the-clemency-architecture.html)

### Negative Numbers (This section can be safely skipped)

 * `./gcc_unsafe twos_insult.c`
 * What do you expect to happen when we run the program?
 * What actually happens?
 * What is going on here (the compiler should give you a warning that hints at the underlying issue)?

#### Material
 * [Two's Compliment](https://en.wikipedia.org/wiki/Two%27s_complement)

### Compile `where_variables_live.c`
Depending on where you declare and initialize variables, they will end up in very different places.

 * Run `size -A where_variables_live | egrep '(bss|data|rdata|text)'`. Note the size of each section.
 * Change `char global_variable[10];` to `char global_variable[10000];`
 * Recompile and run the size command again. What has changed?
 * Change the string assigned to `global_initialized_variable` to something much longer (default is `"lel"`)
 * Recompile and run the size command again. What changed this time?
 * Change the size of `stack_array` from 64 to 2048. Recompile and run the size command.
 * Can you explain what you observed? Did it violate your expectations?

#### Material
 * [Program Memory](https://en.wikipedia.org/wiki/Data_segment#Program_memory)

### Compile `array.c`
This program is designed to highlight the fact that C is not doing any safety checking for you when you access memory. Everything is just pointers and offsets. The only thing that C is doing for you is keeping track of the underlying data types and calculating the offsets for you.
See if you can correlate each output line with the source line that caused it.

### Memory Trespass
Did you notice anything strange about `array.c`? In particular, line 28? Can you explain what is going on here? This is an illustration of what is possible with C's lack of memory safety. You can access arbitrary memory through the use of pointers and offsets that was probably never intended by the programmer.

### The C Runtime
"The greatest trick that C ever pulled was convincing the world it doesn't have a runtime." -- Dan Guido, probably (One of his hn comments is where I saw it first so he gets the credit)

You'd be forgiven for having the mindset that C doesn't have a runtime. When you really think about it, a typical compiled binary written in C is not fully self-contained. Run `ldd array`. The output of the `ldd` command will be a list of the shared libraries the specific binary is linked against. You should notice an entry that contains `ld-linux.so.2` or similarly named shared object file. This is the dynamic loader. It's responsible for resolving all other runtime dependencies, loading the appropriate libraries into the process memory space, and fixing up all references to said dependencies. You can further see this if you run `readelf -a array` and look for entries with `INTERP`. You may see some text like "[Requesting program interpreter: /lib/ld-linux.so.2]." As the text in the `readelf` output implies, control isn't directly passed to the binary. Instead, the "interpreter" is invoked and it is responsible for setting up the runtime environment for the binary and then passing execution control off to it.

In addition to setting up the initial environment for the binary, the loader can also provide lazy library function resolution at the time of the function call. This can be seen in a debugger in some cases. Look for functions named `_dl_runtime_resolve` or similar.

#### Material
 * [Runtime Symbol Resolution](https://www.slideshare.net/kentarokawamoto/runtime-symbol-resolution)

### Runtime Data Structures
There are several data structures that exist only at runtime. The heap and the stack are two examples. We will be ignoring the heap, but feel free to browse the links at the end of this section if you're curious.

#### Runtime Stack
On x86, the runtime stack is a hardware supported runtime data structure. Technically, this is an architecture-level data structure (below even C). Several assembly instructions exist to manipulate the stack.
```assembly
push <register|immediate> ; This adds the contents of a register (or an constant value) to the top of the stack
pop <resgister> ; This removes an item from the top of the stack and places it into a register
```

There is even a special register dedicated to storing the address of the top of the stack called `esp` (or just the stack pointer). When `push` or `pop` instructions are executed, the stack pointer (`esp`) is adjusted automatically. By convention, the use of another register, `ebp`, is reserved for storing the start of a function's stack frame. `ebp` is not automatically updated and its use as the base pointer is purely by convention and not enforced by the architecture in the same way as `esp`.

#### Material
 * [Dynamic Memory](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation)

### cdecl Calling Convention
Compile `calling_convention.c` and inspect the assembly code produced. Try to correlate what you see in the source file with the assembly produced. You will notice that:

 * If a function (subroutine) takes any arguments, they are pushed onto the stack in reverse order.
 * If the calling function wants to preserve register values in `eax`, `ecx` or `edx`, it must save them (usually by `push`ing them on the stack and `pop`ping them when the function returns.
 * The most sensible way to call a function is to use the `call` assembly instruction. This instruction implicitly `push`es the instruction pointer onto the stack.
 * Within the called function, if any registers are going to be used, their value is saved at the beginning of the subroutine and restored before the `ret` instruction. The most common saved register is `ebp`. This is why the first instruction in almost every subroutine is `push ebp`
 * All function local variables live on the stack. You will usually see a direct manipulation of `esp` to make room for local variables (e.g. `sub esp,0x20`). This must be undone towards the end of the function.
 * Returning a value from a function is accomplished by storing that value in the `eax` register.
 * The assembly instruction `ret` is equivalent to `pop eip`

### Smashing the Stack
Given what we know about how the stack is used, compile `crashme.c` and try to crash the program. What happens when the program crashes? How did you accomplish this? What is going on under the hood to cause the program to crash?

### Hijacking Control Flow
Now it's time to use what you have learned to do something useful. Compile `first_shell.c` and try to get a shell. How will you accomplish this?
