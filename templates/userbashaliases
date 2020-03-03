# Apt
alias actualizar='sudo apt update && sudo apt upgrade'
alias limpiar-apt='sudo apt autoremove --purge && sudo apt autoclean'

# Files
alias rmpyc='find . -name "*.pyc" -type f -delete -print'

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

# Services
alias restart-apache='sudo systemctl restart apache2.service'
alias restart-mysql='sudo systemctl restart mariadb.service'
