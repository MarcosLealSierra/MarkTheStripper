#! /bin/bash

# Deploy and configure server. 
# Copyright © 2019 Marcos Leal Sierra

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [[ $(id -u) -ne 0 ]]; then
    echo "Need to be root"
    exit 1
fi

source functions.sh

clear 
read -p "Set your domain: " domain
read -p "Choose password for root: " rootpasswd
read -p "Set your username: " local_user
read -p "Choose an SSH Port: " port

IP=$(hostname -I | awk '{print $1 " "}')
echo "${IP}     ${HOSTNAME}.${domain} ${HOSTNAME}" >> /etc/hosts

echo "root:$rootpasswd" | chpasswd

configure_user
configure_root_user
etckeeper_init
system_update
set_hosts
install_editor
install_version_control
install_compilation_environment
install_ssh_fail2ban
install_misc
install_monitoring
install_local_backups
install_modsecurity
install_php
configure_grub
configure_modsecurity_owasp
configure_apache
configure_iptables
change_homes_file_mode_bites
customize_crontab
configure_mysql
restart_services
