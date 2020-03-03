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

install_editor() {
    apt install -y vim vim-nox vim-scripts
    update-alternatives --set editor /usr/bin/vim.basic
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
    apt install -y openssh-client openssh-server fail2ban
    ssh-keygen
    cp templates/authorized_keys /root/.ssh/authorized_keys
    cp templates/sshd_config /etc/ssh/sshd_config
    cp templates/fail2ban /etc/fail2ban/jail.local 
    sed -i 's/^bantime.*=.*$/bantime = 3600/g' /etc/fail2ban/jail.local 
    sed -i "s/^port.*=.*ssh$/&,$port/g" /etc/fail2ban/jail.local 
    sed -i "s/Port/Port $port/g" /etc/ssh/sshd_config
    /etc/init.d/fail2ban restart
    etccommiter "Install and configure SSH & fail2ban"
}

install_misc() {
    apt install -y apache2 mariadb-server cron ntpdate wget tmux lshw rsync
    etccommiter "Install miscellaneous pacakges"
}

install_monitoring() {
    apt install -y atop sysstat smartmontools net-tools
    etccommiter "Install utility and monitoring packages"
}

install_local_backups() {
    mv /root/src/servers/backup /etc/
    cp -R /root/src/servers/cron.daily /etc/
    chown -R root. /etc/backup
    etccommiter "Install local backups"
}

install_modsecurity() {
    apt install -y libapache2-mod-security2
    mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
    /etc/init.d/apache2 restart
}

configure_root_user() {
    cp templates/rootbashrc "/root/.bashrc"
    cp templates/.vimrc "/root/.vimrc"
    cp -R templates/.vim "/root/.vim"
    cp templates/.tmux.conf "/root/.tmux.conf"
    cp -R templates/.tmux "/root/.tmux"
    echo "source ~/.bashrc" >> "/root/.profile"
}

configure_user() {
    adduser $local_user
    cp templates/userbashrc "/home/$local_user/.bashrc"
    cp templates/userbashaliases "/home/$local_user/.bash_aliases"
    cp templates/.vimrc "/home/$local_user/.vimrc"
    cp templates/.tmux.conf "/home/$local_user/.tmux.conf"
    cp -R templates/.tmux "/home/$local_user/.tmux"
    cp -R templates/.vim "/home/$local_user/.vim"
    cp -R templates/Plantillas "/home/$local_user/"
    cp -R bin "/home/$local_user/"
    mkdir "/home/$local_user/.ssh"
    cp templates/authorized_keys "/home/$local_user/.ssh/" 
    chown -R $local_user:$local_user "/home/$local_user/.vimrc" "/home/$local_user/.ssh" \
        "/home/$local_user/.bashrc" "/home/$local_user/.bash_aliases" \
        "/home/$local_user/.vim"
    chmod -R 0700 /home/$local_user/.ssh
    echo "source ~/.bashrc" >> "/home/$local_user/.profile"
}

configure_grub() {
    echo "GRUB_RECORDFAIL_TIMEOUT=5" >> /etc/default/grub
    update-grub
    etccommiter "Configure grub"
}

configure_modsecurity_owasp() {
    mkdir /etc/apache2/modsecurity.d
    git clone https://github.com/SpiderLabs/owasp-modsecurity-crs /etc/apache2/modsecurity.d
    cp /etc/apache2/modsecurity.d/crs-setup.conf.example /etc/apache2/modsecurity.d/crs-setup.conf
    cp /etc/apache2/modsecurity.d/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example \
        /etc/apache2/modsecurity.d/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
    cp /etc/apache2/modsecurity.d/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example \
        /etc/apache2/modsecurity.d/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
    cp templates/security2 /etc/apache2/mods-available/security2.conf
    modsecrec="/etc/modsecurity/modsecurity.conf"
    sed s/SecRuleEngine\ DetectionOnly/SecRuleEngine\ On/g $modsecrec > /tmp/salida
    mv /tmp/salida /etc/modsecurity/modsecurity.conf
    echo -n "Firma servidor: "; read firmaserver
    echo -n "Powered: "; read poweredby
    modseccrs10su="/etc/apache2/modsecurity.d/crs-setup.conf"
    echo "SecServerSignature \"$firmaserver\"" >> $modseccrs10su
    echo "Header set X-Powered-By \"$poweredby\"" >> $modseccrs10su
    a2enmod headers
    /etc/init.d/apache2 restart
    etccommiter "Configure modsecurity owasp"
}

