#! /bin/bash
# Script para empaquetar en tar.gz todos los scripts y ficheros realacionados
# con el sistema de copias de seguridad a partir de un fichero de listado que
# permite lineas en blanco y comentarios con #
# vim:ts=4:sw=4:et:ft=sh
# Created: 2008-02-29

# Copyright (c) 2008: Hilario J. Montoliu <hmontoliu@gmail.com>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.  See http://www.gnu.org/copyleft/gpl.html for
# the full text of the license.

# Obtiene un listado de los ficheros a empaquetar. No tiene en cuenta líneas en
# blanco ni comentarios (#).

CWD=$(dirname $0)

# parámetros de configuración:
source $CWD/comun.sh

SOURCE_FILE=$CWD/README # listado de ficheros a empaquetar. 
LIST=$(sed -n '/^#.*/d; s/\(.[^#]*\)#\?.*/\1/p' $SOURCE_FILE)
DATE=$(date +'%Y%m%d')

# Fichero de destino
DEST_FILE=/home/$SYSTEMUSER/backup_scripts_${DATE}.tar.gz

if tar cvfz $DEST_FILE $LIST;
    then 
        echo "[OK - $0] $DEST_FILE generado correctamente" >&2
    else
        echo "[WW - $0] error al generar $DEST_FILE" >&2
fi        
