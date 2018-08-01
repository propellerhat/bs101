#!/usr/bin/env bash

if ! [ $(id -u) = 0 ]; then
   echo "This script must be run with root privs. e.g. 'sudo ${0}'" >&2
   exit 1
fi

aslr_setting=$(sysctl -n kernel.randomize_va_space)
setting_description="Unknown"

if [ "${aslr_setting}" = "2" ]; then
    setting_description="Full"
elif [ "${aslr_setting}" = "1" ]; then
    setting_description="Partial"
elif [ "${aslr_setting}" = "0" ]; then
    setting_description="Off"
fi

echo "Current ASLR setting: ${aslr_setting} (${setting_description})"

if [ "${aslr_setting}" = "2" ]; then
    echo "Would you like to disable it [Yy/Nn]?"
    read response
    if [ "${response^^}" = "Y" ]; then
        echo "Disabling ASLR..."
        echo 0 | tee /proc/sys/kernel/randomize_va_space
    fi
else
    echo "Would you like to re-enable it [Yy/Nn]?"
    read response
    if [ "${response^^}" = "Y" ]; then
        echo "Enabling ASLR..."
        echo 2 | tee /proc/sys/kernel/randomize_va_space
    fi
fi

# This would disable it across reboots:
#echo "kernel.randomize_va_space = 0" > /etc/sysctl.d/01-disable-aslr.conf

