# bs101

A violently fast-paced introduction to stack smashing. There are countless such "courses" out there. All (including this one) have a major issue: depth vs. breadth. It is not possible to get this balance right unless you have only one student and you tailor the material specifically for that person's experience and prior knowledge. Knowing that a sane balance cannot be achieved, I've included a section at the end of each exercise for the student to dig deeper based on their experience level. There will be beginner material and reference guides as well as more advanced material for those who have prior experience in the subject.

Why make *another* one of these? Valid question. I sometimes teach this to my fellow collogues as part of hack nights and similar venues. Going this route is much better than using an existing material set. I can tweak the material here and there to get a *not terrible* breadth/depth balance based on the time I have to get people through it and the experience level of the attendees.

This specific material set has been tweaked over time to fit into a 2 hour hack night session. People will feel like a stone skipping across a very deep lake, but the goal is to get students interested in learning this stuff on their own. It's a good way for people to get their feet wet and get them excited with some early success.

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

### C Variables, Data, and Arrays

Unlike most modern programming languages, C has a very limited set of atomic variable types.

 * Integers. These come in many sizes and can be signed or unsigned. The default size of an integer when declared using `int` varies from system to system. For our environment, they happen to be 4 bytes.
 * Floating point variables. `floats` and `double` precision floats.
 * Pointers. These are memory addresses. Their size depends on the platform. For 32bit platforms they are 4 bytes.
 * Characters. You can think of these as unsigned 8 bit integers. On some platforms, one is defined in terms of the other.

### Byte Sex

There are two common ways that multi-byte integers and pointers are stored in memory in modern computing platforms. One way stores the least-significant byte at the lower memory address. This method is called little-endian. Some thought it would be logical to store integers in this way since the lowest address contains the least significant byte. However, that is not how most humans read information.

Keep this in mind when viewing memory. Most tools and debuggers will display information in ascending address order which will reverse pointers and integers. Also, memory copy operations happen from lowest to highest address. Therefore, when our input is copied around using `strcpy()` and the likes, we must account for the ascending order of the copy.

#### Material
 * [Endianness](https://en.wikipedia.org/wiki/Endianness)
 * [Are you a glutton for punishment?](https://blog.legitbs.net/2017/07/the-clemency-architecture.html)

### Negative Numbers

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


### Memory Trespass
Did you notice anything strange about `array.c`? In particular, line 28? This is an illustration of C's lack of memory safety.

### The C Runtime
"The greatest trick that C ever pulled was convincing the world it doesn't have a runtime." -- Dan Guido (i think. one of his hn comments is where I saw it first.)

### Runtime Data Structures
There are several data structures and components to the C runtime.
 * The runtime resolver.
 * A memory manager (when you invoke `malloc()` family of functions)
 * Several data structures

#### Runtime Stack
For our purposes, we will focus on the runtime stack. On x86, the runtime stack is a hardware supported runtime data structure.

More materials coming soon.

### cdecl Calling Convention
More material coming soon.

### Hijacking Control Flow
Additional material coming soon.
