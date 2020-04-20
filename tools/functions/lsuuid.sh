#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#			function lsuuid
#------------------------------------------------------
#	Muestra el UUID del sistema de ficheros
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	lsuuid [device | directorio | fichero]
#
#	si no se especifica será el directorio actual
#
#	Requiere del script lsdev
#
#######################################################

# dependencias
source "$LIB_DIR/lsdev.sh"

function lsuuid(){
    if [ -z "$1" ]; then
        source=$(realpath ".")
    else
        source=$(realpath "$1")
    fi
    
    if [ ! -e "$source" ]; then return 1; fi

    info=$(file -b "$source")

    if [[ ! "$info" =~ "block special" ]]; then
        source=$(lsdev "$source")
    fi
    sudo lsblk -n -o UUID "$source"
    return 0
}