#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#					mount-point
#------------------------------------------------------
# Obtiene el punto de montaje del dispositivo
#		en el que descansa el fichereo
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	mount-point [directorio | file | dispositivo]
#
#	Si no se especifica será el directorio actual
#	-s Salida concisa. Solo el nombre del
#		dispositivo
#
#######################################################

function mountpoint(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ $# -ne 0 ]; then
        origen=$(realpath "$1")
    else
        origen=$(realpath ".")
    fi

    if [ -d "$origen" ]; then
        #Si es un directorio tal cual
        origen="$origen/"
    fi

    df "$origen" | grep / | tr -s '[[:blank:]]' ' ' | cut -d " " -f 6
    return $?
}
