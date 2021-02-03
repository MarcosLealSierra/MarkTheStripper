# Apt
alias actualizar='sudo apt update && sudo apt upgrade'
alias actualizables='sudo apt list --upgradable -a'
alias limpiar-apt='sudo apt autoremove --purge && sudo apt autoclean'

# Files
alias rmpyc='find . -name "*.pyc" -type f -delete -print'
alias rmappletrash='find . -name "*.DS_Store" -type f -delete -print'

# Firefox
alias firefox50='/home/mleal/Otros/firefox50/./firefox &'

# Git
alias firma-eBM='echo -e "-- Marcos Leal Sierra <mleal@ebmproyectos.com>"'
alias firma='echo -e "-- Marcos Leal Sierra <marcoslealsierra90@gmail.com>"'

# Imágenes
alias ver='shotwell'

# Network
alias gip='wget http://ipinfo.io/ip -qO -'
alias gip-dns='dig @resolver1.opendns.com ANY myip.opendns.com +short'

# Otros
alias rm='rm -drvi'
alias hora-exacta="date '+%H:%M:%S del %A %d/%m/%Y'"
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
	alias ls='ls -F --color=auto'
	alias ll='ls -lhF --color=auto'
	alias la='ls -AF --color=auto'
	alias lla='ls -lhAF --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Python
alias httpserver="python3 -m http.server"

# Rdesktop
alias rdpsecanet="xhost +; schroot -c chroot:stretch -- /opt/rdesktop-1.8.2/rdesktop localhost -u usuario -p xpp66dz10"

# Rutas
alias docu='cd /home/mleal/src/doc'
alias docu-perelin002='cd /home/mleal/src/doc/00ebmproyectos/ran/perelin002'
alias accesos='cd /home/mleal/src/accesos'
alias otros='cd /home/mleal/Otros'

# Services
alias restart-apache='sudo systemctl restart apache2.service'
alias restart-mysql='sudo systemctl restart mariadb.service'

# SSH
alias marcoslealsierra.com='ssh -p 7289 marcos@165.22.81.152'

# sudo
alias sudo_su='sudo su -l'

# TeamViewer
alias restart-teamviewer='sudo bash ~/Otros/teamviewer/teamviewer_clean.sh restart'

# Timestamp
alias timestamp='while read -r line; do echo "$(date "+%T %Y-%m-%d") $line"; done'

# VirtualBox
alias compactwin10='vboxmanage modifymedium --compact "/home/mleal/VirtualBox VMs/Windows 10/Windows 10.vdi"'
