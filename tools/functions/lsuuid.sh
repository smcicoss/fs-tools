#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#			function lsuuid
#------------------------------------------------------
# Muestra el UUID del sistema de ficheros
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
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ -z "$1" ]; then
        source=$(realpath ".")
    elif [ $1 == "--all" ]; then
        local all="True"
    else
        source=$(realpath "$1")
    fi
    
    if [ ! "$all" ]; then
        if [ ! -e "$source" ]; then return 1; fi

        info=$(file -b "$source")

        if [[ ! "$info" =~ "block special" ]]; then
            source=$(lsdev "$source")
        fi
        
        sudo lsblk -n -o UUID "$source" | sed '/^ *$/d'
        return 0
    else
        for fname in /dev/disk/by-uuid/*; do
            echo $(basename $fname)
        done
        return 0
    fi
}
