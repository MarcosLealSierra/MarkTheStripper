#! /bin/bash
# vim:ts=4:sw=4:et:ft=sh
# Envia el log de backup por correo si se ha producido algun error.
# Llamado por backup al terminar (EXIT) o al atrapar SIGTERM, SIGINT...
# mailbackuperrores.sh -- es el nombre usado al terminar (EXIT) backup
# mailbackuptermerroes.sh -- es el nombre usado cuando backup aborta.
# Created: 2008-08-18
# Copyright (c) 2008: Hilario J. Montoliu <hmontoliu@gmail.com>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.  See http://www.gnu.org/copyleft/gpl.html for
# the full text of the license.

source /etc/backup/comun.sh
ERRORES=0

case $BASENAME in
    mailbackuperrores.sh)
        ERRORES=0
        # Verificar si el log contiene errores
        #if grep -qi '.[^/]*error' "$LOGFILE"; then
        # (?i) ignore case
        # no hay '/' delante de error (no es un nombre de fichero)
        # "error" es una palabra entera.
        if grep -qP '(?i)(?<!/)\berror\b' "$LOGFILE"; then
            ERRORES=1
        fi
    ;;
    mailbackuptermerrores.sh)
        ERRORES=1
    ;;
esac

if [ "$ERRORES" != 0 ]; then
    # errores
    email_log
#-#    else
#-#    # sin errores (para clientes que quieran informe diario
#-#
#-#        TEXTO="Backup a USB finalizado sin errores" \
#-#        SUBJECT="${SERVIDOR} [backup semanal] Backup a USB finalizado correctamente" \
#-#        email_log
fi

