#!/usr/bin/env bash
echo 0 > /proc/sys/kernel/randomize_va_space
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit
echo "DONE! debug your program with gdb and enjoy"
chmod +x gcc_unsafe
