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
 * This is an ELF executable file. It's just like any other file, but with a few notable attributes.
 * Run `ls -l hello`. The first attribute that binary executables have is, well, they're executable.
 * Run `file hello`. Just like any other file, there is a well-defined file structure. The `file` utility will print some of the high-level information about the file to stdout.
 * To dig deep into an ELF binary, the utility `readelf` can be very informative. It can parse some or all of the sections in an ELF binary and print the results. `readelf -a hello` will print all of the sections and their associated info.
