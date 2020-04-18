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

function lsuuid(){
    if [ -z "$1" ]; then
        origen=$(realpath ".")
    else
        origen=$(realpath "$1")
    fi
    
    if [ ! -e "$origen" ]; then return 1; fi

    sudo lsblk -n -o UUID $(lsdev "$origen")
    return 0
}