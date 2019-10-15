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
    echo "Solo root puede ejecutar este script"
    exit 1
fi

source functions.sh

echo -e "Choose password for root\n"
passwd 

local_user="marcos"

system_update
etckeeper_init
configure_user
change_homes_file_mode_bites
install_version_control
install_compilation_environment
install_ssh_fail2ban
install_misc
install_fail2ban
install_local_backups
configure_grub
restart_services
