EQUIPO=$1 # ej user@ip
ssh $1 "apt update && apt upgrade -y && apt install rsync"
rsync -avhP -e 'ssh' --exclude '.git' $PWD $EQUIPO:~/src/
