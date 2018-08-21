#!/usr/bin/env bash

# This bizzar thing below makes sure we are in the script's directory.
# Text below is from https://stackoverflow.com/questions/6393551/what-is-the-meaning-of-0-in-a-bash-script
#
#It is called Parameter Expansion. Take a look at this page and the rest of the site.
#What ${0%/*} does is, it expands the value contained within the argument 0 (which is the path that called the script) after removing the string /* suffix from the end of it.
#So, $0 is the same as ${0} which is like any other argument, eg. $1 which you can write as ${1}. As I said $0 is special, as it's not a real argument, it's always there and represents name of script. Parameter Expansion works within the { } -- curly braces, and % is one type of Parameter Expansion.
#%/* matches the last occurrence of / and removes anything (* means anything) after that character.
cd "${0%/*}"

if ! [ $(id -u) = 0 ]; then
   echo "This script must be run with root privs. e.g. 'sudo ${0}'" >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

sudo -u $real_user chmod +x aslr_ctl.sh
sudo -u $real_user chmod +x gcc_unsafe

cd /home/"${real_user}"
sudo -u $real_user git clone https://github.com/pwndbg/pwndbg
cd pwndbg/
sudo -u $real_user ./setup.sh
cd /home/"${real_user}"

echo "This script will disable ASLR systemwide until it is manually re-enabled"
echo "or until the machine restarts. The shell script 'aslr_ctl.sh' can be used"
echo "re-enable it. You can also use 'aslr_ctl.sh' to permenently disable aslr."

echo 0 | tee /proc/sys/kernel/randomize_va_space