configure_apache() {
    cp templates/apache /etc/apache2/apache2.conf
    /etc/init.d/apache2 restart
    etccommiter "Configure apache2"
}

configure_iptables() {
    OUTIF=$(ip route get 8.8.8.8 | awk '{print $5}')
    : ${WANIP:=""}

    if [ "$WANIP" == "" ]; then
        WANIP=$(hostname -I | awk '{print $1}')
    fi

    /sbin/iptables --flush

    # Por defecto impedir todo el tráfico de entrada y pero permitir todo el
    # tráfico saliente.
    /sbin/iptables --policy INPUT DROP
    /sbin/iptables --policy FORWARD DROP
    /sbin/iptables --policy OUTPUT ACCEPT

    # Permitir todo el tráfico entrante de la interfaz de loopback
    /sbin/iptables -A INPUT -i lo -j ACCEPT

    # Habilitar el retorno de paquetes
    /sbin/iptables -A INPUT -i $OUTIF -m state --state RELATED,ESTABLISHED -j ACCEPT

    # Allow icmp input so that people can ping us
    /sbin/iptables -A INPUT -p icmp --icmp-type 8 -m state --state NEW -j ACCEPT

    # Perimtir conexiones de IPs concretas
    # /sbin/iptables -A INPUT -p tcp -i $OUTIF -m state --state NEW -s xxxxxxxx -j ACCEPT

    # Permitir el siguiente tráfico entrante
    # ssh
    /sbin/iptables -A INPUT -p tcp -i $OUTIF --dport $port -m state --state NEW -j ACCEPT

    # Check new packets are SYN packets for syn-flood protection
    /sbin/iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

    # Drop fragmented packets
    /sbin/iptables -A INPUT -f -j DROP

    # Drop malformed XMAS packets
    /sbin/iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

    # Drop null packets
    /sbin/iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

    # Log then drop any packets that are not allowed. You will probably want to turn off the logging
    #/sbin/iptables -A INPUT -j LOG
    /sbin/iptables -A INPUT -j REJECT

    # permitimos el acceso HTTPS y HTTP a determinadas webs
    /sbin/iptables -N ACCESO_HTTP
    /sbin/iptables -A ACCESO_HTTP --src $WANIP -j ACCEPT
    /sbin/iptables -I ACCESO_HTTP 1 --src $CLIENTE -j ACCEPT
    # bloquear y logear ciertas IPs (debe ir antes del ACCEPT general)
    # /sbin/iptables -A ACCESO_HTTP --src XXXXX -j LOG
    # /sbin/iptables -A ACCESO_HTTP --src XXXXX -j DROP
    /sbin/iptables -A ACCESO_HTTP -j ACCEPT # DROP si queremos ser mas restrictivos
    /sbin/iptables -I INPUT -m tcp -p tcp --dport 443 -j ACCESO_HTTP
    /sbin/iptables -I INPUT -m tcp -p tcp --dport 80  -j ACCESO_HTTP

    # guardamos las tablas permanentemente (estas quedan en /etc/sysconfig/iptables; es equivalente a 
    # iptables-save > /etc/sysconfig/iptables):
    apt install -y iptables-persistent
    iptables-save > /etc/iptables/rules.v4
}

change_homes_file_mode_bites() {
    chmod -R 0700 /home/* /root;
    sed -i 's/DIR_MODE=0755/DIR_MODE=0700/' /etc/adduser.conf;
    etccommiter "set homes file mode bites to 0700"
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

configure_mysql() {
    mysql_secure_installation
    cp templates/mysql /etc/mysql/my.cnf
}

restart_services() {
    /etc/init.d/ssh restart
    /etc/init.d/apache2 restart
    /etc/init.d/fail2ban restart
    /etc/init.d/mysql restart
}
