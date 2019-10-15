#! /bin/bash

system_update() {
    apt update && apt upgrade -y
}

etckeeper_init() {
    apt install -y etckeeper -y
    etckeeper init
    etckeeper commit "First commit"
}

etccommiter() {
    etckeeper commit "[$(basename $0)]: $@"
}

change_homes_file_mode_bites() {
    chmod -R 0700 /home/* /root;
    sed -i 's/DIR_MODE=0755/DIR_MODE=0700/' /etc/adduser.conf;
    etccommiter "set homes file mode bites to 0700"
}

configure_grub() {
    echo "GRUB_RECORDFAIL_TIMEOUT=5" >> /etc/default/grub
    update-grub
    etccommiter "Configure grub"
}

configure_user() {
    adduser $local_user
    cp templates/userbashrc "/home/$local_user/.bashrc"
    cp templates/userbashaliases "/home/$local_user/.bash_aliases"
    cp templates/.vimrc "/home/$local_user/.vimrc"
    cp -R templates/.vim "/home/$local_user/.vim"
    mkdir "/home/$local_user/.ssh"
    cp templates/authorized_keys "/home/$local_user/.ssh/" 
    chown -R $local_user:$local_user "/home/$local_user/.vimrc" "/home/$local_user/.ssh" \
        "/home/$local_user/.bashrc" "/home/$local_user/.bash_aliases" \
        "/home/$local_user/.vim"
    chmod -R 0700 /home/$local_user/.ssh
}

customize_crontab() {
    if ! ( crontab -l | grep -q ntpdate ); then
        TMPCRONFILE=$(mktemp /tmp/cron.XXXXXXXXX)
        cat >> $TMPCRONFILE << EOF
PATH=/usr/sbin:/usr/bin:/sbin:/bin

$(crontab -l)
# aviso de equipo reiniciado
@reboot echo "El equipo \`hostname\` ha sido reiniciado!"

# sincronización horaria
55 23 * * * ntpdate hora.roa.es | logger -t NTP
@reboot ntpdate hora.roa.es | logger -t NTP
EOF
    crontab $TMPCRONFILE
    rm $TMPCRONFILE
    fi
}

install_local_backups() {
    mv /root/src/servers/backup /etc/
    cp -R /root/src/servers/cron.daily /etc/
    chown -R root. /etc/backup
    etccommiter "Install local backups"
}

install_version_control() {
    apt install -y bzr git git-extras

    git config --global user.name "Marcos Leal Sierra"
    git config --global user.email marcoslealsierra90@gmail.com

    etccommiter "Install and configure control version packages"
}

install_compilation_environment() {
    apt install -y build-essential linux-headers-$(uname -r) psmisc apt-utils
    etccommiter "Install basic compilation environment packages"
}

install_ssh_fail2ban() {
    echo -n "Choose a port for SSH:"
    read port
    apt install -y openssh-client openssh-server fail2ban
    ssh-keygen
    cp templates/authorized_keys /root/.ssh/authorized_keys
    cp templates/sshd_config /etc/ssh/sshd_config
    cp templates/fail2ban /etc/fail2ban/jail.local 
    sed -i 's/^bantime.*=.*$/bantime = 3600/g' /etc/fail2ban/jail.local 
    sed -i "s/^port.*=.*ssh$/&,$port/g" /etc/fail2ban/jail.local 
    sed -i "s/Port/Port $port/g" /etc/ssh/sshd_config
    /etc/init.d/fail2ban restart
    iptables -nL
    etccommiter "Install and configure SSH & fail2ban"
}

install_misc() {
    apt install -y cron ntpdate wget tmux lshw rsync
    etccommiter "Install miscellaneous pacakges"
}

install_monitoring() {
    apt install -y atop sysstat smartmontools net-tools
    etccommiter "Install utility and monitoring packages"
}

install_editor() {
    apt install -y vim vim-scripts
    update-alternatives --set editor /usr/bin/vim.basic
}

restart_services() {
    /etc/init.d/ssh restart
}
