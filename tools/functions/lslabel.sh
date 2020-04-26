#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#			function label
#------------------------------------------------------
# Muestra la etiqueta de la partición
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	label [device | directorio | fichero]
#
#	si no se especifica será el directorio actual
#
#	Requiere del script indev
#
#######################################################

# dependencias
: ${LIB_DIR:="/lib/fs-tools"} #Directorio por defecto si no
                                # asignado en script padre

source "$LIB_DIR/lsdev.sh"

function lslabel(){
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

        sudo lsblk -no LABEL $source | sed '/^ *$/d'
        return $?
    else
        for fname in /dev/disk/by-label/*; do
            echo $(basename $fname)
        done
        return 0
    fi
}