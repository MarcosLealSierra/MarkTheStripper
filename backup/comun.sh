#! /bin/bash
# Variables y funciones comunes a los scripts del sistema de backup
# vim:ts=4:sw=4:et:ft=sh
# Created: 2008-07-29
# Copyright (c) 2008: Hilario J. Montoliu <hmontoliu@gmail.com>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.  See http://www.gnu.org/copyleft/gpl.html for
# the full text of the license.

# Usuario del sistema sin privilegios (normalmente bofh01):
SYSTEMUSER=bofh01

# Usuario al que se le envían los mensajes de error (pueden ser cuentas reales)
# lo mejor es utilizar un usuario local y gestionar el correo desde otro sitio
# (ver conf. por defecto de los servidores donde se instala msmtp y procmail
# para reenviar a una cuenta externa el correo según reglas definidas en ese
# sistema. En el caso normal usar $SYSTEMUSER en TO y FROM
TO=$SYSTEMUSER
FROM=$SYSTEMUSER

# Directorio raiz donde se guardan las copias de seguridad
BACKUP_BASE_DIR=/var/local/backups/

# Directorio para los archivos de configuración y plugins
SETTINGS_DIR="/etc/backup"

# Prioridad I/O (default 3 idle)
IONICEPR=3

# Fichero con el listado de los elementos a incluir en el backup
INCLUDE_FILE="${SETTINGS_DIR}/include" 

# Fichero con el listado de los elementos a excluir en el backup
EXCLUDE_FILE="${SETTINGS_DIR}/exclude" 

# Directorio (run-parts) con scripts o plugins para ejecutar antes del backup
PREEVENTS_DIR="${SETTINGS_DIR}/prerespaldo/"

# Directorio (run-parts) con scripts o plugins para ejecutar despues del backup
POSTEVENTS_DIR="${SETTINGS_DIR}/postrespaldo/"

# Prefijo para el directorio que guarda los backups de cada dia.
COPIA="copia_dia"

# Nombre del directorio que guarda la copia actual.
COPIA_ACTUAL="${BACKUP_BASE_DIR}/${COPIA}_0"

# Opciones extra para el comando rsync; las opciones por defecto no deben ser
# cambiadas y están en el script de backup
EXTRA_RSYNC_OPTS=

# Directorio donde se registran los eventos del sistema de copias de seguridad.
LOGDIR="${BACKUP_BASE_DIR}/log"

# Fichero lock para comprobar si el proceso ha concluido. La comprobación se
# hace mediante un script lanzado junto con backup y que "duerme durante 4h".
# En el caso de encontrar el fichero lock envía un correo de advertencia
# Una segunda comprobación se hace mediante crontab a las 8:00
: ${LOCKDIR:="/var/lock/backup"}
mkdir -p "$LOCKDIR"
: ${LOCKFILE:="${LOCKDIR}/$(date +'%Y%m%d').lock"}

# Nombre del fichero de log (solo se genera si no existe (con esto nos
# aseguramos que solo se genere en el primer "source"))
: ${LOGFILE:="${LOGDIR}/backup.$(date +'%Y%m%d%H%M').log"} # TODO: usar log sistema.
GZLOGFILE=${LOGFILE}.gz
export LOGFILE GZLOGFILE

# echo "LOGFILE=$LOGFILE" >> "$LOCKFILE" en el script de backup

# Cadenas de mensaje inicio/fin backup -- para el análisis del log.
INI_BACKUP_STR="Iniciando backup."
END_BACKUP_STR="Backup finalizado."

# Funciones auxiliares:
ahora () { # devuelve la fecha actual 
    printf "%s" "$(date +'%b %d %H:%M:%S')"
}

evento () { # registro eventos log.
    printf "%s: %s\n" "$(ahora)" "$@" | tee -a ${LOGFILE}
}

loglastresult () { # registra en el log el resultado de una accion
    err=$1
    okstring="$2"
    errstring="$3"
    if [ $err == 0 ]; then
        evento "$okstring"
    else
        evento "$errstring"
    fi
}

cleanup () { # salir dignamente tras errores registrando el hecho en el log
    evento "ERROR: Backup finalizado por errores"
    exit 1
}

touchlockfile () {
    touch "$LOCKFILE"
}

rmlockfile () {
    rm -f "$LOCKFILE"
}

cat_logfile () {
    LINES=$(wc -l $LOGFILE | awk '{print $1}')
    if [[ $LINES -gt 40 ]];
    then 
        head -15 $LOGFILE
        echo ...
        tail -15 $LOGFILE
    else
        cat $LOGFILE
    fi
}

gzip_logfile () {
    gzip -c $LOGFILE > $GZLOGFILE
}

export -f gzip_logfile cat_logfile

email_log() { # envía el log del backup (usado desde watchdog, mailbackuperrores, etc
    # Las siguientes variables pueden definirse en otra parte:
    : ${TO:=$USER} 
    : ${FROM:=$USER}
    : ${SYSTEMUSER:=bofh01}
    : ${SERVIDOR:=$(hostname -s)}
    : ${SUBJECT:="${SERVIDOR}: Errores durante el backup"}
    : ${TEXTO:="Errores encontrados durante el proceso de backup.Adjunto ${LOGFILE}"}

    BODY="${TEXTO}"
    FOOTER="EMAIL AUTOMATICO; No responder."
    gzip_logfile


mutt $TO -s "$SUBJECT" -a $GZLOGFILE <<- EOF
${BODY}

$(cat_logfile)
-- 
${FOOTER}
EOF
}
