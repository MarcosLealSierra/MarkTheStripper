#! /bin/bash
# <description>
# vim:ts=4:sw=4:et:ft=sh
# Created: 2009-02-18

# Copyright (c) 2009: Hilario J. Montoliu <hmontoliu@gmail.com>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.  See http://www.gnu.org/copyleft/gpl.html for
# the full text of the license.
 
. /etc/backup/comun.sh

if [ ! -e "$LOCKFILE" ]; then
    echo "no exisite $LOCKFILE"
    ls -l $LOCKFILE
    exit 0 # Todo ha ido bien.
fi

# obtenemos las variables del .lock
. "$LOCKFILE"

TEXTO="Advertencia, problemas durante el backup:
El fichero de lock "$LOCKFILE" no ha sido eliminado. 
    
Log del backup:

$(cat $LOGFILE)

Salida completa de ps:

$(ps aux)

Revisar el estado del proceso de backup"

email_log
