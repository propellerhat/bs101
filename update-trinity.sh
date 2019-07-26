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

LOGFILE=/tmp/update-trinity.log
NB_CPU="$(grep -c processor /proc/cpuinfo)"

exec >${LOGFILE}
set -e

echo "[+] Log file is in '${LOGFILE}'" >&2
echo "[+] Starting compilation on ${NB_CPU} core(s)" >&2

pushd .

echo "[+] Installing keystone + bindings" >&2
pushd /tmp
sudo -u $real_user git clone --quiet https://github.com/keystone-engine/keystone.git
sudo -u $real_user mkdir -p keystone/build && cd keystone/build
sudo -u $real_user sed -i "s/make -j8/make -j${NB_CPU}/g" ../make-share.sh
sudo -u $real_user ../make-share.sh
make install
cd ../bindings/python
make install install3
popd
echo "[+] Done" >&2

echo "[+] Installing capstone + bindings" >&2
pushd /tmp
sudo -u $real_user git clone --quiet https://github.com/aquynh/capstone.git
cd capstone
sudo -u $real_user ./make.sh default -j${NB_CPU}
./make.sh install
cd ./bindings/python
make install install3
popd
echo "[+] Done" >&2

echo "[+] Installing unicorn + bindings" >&2
pushd /tmp
sudo -u $real_user git clone --quiet https://github.com/unicorn-engine/unicorn.git
cd unicorn
sudo -u $real_user UNICORN_QEMU_FLAGS="--python=`which python2`" MAKE_JOBS=${NB_CPU} ./make.sh
./make.sh install
cd ./bindings/python
make install install3
popd
echo "[+] Done" >&2

echo "[+] Cleanup" >&2
rm -fr -- /tmp/{keystone,capstone,unicorn}
ldconfig

popd
