#!/usr/bin/env bash

if ! [ $(id -u) = 0 ]; then
   echo "This script must be run with root privs. e.g. 'sudo ${0}'" >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

sudo -u $real_user chmod +x gcc_unsafe

cd $HOME
sudo -u $real_user git clone https://github.com/aquynh/capstone.git
cd capstone/
sudo -u $real_user ./make.sh
./make.sh install
cd bindings/python/
make install
cd $HOME
sudo -u $real_user git clone https://github.com/JonathanSalwan/ROPgadget.git
cd ROPgadget/
python setup.py install
cd $HOME
sudo -u $real_user git clone https://github.com/longld/peda.git ~/peda
sudo -u $real_user echo "source ~/peda/peda.py" >> ~/.gdbinit
sudo -u $real_user chmod +x aslr_ctl.sh

echo "This script will disable ASLR systemwide until it is manually re-enabled"
echo "or until the machine restarts. The shell script 'aslr_ctl.sh' can be used"
echo "re-enable it. You can also use 'aslr_ctl.sh' to permenently disable aslr."

echo 0 | tee /proc/sys/kernel/randomize_va_space

