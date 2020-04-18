#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#						fstype
#------------------------------------------------------
#	Muestra el sistema de ficheros de una partición o
#       un directorio
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	fstype [device | directorio]
#
#	si no se especifica será el directorio actual
#
#	Requiere del script lsdev
#   En caso de indicar una partición no necesita estar
#       montada
#######################################################

function fstype(){
    if [ -z "$1" ]; then
        origen=$(realpath ".")
    else
        origen=$(realpath "$1")
    fi

    info=$(file -b "$origen")

    if [[ "$info" =~ "block special" ]]; then
        lsblk -n -o FSTYPE $origen
        return $?
    else
        df -T $(lsdev "$origen") | tail -n 1 | awk '{ print $2 }'
        return $?
    fi
}
