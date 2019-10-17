#! /bin/bash

dpkg_lock () {
    fuser -vki /var/lib/dpkg/lock
    rm -fv /var/lib/dpkg/lock
    dpkg --configure -a
    apt autoremove
}

dpkglock=$(declare -f dpkg_lock)

sudo bash << EOF 
$dpkglock
dpkg_lock
EOF
