#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#			function label
#------------------------------------------------------
#	Muestra la etiqueta de la partición
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
source "$LIB_DIR/lsdev.sh"

function lslabel(){

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

    sudo lsblk -no LABEL $source
    return $?
}